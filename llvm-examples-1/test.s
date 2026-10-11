	.file	"test.ll"
	.text
	.globl	avg                             # -- Begin function avg
	.p2align	4
	.type	avg,@function
avg:                                    # @avg
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, %eax
	addl	%esi, %eax
	movl	$2, %ecx
	cltd
	idivl	%ecx
	retq
.Lfunc_end0:
	.size	avg, .Lfunc_end0-avg
	.cfi_endproc
                                        # -- End function
	.globl	avg2                            # -- Begin function avg2
	.p2align	4
	.type	avg2,@function
avg2:                                   # @avg2
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%edi, -4(%rsp)
	movl	%esi, -8(%rsp)
	movl	%edi, %eax
	addl	%esi, %eax
	movl	%eax, -12(%rsp)
	addl	%esi, %edi
	movl	%edi, -4(%rsp)
	movl	-4(%rsp), %eax
	movl	$2, %ecx
	cltd
	idivl	%ecx
	retq
.Lfunc_end1:
	.size	avg2, .Lfunc_end1-avg2
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function avg3
.LCPI2_0:
	.long	0x40000000                      # float 2
	.text
	.globl	avg3
	.p2align	4
	.type	avg3,@function
avg3:                                   # @avg3
	.cfi_startproc
# %bb.0:                                # %entry
	addl	%esi, %edi
	cvtsi2ss	%edi, %xmm0
	movss	.LCPI2_0(%rip), %xmm1           # xmm1 = [2.0E+0,0.0E+0,0.0E+0,0.0E+0]
	divss	%xmm1, %xmm0
	retq
.Lfunc_end2:
	.size	avg3, .Lfunc_end2-avg3
	.cfi_endproc
                                        # -- End function
	.globl	main                            # -- Begin function main
	.p2align	4
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movl	$4, %edi
	movl	$5, %esi
	callq	avg3@PLT
	movaps	%xmm0, %xmm1
	movss	%xmm1, 12(%rsp)                 # 4-byte Spill
	cvttss2si	%xmm0, %rdi
	callq	println_int@PLT
	movb	$0, 23(%rsp)
	movb	$111, 22(%rsp)
	movb	$108, 21(%rsp)
	movb	$108, 20(%rsp)
	movb	$101, 19(%rsp)
	movb	$72, 18(%rsp)
	leaq	18(%rsp), %rdi
	callq	puts@PLT
	movss	12(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	movd	%xmm0, %eax
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym avg3
	.addrsig_sym println_int
	.addrsig_sym puts
