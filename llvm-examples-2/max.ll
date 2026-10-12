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
