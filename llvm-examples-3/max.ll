@dfmt = constant [5 x i8] c"H %d\00" 

declare void @printf(ptr %fmt, ...)

define i32 @main() {
  ;%r = call i32 @max(i32 3, i32 4)
  %r = call i32 @test2()
  ret i32 %r
}

; if (p1 && p2) return 42 else return 37
define i32 @test(i1 %p1, i1 %p2) {
entry:
  %cond = and i1 %p1, %p2
  %r = select i1 %cond, i32 42, i32 37
  ret i32 %r
}

define i1 @p1() {
  call void @printf(ptr @dfmt, i32 123)
  ret i1 false
}

define i1 @p2() {
  call void @printf(ptr @dfmt, i32 456)
  ret i1 true
}

; if (p1() && p2()) return 42 else return 37
define i32 @test2() {
entry:
  %p1 = call i1 @p1()
  br i1 %p1, label %p1t, label %elsebranch

p1t:
  %p2 = call i1 @p2()
  br i1 %p2, label %truebranch, label %elsebranch

;p1f:
;  br label %elsebranch
;
;p2t:
;  br label %truebranch
;
;p2f:
;  br label %elsebranch

truebranch:
  ret i32 42

elsebranch:
  ret i32 37
}

define i32 @max(i32 %a, i32 %b) {
entry:
  %cmp = icmp sgt i32 %a, %b
  br i1 %cmp, label %ares, label %bres
ares:
  ret i32 %a
bres:
  ret i32 %b
entry2:
  br i1 %cmp, label %ares, label %bres
}

define i32 @max2(i32 %a, i32 %b) {
entry:
  %cmp = icmp sgt i32 %a, %b
  br i1 %cmp, label %ares, label %bres
ares:
  ret i32 %a
bres:
  call i32 @max(i32 %a, i32 %b)
  ret i32 %b
}

define i64 @max64(i64 %a, i64 %b) {
entry:
  %cmp = icmp sgt i64 %a, %b
  br i1 %cmp, label %ares, label %bres
ares:
  ret i64 %a
bres:
  ret i64 %b
entry2:
  br i1 %cmp, label %ares, label %bres
}
