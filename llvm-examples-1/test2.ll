; ModuleID = 'test.ll'
source_filename = "test.ll"

@ffmt = constant [6 x i8] c"H %lf\00"

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define range(i32 -1073741824, 1073741824) i32 @avg(i32 %a, i32 %b) local_unnamed_addr #0 {
entry:
  %sum = add i32 %b, %a
  %res = sdiv i32 %sum, 2
  ret i32 %res
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define range(i32 -1073741824, 1073741824) i32 @avg2(i32 %a, i32 %b) local_unnamed_addr #0 {
entry:
  %tmp2 = add i32 %b, %a
  %res = sdiv i32 %tmp2, 2
  ret i32 %res
}

define float @avg3(i32 %a, i32 %b) local_unnamed_addr {
entry:
  %sum = add i32 %b, %a
  %fsum = sitofp i32 %sum to float
  tail call void @printf(ptr nonnull @ffmt, float %fsum)
  %res = fmul float %fsum, 5.000000e-01
  ret float %res
}

declare void @println_int(i32) local_unnamed_addr

declare void @printf(ptr, ...) local_unnamed_addr

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define i32 @max(i32 %a, i32 %b) local_unnamed_addr #0 {
entry:
  %a.b = tail call i32 @llvm.smax.i32(i32 %a, i32 %b)
  ret i32 %a.b
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define i32 @max2(i32 %a, i32 %b) local_unnamed_addr #0 {
entry:
  %a.b = tail call i32 @llvm.smax.i32(i32 %a, i32 %b)
  ret i32 %a.b
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define i32 @max3(i32 %a, i32 %b) local_unnamed_addr #0 {
entry:
  %a.b = tail call i32 @llvm.smax.i32(i32 %a, i32 %b)
  ret i32 %a.b
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define i32 @max4(i32 %a, i32 %b) local_unnamed_addr #0 {
entry:
  %res = tail call i32 @llvm.smax.i32(i32 %a, i32 %b)
  ret i32 %res
}

define noundef i32 @main() local_unnamed_addr {
entry:
  tail call void @println_int(i32 5)
  ret i32 5
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #1

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
