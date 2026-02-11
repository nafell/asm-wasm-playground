# greater.s - Compare two integers from CLI args (a > b)
# Usage: ./greater <a> <b>
# stdout: "1\n" if a > b, "0\n" otherwise
# stderr: "OK\n" on success, "ERR: need 2 args\n" on bad usage
# Pure x86-64 Linux syscalls, no libc

    .section .data
msg_ok:
    .ascii "OK\n"
    .equ msg_ok_len, . - msg_ok

msg_err:
    .ascii "ERR: need 2 args\n"
    .equ msg_err_len, . - msg_err

result_true:
    .ascii "1\n"
    .equ result_true_len, . - result_true

result_false:
    .ascii "0\n"
    .equ result_false_len, . - result_false

    .section .text
    .globl _start

# ---------------------------------------------------------
# _start: entry point
#   Stack layout on entry:
#     (%rsp)     = argc
#     8(%rsp)    = argv[0] (program name)
#     16(%rsp)   = argv[1]
#     24(%rsp)   = argv[2]
# ---------------------------------------------------------
_start:
    # Check argc == 3 (program name + 2 args)
    movq (%rsp), %rax
    cmpq $3, %rax
    jne .Lerror

    # Convert argv[1] -> integer in %rdi
    movq 16(%rsp), %rdi
    call atoi
    movq %rax, %r12         # r12 = a

    # Convert argv[2] -> integer in %rdi
    movq 24(%rsp), %rdi
    call atoi
    movq %rax, %r13         # r13 = b

    # Compare: greater(a, b)
    movq %r12, %rdi
    movq %r13, %rsi
    call greater

    # rax = 1 if a > b, 0 otherwise
    testq %rax, %rax
    jnz .Lprint_true

.Lprint_false:
    # write(1, "0\n", 2)
    movq $1, %rax
    movq $1, %rdi
    leaq result_false(%rip), %rsi
    movq $result_false_len, %rdx
    syscall
    jmp .Lsuccess

.Lprint_true:
    # write(1, "1\n", 2)
    movq $1, %rax
    movq $1, %rdi
    leaq result_true(%rip), %rsi
    movq $result_true_len, %rdx
    syscall

.Lsuccess:
    # write(2, "OK\n", 3)
    movq $1, %rax
    movq $2, %rdi
    leaq msg_ok(%rip), %rsi
    movq $msg_ok_len, %rdx
    syscall

    # exit(0)
    movq $60, %rax
    xorq %rdi, %rdi
    syscall

.Lerror:
    # write(2, "ERR: need 2 args\n", 17)
    movq $1, %rax
    movq $2, %rdi
    leaq msg_err(%rip), %rsi
    movq $msg_err_len, %rdx
    syscall

    # exit(1)
    movq $60, %rax
    movq $1, %rdi
    syscall

# ---------------------------------------------------------
# greater(a, b) -> rax
#   %rdi = a, %rsi = b
#   Returns 1 if a > b, else 0
# ---------------------------------------------------------
greater:
    xorq %rax, %rax         # rax = 0 (default: false)
    cmpq %rsi, %rdi         # compare a - b
    jle .Lgreater_done
    movq $1, %rax           # a > b -> return 1
.Lgreater_done:
    ret

# ---------------------------------------------------------
# atoi(str) -> rax
#   %rdi = pointer to null-terminated ASCII decimal string
#   Handles optional leading '-' for negative numbers
#   Returns signed 64-bit integer in %rax
# ---------------------------------------------------------
atoi:
    xorq %rax, %rax         # result = 0
    xorq %rcx, %rcx         # negative flag = 0

    # Check for leading '-'
    movb (%rdi), %dl
    cmpb $'-', %dl
    jne .Latoi_loop
    movq $1, %rcx           # set negative flag
    incq %rdi               # skip '-'

.Latoi_loop:
    movb (%rdi), %dl
    testb %dl, %dl          # null terminator?
    jz .Latoi_done

    subb $'0', %dl          # ASCII -> digit
    imulq $10, %rax         # result *= 10
    movzbq %dl, %rdx
    addq %rdx, %rax         # result += digit
    incq %rdi
    jmp .Latoi_loop

.Latoi_done:
    testq %rcx, %rcx        # negative?
    jz .Latoi_return
    negq %rax               # negate result
.Latoi_return:
    ret
