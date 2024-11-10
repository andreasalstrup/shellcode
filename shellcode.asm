
;section .data
;    hello db "Hello, World", 0x0A
;    bin_sh db "/bin//sh", 0

section .text
    global _start

_start:
    ; Write "Hello, World!" to stdout
    mov rax, 1
    mov rdi, 1
    lea rsi, [rel msg]
    mov rdx, 13
    syscall

    xor rax, rax
    push rax
    mov rax, 0x68732f2f6e69622f
    push rax

    ; Spawn shell
    mov rax, 59
    mov rdi, rsp ;bin_sh
    xor rsi, rsi
    xor rdx, rdx
    syscall

    ; Exit syscall
    mov rax, 60
    xor rdi, rdi
    syscall

msg:
    db "Hello, World!", 0x0A
