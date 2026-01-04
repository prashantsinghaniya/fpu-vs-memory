.section .data
bit_reverse:
    .float 0.000, 0.000 
    .float 8.000, 0.000
    .float 4.000, 0.000 
    .float 12.000, 0.000 
    .float 2.000, 0.000 
    .float 10.000, 0.000 
    .float 6.000, 0.000 
    .float 14.000, 0.000 
    .float 1.000, 0.000 
    .float 9.000, 0.000 
    .float 5.000, 0.000 
    .float 13.000, 0.000 
    .float 3.000, 0.000 
    .float 11.000, 0.000 
    .float 7.000, 0.000 
    .float 15.000, 0.000 

twiddle_factors_fpu:
    .float 1.0000, 0.0000       # W^0
    .float 0.9239, -0.3827      # W^1
    .float 0.7071, -0.7071      # W^2
    .float 0.3827, -0.9239      # W^3
    .float 0.0000, -1.0000      # W^4
    .float -0.3827, -0.9239     # W^5
    .float -0.7071, -0.7071     # W^6
    .float -0.9239, -0.3827     # W^7

# Buffer for printing
int_buf:
    .space 16
space:
    .ascii " "
newline:
    .ascii "\n"

.text 
.globl main

main:
    la a0 , bit_reverse
    la a1, twiddle_factors_fpu

    # ==========================================
    # STAGE 1 (m=2) - 8 Butterflies
    # Span = 1. Twiddle = W^0 for all.
    # ==========================================

    # Block 1 (Indices 0,1)
    flw     f24, 0(a1)      # Load W^0 Real
    flw     f25, 4(a1)      # Load W^0 Imag
    flw     f0, 0(a0)       # In 0 R
    flw     f1, 4(a0)       # In 0 I
    flw     f2, 8(a0)       # In 1 R
    flw     f3, 12(a0)      # In 1 I

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 0(a0)
    fsw     f1, 4(a0)
    fsw     f2, 8(a0)
    fsw     f3, 12(a0)

    # Block 2 (Indices 2,3)
    flw     f24, 0(a1)      # Re-load W^0
    flw     f25, 4(a1)
    flw     f0, 16(a0)
    flw     f1, 20(a0)
    flw     f2, 24(a0)
    flw     f3, 28(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 16(a0)
    fsw     f1, 20(a0)
    fsw     f2, 24(a0)
    fsw     f3, 28(a0)

    # Block 3 (Indices 4,5)
    flw     f24, 0(a1)      # Re-load W^0
    flw     f25, 4(a1)
    flw     f0, 32(a0)
    flw     f1, 36(a0)
    flw     f2, 40(a0)
    flw     f3, 44(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 32(a0)
    fsw     f1, 36(a0)
    fsw     f2, 40(a0)
    fsw     f3, 44(a0)

    # Block 4 (Indices 6,7)
    flw     f24, 0(a1)      # Re-load W^0
    flw     f25, 4(a1)
    flw     f0, 48(a0)
    flw     f1, 52(a0)
    flw     f2, 56(a0)
    flw     f3, 60(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 48(a0)
    fsw     f1, 52(a0)
    fsw     f2, 56(a0)
    fsw     f3, 60(a0)

    # Block 5 (Indices 8,9)
    flw     f24, 0(a1)      # Re-load W^0
    flw     f25, 4(a1)
    flw     f0, 64(a0)
    flw     f1, 68(a0)
    flw     f2, 72(a0)
    flw     f3, 76(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 64(a0)
    fsw     f1, 68(a0)
    fsw     f2, 72(a0)
    fsw     f3, 76(a0)

    # Block 6 (Indices 10,11)
    flw     f24, 0(a1)      # Re-load W^0
    flw     f25, 4(a1)
    flw     f0, 80(a0)
    flw     f1, 84(a0)
    flw     f2, 88(a0)
    flw     f3, 92(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 80(a0)
    fsw     f1, 84(a0)
    fsw     f2, 88(a0)
    fsw     f3, 92(a0)

    # Block 7 (Indices 12,13)
    flw     f24, 0(a1)      # Re-load W^0
    flw     f25, 4(a1)
    flw     f0, 96(a0)
    flw     f1, 100(a0)
    flw     f2, 104(a0)
    flw     f3, 108(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 96(a0)
    fsw     f1, 100(a0)
    fsw     f2, 104(a0)
    fsw     f3, 108(a0)

    # Block 8 (Indices 14,15)
    flw     f24, 0(a1)      # Re-load W^0
    flw     f25, 4(a1)
    flw     f0, 112(a0)
    flw     f1, 116(a0)
    flw     f2, 120(a0)
    flw     f3, 124(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 112(a0)
    fsw     f1, 116(a0)
    fsw     f2, 120(a0)
    fsw     f3, 124(a0)


    # ==========================================
    # STAGE 2 (m=4) - 8 Butterflies
    # Span = 2. Twiddles = W^0, W^4
    # ==========================================
    
    # Block 1 (Indices 0,2) - Use W^0
    flw     f24, 0(a1)
    flw     f25, 4(a1)
    flw     f0, 0(a0)
    flw     f1, 4(a0)
    flw     f2, 16(a0)
    flw     f3, 20(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 0(a0)
    fsw     f1, 4(a0)
    fsw     f2, 16(a0)
    fsw     f3, 20(a0)

    # Block 2 (Indices 4,6) - Use W^0
    flw     f24, 0(a1)      # Re-load W^0
    flw     f25, 4(a1)
    flw     f0, 32(a0)
    flw     f1, 36(a0)
    flw     f2, 48(a0)
    flw     f3, 52(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 32(a0)
    fsw     f1, 36(a0)
    fsw     f2, 48(a0)
    fsw     f3, 52(a0)

    # Block 3 (Indices 8,10) - Use W^0
    flw     f24, 0(a1)      # Re-load W^0
    flw     f25, 4(a1)
    flw     f0, 64(a0)
    flw     f1, 68(a0)
    flw     f2, 80(a0)
    flw     f3, 84(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 64(a0)
    fsw     f1, 68(a0)
    fsw     f2, 80(a0)
    fsw     f3, 84(a0)

    # Block 4 (Indices 12,14) - Use W^0
    flw     f24, 0(a1)      # Re-load W^0
    flw     f25, 4(a1)
    flw     f0, 96(a0)
    flw     f1, 100(a0)
    flw     f2, 112(a0)
    flw     f3, 116(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 96(a0)
    fsw     f1, 100(a0)
    fsw     f2, 112(a0)
    fsw     f3, 116(a0)

    # Block 5 (Indices 1,3) - Use W^4
    flw     f24, 32(a1)     # Load W^4
    flw     f25, 36(a1)
    flw     f0, 8(a0)
    flw     f1, 12(a0)
    flw     f2, 24(a0)
    flw     f3, 28(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 8(a0)
    fsw     f1, 12(a0)
    fsw     f2, 24(a0)
    fsw     f3, 28(a0)

    # Block 6 (Indices 5,7) - Use W^4
    flw     f24, 32(a1)     # Re-load W^4
    flw     f25, 36(a1)
    flw     f0, 40(a0)
    flw     f1, 44(a0)
    flw     f2, 56(a0)
    flw     f3, 60(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 40(a0)
    fsw     f1, 44(a0)
    fsw     f2, 56(a0)
    fsw     f3, 60(a0)

    # Block 7 (Indices 9,11) - Use W^4
    flw     f24, 32(a1)     # Re-load W^4
    flw     f25, 36(a1)
    flw     f0, 72(a0)
    flw     f1, 76(a0)
    flw     f2, 88(a0)
    flw     f3, 92(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 72(a0)
    fsw     f1, 76(a0)
    fsw     f2, 88(a0)
    fsw     f3, 92(a0)

    # Block 8 (Indices 13,15) - Use W^4
    flw     f24, 32(a1)     # Re-load W^4
    flw     f25, 36(a1)
    flw     f0, 104(a0)
    flw     f1, 108(a0)
    flw     f2, 120(a0)
    flw     f3, 124(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 104(a0)
    fsw     f1, 108(a0)
    fsw     f2, 120(a0)
    fsw     f3, 124(a0)


    # ==========================================
    # STAGE 3 (m=8) - 8 Butterflies
    # Span = 4. Twiddles = W^0, W^2, W^4, W^6
    # ==========================================
    
    # Block 1 (Indices 0,4) - Use W^0
    flw     f24, 0(a1)
    flw     f25, 4(a1)
    flw     f0, 0(a0)
    flw     f1, 4(a0)
    flw     f2, 32(a0)
    flw     f3, 36(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 0(a0)
    fsw     f1, 4(a0)
    fsw     f2, 32(a0)
    fsw     f3, 36(a0)

    # Block 2 (Indices 8,12) - Use W^0
    flw     f24, 0(a1)      # Re-load W^0
    flw     f25, 4(a1)
    flw     f0, 64(a0)
    flw     f1, 68(a0)
    flw     f2, 96(a0)
    flw     f3, 100(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 64(a0)
    fsw     f1, 68(a0)
    fsw     f2, 96(a0)
    fsw     f3, 100(a0)

    # Block 3 (Indices 1,5) - Use W^2
    flw     f24, 16(a1)     # Load W^2
    flw     f25, 20(a1)
    flw     f0, 8(a0)
    flw     f1, 12(a0)
    flw     f2, 40(a0)
    flw     f3, 44(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 8(a0)
    fsw     f1, 12(a0)
    fsw     f2, 40(a0)
    fsw     f3, 44(a0)

    # Block 4 (Indices 9,13) - Use W^2
    flw     f24, 16(a1)     # Re-load W^2
    flw     f25, 20(a1)
    flw     f0, 72(a0)
    flw     f1, 76(a0)
    flw     f2, 104(a0)
    flw     f3, 108(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 72(a0)
    fsw     f1, 76(a0)
    fsw     f2, 104(a0)
    fsw     f3, 108(a0)

    # Block 5 (Indices 2,6) - Use W^4
    flw     f24, 32(a1)     # Load W^4
    flw     f25, 36(a1)
    flw     f0, 16(a0)
    flw     f1, 20(a0)
    flw     f2, 48(a0)
    flw     f3, 52(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 16(a0)
    fsw     f1, 20(a0)
    fsw     f2, 48(a0)
    fsw     f3, 52(a0)

    # Block 6 (Indices 10,14) - Use W^4
    flw     f24, 32(a1)     # Re-load W^4
    flw     f25, 36(a1)
    flw     f0, 80(a0)
    flw     f1, 84(a0)
    flw     f2, 112(a0)
    flw     f3, 116(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 80(a0)
    fsw     f1, 84(a0)
    fsw     f2, 112(a0)
    fsw     f3, 116(a0)

    # Block 7 (Indices 3,7) - Use W^6
    flw     f24, 48(a1)     # Load W^6
    flw     f25, 52(a1)
    flw     f0, 24(a0)
    flw     f1, 28(a0)
    flw     f2, 56(a0)
    flw     f3, 60(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 24(a0)
    fsw     f1, 28(a0)
    fsw     f2, 56(a0)
    fsw     f3, 60(a0)

    # Block 8 (Indices 11,15) - Use W^6
    flw     f24, 48(a1)     # Re-load W^6
    flw     f25, 52(a1)
    flw     f0, 88(a0)
    flw     f1, 92(a0)
    flw     f2, 120(a0)
    flw     f3, 124(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 88(a0)
    fsw     f1, 92(a0)
    fsw     f2, 120(a0)
    fsw     f3, 124(a0)


    # ==========================================
    # STAGE 4 (m=16) - 8 Butterflies
    # Span = 8. Twiddles = W^0 to W^7
    # ==========================================
    
    # Block 1 (Indices 0,8) - W^0
    flw     f24, 0(a1)
    flw     f25, 4(a1)
    flw     f0, 0(a0)
    flw     f1, 4(a0)
    flw     f2, 64(a0)
    flw     f3, 68(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 0(a0)
    fsw     f1, 4(a0)
    fsw     f2, 64(a0)
    fsw     f3, 68(a0)

    # Block 2 (Indices 1,9) - W^1
    flw     f24, 8(a1)
    flw     f25, 12(a1)
    flw     f0, 8(a0)
    flw     f1, 12(a0)
    flw     f2, 72(a0)
    flw     f3, 76(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 8(a0)
    fsw     f1, 12(a0)
    fsw     f2, 72(a0)
    fsw     f3, 76(a0)

    # Block 3 (Indices 2,10) - W^2
    flw     f24, 16(a1)
    flw     f25, 20(a1)
    flw     f0, 16(a0)
    flw     f1, 20(a0)
    flw     f2, 80(a0)
    flw     f3, 84(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 16(a0)
    fsw     f1, 20(a0)
    fsw     f2, 80(a0)
    fsw     f3, 84(a0)

    # Block 4 (Indices 3,11) - W^3
    flw     f24, 24(a1)
    flw     f25, 28(a1)
    flw     f0, 24(a0)
    flw     f1, 28(a0)
    flw     f2, 88(a0)
    flw     f3, 92(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 24(a0)
    fsw     f1, 28(a0)
    fsw     f2, 88(a0)
    fsw     f3, 92(a0)

    # Block 5 (Indices 4,12) - W^4
    flw     f24, 32(a1)
    flw     f25, 36(a1)
    flw     f0, 32(a0)
    flw     f1, 36(a0)
    flw     f2, 96(a0)
    flw     f3, 100(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 32(a0)
    fsw     f1, 36(a0)
    fsw     f2, 96(a0)
    fsw     f3, 100(a0)

    # Block 6 (Indices 5,13) - W^5
    flw     f24, 40(a1)
    flw     f25, 44(a1)
    flw     f0, 40(a0)
    flw     f1, 44(a0)
    flw     f2, 104(a0)
    flw     f3, 108(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 40(a0)
    fsw     f1, 44(a0)
    fsw     f2, 104(a0)
    fsw     f3, 108(a0)

    # Block 7 (Indices 6,14) - W^6
    flw     f24, 48(a1)
    flw     f25, 52(a1)
    flw     f0, 48(a0)
    flw     f1, 52(a0)
    flw     f2, 112(a0)
    flw     f3, 116(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 48(a0)
    fsw     f1, 52(a0)
    fsw     f2, 112(a0)
    fsw     f3, 116(a0)

    # Block 8 (Indices 7,15) - W^7
    flw     f24, 56(a1)
    flw     f25, 60(a1)
    flw     f0, 56(a0)
    flw     f1, 60(a0)
    flw     f2, 120(a0)
    flw     f3, 124(a0)

    fmul.s f16, f2, f24
    fmul.s f17, f3, f25
    fmul.s f18, f2, f25
    fmul.s f19, f3, f24
    fsub.s f16, f16, f17
    fadd.s f17, f18, f19

    fsub.s f2, f0, f16
    fsub.s f3, f1, f17
    fadd.s f0, f0, f16
    fadd.s f1, f1, f17

    fsw     f0, 56(a0)
    fsw     f1, 60(a0)
    fsw     f2, 120(a0)
    fsw     f3, 124(a0)

finish:
    # --- PRINTING LOGIC ---
    # Calls print_results to output the final array
    jal ra, print_results

    # Exit Syscall
    li a7, 93
    li a0, 0
    ecall

# ==========================================
# Print Results Function
# Iterates through the bit_reverse array, 
# converts floats to integers, and prints them.
# ==========================================
print_results:
    addi sp, sp, -16
    sd   ra, 0(sp)
    sd   s0, 8(sp)

    la   s0, bit_reverse    # Pointer to array
    li   t6, 32             # 32 floats to print (16 complex numbers)

print_loop:
    beqz t6, print_done
    
    # Load float value
    flw  f0, 0(s0)
    
    # Convert float to signed integer for printing
    # Note: This truncates the decimal part.
    fcvt.w.s a0, f0
    
    # Call print_int (as in matrix multiplication)
    jal  ra, print_int

    # Print space
    li   a0, 1
    la   a1, space
    li   a2, 1
    li   a7, 64
    ecall

    addi s0, s0, 4          # Next float
    addi t6, t6, -1         # Decrement counter
    j    print_loop

print_done:
    # Print newline at end
    li   a0, 1
    la   a1, newline
    li   a2, 1
    li   a7, 64
    ecall

    ld   ra, 0(sp)
    ld   s0, 8(sp)
    addi sp, sp, 16
    ret

# ==========================================
# print_int: print signed integer in a0
# (Copied from Matrix Multiplication Example)
# ==========================================
print_int:
    addi sp, sp, -32
    sd   ra, 0(sp)
    sd   s0, 8(sp)      # save s0 used as temp for sign
    sd   s1, 16(sp)     # save s1
    sd   s2, 24(sp)     # save s2

    mv   s0, a0         # number to print (signed)
    li   s1, 0          # sign flag (0 = positive)

    # handle zero explicitly
    beqz s0, print_zero

    # handle negative numbers
    bltz s0, make_pos
    j    print_digits

make_pos:
    neg  s0, s0
    li   s1, 1          # mark negative

print_digits:
    la   t1, int_buf+12    # points one past end (we'll write backwards)
    li   t2, 10
digit_loop:
    rem  t3, s0, t2        # remainder (signed rem ok because s0 >=0 here)
    div  s0, s0, t2
    addi t3, t3, 48        # ascii
    addi t1, t1, -1
    sb   t3, 0(t1)
    bnez s0, digit_loop

    # if negative, put '-' sign
    beqz s1, digits_done
    addi t1, t1, -1
    li   t3, 45
    sb   t3, 0(t1)

digits_done:
    # write fd=1, buf=t1, len = (int_buf+12) - t1
    li   a0, 1
    mv   a1, t1
    la   a2, int_buf+12
    sub  a2, a2, t1
    li   a7, 64
    ecall
    j    print_int_restore

print_zero:
    # store '0' into buffer and write
    la   t1, int_buf+12
    addi t1, t1, -1
    li   t3, 48
    sb   t3, 0(t1)
    li   a0, 1
    mv   a1, t1
    li   a2, 1
    li   a7, 64
    ecall

print_int_restore:
    ld   ra, 0(sp)
    ld   s0, 8(sp)
    ld   s1, 16(sp)
    ld   s2, 24(sp)
    addi sp, sp, 32
    ret