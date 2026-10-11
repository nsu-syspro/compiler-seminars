define i32 @avg(i32 %a, i32 %b) {
entry:
  %sum = add i32 %a, %b
  %res = sdiv i32 %sum, 2
  ret i32 %res
}

define i32 @avg2(i32 %a, i32 %b) {
entry:
  %alocal = alloca i32
  %blocal = alloca i32
  store i32 %a, i32* %alocal
  store i32 %b, i32* %blocal

  ; store <ty> <src>, <ty*> <dst>
  ; <dst> = load <ty>, <ty*> <src>

  ; int c = (a + b);
  %c = alloca i32
  %tmp1 = add i32 %a, %b
  store i32 %tmp1, i32* %c

  %tmp2 = add i32 %a, %b
  store i32 %tmp2, ptr %alocal

  ; return a / 2
  %tmp3 = load i32, i32* %alocal
  %res = sdiv i32 %tmp3, 2
  ret i32 %res
}

@ffmt = constant [6 x i8] c"H %lf\00" 

define float @avg3(i32 %a, i32 %b) {
entry:
  %sum = add i32 %a, %b
  %fsum = sitofp i32 %sum to float
  call void @printf(ptr @ffmt, float %fsum)
  %res = fdiv float %fsum, 2.0
  ret float %res
}

declare void @println_int(i32 %val)

declare void @println_string(ptr %str)

declare void @printf(ptr %fmt, ...)

define i32 @max(i32 %a, i32 %b) {
entry:
  ; if (a > b)
  %cmp = icmp sgt i32 %a, %b
  br i1 %cmp, label %ares, label %bres

ares:
  ret i32 %a 

bres:
  ret i32 %b 
}

define i32 @max2(i32 %a, i32 %b) {
entry:
  %res = alloca i32

  ; if (a > b)
  %cmp = icmp sgt i32 %a, %b
  br i1 %cmp, label %ares, label %bres

ares:
  store i32 %a, ptr %res
  br label %resblock

bres:
  store i32 %b, ptr %res
  br label %resblock

resblock:
  %val = load i32, ptr %res
  ret i32 %val
}

define i32 @max3(i32 %a, i32 %b) {
entry:
  ;%res = alloca i32

  ; if (a > b)
  %cmp = icmp sgt i32 %a, %b
  br i1 %cmp, label %ares, label %bres

ares:
  ;store i32 %a, ptr %res
  br label %resblock

bres:
  ;store i32 %b, ptr %res
  br label %resblock

resblock:
  ;%val = load i32, ptr %res
  %val = phi i32 [ %a, %ares ], [ %b, %bres ]
  ret i32 %val
}

define i32 @max4(i32 %a, i32 %b) {
entry:
  %cmp = icmp sgt i32 %a, %b
  %res = select i1 %cmp, i32 %a, i32 %b
  ret i32 %res
}

define i32 @main() {
entry:
  %res = call i32 @max3(i32 4, i32 5)
  call void @println_int(i32 %res)

  ;%loc = alloca i64
  ;store i64 u0x2a2a2a, ptr %loc
  ;%str = alloca [6 x i8]
  ;%strload = load [6 x i8], ptr %str
  ;store [6 x i8] c"H  %f\00", ptr %str
  ;call void @printf(ptr %str, float %fres)

  ;%res = bitcast float %fres to i32
  ret i32 %res
}
