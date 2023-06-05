section .data
    first_prompt db "Enter the text: ", 0
    len equ $ - first_prompt
	inputLen equ 64
section .bss
    first resb 64

section .text
    global _start
_start:
    ; Print prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, first_prompt
    mov edx, len
    int 0x80

    ; Read input
    mov eax, 3
    mov ebx, 0
    mov ecx, first
    mov edx, inputLen
    int 0x80

    ; Print the input
    mov eax, 4
    mov ebx, 1
    mov ecx, first
    mov edx, inputLen
    int 0x80

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80