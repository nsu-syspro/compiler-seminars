#include "llvm/IR/PassManager.h"
#include "llvm/IR/Function.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IRBuilder.h"

using namespace llvm;

namespace {

struct MaxFold : PassInfoMixin<MaxFold> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
    for (auto& BB : F) {
      // Match branch terminator
      auto br = dyn_cast<BranchInst>(BB.getTerminator());
      if (!br) continue;

      // Match icmp cond, %a, %b
      auto icmp = dyn_cast<ICmpInst>(br->getCondition());
      if (!icmp) continue;

      // Match cond > and >=
      switch (icmp->getPredicate()) {
      case CmpInst::ICMP_SGT:
      case CmpInst::ICMP_SGE:
        break;
      default:
        continue;
      }

      auto a = icmp->getOperand(0);
      auto b = icmp->getOperand(1);

      // Match only ret successors
      
      // True block
      auto tb = br->getSuccessor(0);
      auto tr = dyn_cast<ReturnInst>(tb->getTerminator());
      if (!tr || tr->getOperand(0) != a) continue;

      // Check empty block
      auto exit = false;
      for (auto &I : *tb) {
        if (dyn_cast<ReturnInst>(&I)) break;
        exit = true;
      }
      if (exit) continue;

      // False block
      auto fb = br->getSuccessor(1);
      auto fr = dyn_cast<ReturnInst>(fb->getTerminator());
      if (!fr || fr->getOperand(0) != b) continue;

      // Check empty block
      for (auto &I : *fb) {
        if (dyn_cast<ReturnInst>(&I)) break;
        exit = true;
      }
      if (exit) continue;

      //IRBuilder<> Builder(br);
      //auto sel = Builder.CreateSelect(icmp, a, b);
      //Builder.CreateRet(sel);
      
      IRBuilder<> Builder(br);
      //auto max = Builder.CreateIntrinsic(Intrinsic::smax, {a->getType()}, {a, b});
      auto max = Builder.CreateBinaryIntrinsic(Intrinsic::smax, a, b);
      Builder.CreateRet(max);

      br->eraseFromParent();
      //br->removeFromParent();
      // br->getParent() == nullptr

      for (auto B : {tb, fb}) {
        if (pred_empty(B)) {
          B->eraseFromParent();
        }
      }
    }
    return PreservedAnalyses::none();
  }
  static bool isRequired() { return true; }   // run even on optnone functions
};

struct SelectFold : PassInfoMixin<SelectFold> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
    for (auto& BB : F) {
      // Match branch terminator
      auto br = dyn_cast<BranchInst>(BB.getTerminator());
      if (!br) continue;

      if (br->isUnconditional()) continue;

      // Match only ret successors
      
      // True block
      auto tb = br->getSuccessor(0);
      auto tr = dyn_cast<ReturnInst>(tb->getTerminator());
      if (!tr) continue;

      // Check empty block
      auto exit = false;
      for (auto &I : *tb) {
        if (dyn_cast<ReturnInst>(&I)) break;
        exit = true;
      }
      if (exit) continue;

      // False block
      auto fb = br->getSuccessor(1);
      auto fr = dyn_cast<ReturnInst>(fb->getTerminator());
      if (!fr) continue;

      // Check empty block
      for (auto &I : *fb) {
        if (dyn_cast<ReturnInst>(&I)) break;
        exit = true;
      }
      if (exit) continue;

      auto cond = br->getCondition();
      auto a = tr->getOperand(0);
      auto b = fr->getOperand(0);

      IRBuilder<> Builder(br);
      auto sel = Builder.CreateSelect(cond, a, b);
      Builder.CreateRet(sel);

      br->eraseFromParent();
      //br->removeFromParent();
      // br->getParent() == nullptr

      for (auto B : {tb, fb}) {
        if (pred_empty(B)) {
          B->eraseFromParent();
        }
      }
    }
    return PreservedAnalyses::none();
  }
  static bool isRequired() { return true; }   // run even on optnone functions
};

struct MaxLowering : PassInfoMixin<MaxLowering> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
    for (auto& BB : F) {
    }
    return PreservedAnalyses::none();
  }
  static bool isRequired() { return true; }   // run even on optnone functions
};

struct PrintCFG : PassInfoMixin<PrintCFG> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
    outs() << "digraph \"" << F.getName() << "\" {\n";
    for (auto& BB : F) {
      outs() << "  \"" << BB.getName() << "\"\n";
      for (auto S : successors(&BB)) {
        outs() << "  \"" << BB.getName() << "\" -> \"" << S->getName() << "\"\n";
      }
    }
    outs() << "}\n";
    return PreservedAnalyses::all();
  }
  static bool isRequired() { return true; }   // run even on optnone functions
};

} // namespace

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "max-fold", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "max-fold") {
                    FPM.addPass(MaxFold());
                    return true;
                  }
                  if (Name == "select-fold") {
                    FPM.addPass(SelectFold());
                    return true;
                  }
                  if (Name == "max-lowering") {
                    FPM.addPass(MaxLowering());
                    return true;
                  }
                  if (Name == "print-cfg") {
                    FPM.addPass(PrintCFG());
                    return true;
                  }
                  return false;
                });
          }};
}

