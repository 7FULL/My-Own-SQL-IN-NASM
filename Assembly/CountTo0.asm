section .bss
    msg resb 1

section .text
    global _start

_start:
    mov eax,1
    mov ebx, 5
    cmp ebx,0
    jle final

    mov eax, 4
    mov ebx, 1
    mov ecx, "a"
    mov edx, 1
    int 80h
final:
    mov eax,1
    xor ebx,ebx
    int 80h
