# hello.s - x86-64 Linux Hello World (GAS/AT&T syntax)
# Syscall reference: https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/

    .section .data
message:
    .ascii "Hello, Assembly World!\n"
    .equ message_len, . - message

    .section .text
    .globl _start

_start:
    # write(1, message, message_len)
    movq $1, %rax           # syscall: write
    movq $1, %rdi           # fd: stdout
    leaq message(%rip), %rsi # buf: message address (RIP-relative)
    movq $message_len, %rdx # count: message length
    syscall

    # exit(0)
    movq $60, %rax          # syscall: exit
    xorq %rdi, %rdi         # status: 0
    syscall
