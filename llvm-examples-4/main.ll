@dfmt = constant [5 x i8] c"H %d\00" 

declare void @printf(ptr %fmt, ...)

;define internal i32 @square(i32 %x) {
;  %r = mul i32 %x, %x
;  call void @printf(ptr @dfmt, i32 %x)
;  ret i32 %r
;}

;define internal i32 @mul(i32 %x, i32 %y) {
;  %r = mul i32 %x, %y
;  ret i32 %r
;}

;define internal i32 @mul2(i32 %argc, i32 %x, i32 %y) {
;entry:
;  %m = alloca i32
;  %c = icmp sgt i32 %argc, 3
;  br i1 %c, label %abranch, label %bbranch
;abranch:
;  %a = mul i32 %x, %y
;  call void @printf(ptr @dfmt, i32 %x)
;  store i32 %a, ptr %m
;  br label %end
;
;bbranch:
;  %b = mul i32 %argc, %y
;  store i32 %b, ptr %m
;  br label %end
;
;end:
;  %r = load i32, ptr %m
;  ret i32 %r
;}
;
;define internal void @mul3(i32 %argc, i32 %x, i32 %y) {
;entry:
;  %m = alloca i32
;  %c = icmp sgt i32 %argc, 3
;  br i1 %c, label %abranch, label %bbranch
;abranch:
;  %a = mul i32 %x, %y
;  call void @printf(ptr @dfmt, i32 %x)
;  store i32 %a, ptr %m
;  br label %end
;
;bbranch:
;  %b = mul i32 %argc, %y
;  store i32 %b, ptr %m
;  br label %end
;
;end:
;  %r = load i32, ptr %m
;  ret void
;}

define internal i32 @sumtorial(i32 %n) {
entry:
  %m = alloca i32
  %c = icmp eq i32 %n, 0
  br i1 %c, label %zero, label %nonzero
zero:
  ret i32 0

nonzero:
  %n1 = sub i32 %n, 1
  %x = call i32 @sumtorial(i32 %n1)
  %r = add i32 %n, %x
  ret i32 %r
}

;@square_addr = global ptr @square

define i32 @main(i32 %argc) {
entry:
  ;%addr = load ptr, ptr @square_addr
  ;%r = call i32 %addr(i32 5)
  ;%r = call i32 @square(i32 5)
  ;%r = call i32 @mul(i32 5, i32 4)
  ;%s1 = call i32 @mul2(i32 5, i32 4, i32 5)
  ;call i32 @mul3(i32 5, i32 4, i32 5)
  %s = call i32 @sumtorial(i32 %argc)
  ret i32 %s
}

;define i32 @main(i32 %argc) {
;entry:
;  %m = alloca i32
;  %c = icmp sgt i32 %argc, 3
;  br i1 %c, label %abranch, label %bbranch
;abranch:
;  %a = mul i32 %argc, 4
;  store i32 %a, ptr %m
;  br label %end
;
;bbranch:
;  %b = mul i32 %argc, 4
;  store i32 %b, ptr %m
;  br label %end
;
;end:
;  %r = load i32, ptr %m
;  ret i32 %r
;}
