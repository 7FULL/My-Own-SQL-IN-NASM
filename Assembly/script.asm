global _start		; must be declared for linker

section .data

	first_prompt db "Enter the first number "		; first_prompt="Enter the first number "

	len_first_prompt equ $ - first_prompt		; len_first_prompt equals size of first_prompt

section .bss

	first resb 64		; Unitialized data variable first

section .text

_start:			; start label

	mov eax, 4		; sys_write system call

	mov ebx, 1		; stdout file descriptor

	mov ecx, first_prompt		; ecx=first_prompt

	mov edx, len_first_prompt		; edx=len_first_prompt

	int 0x80		; Calling interrupt handler

	mov eax, 3		; sys_read system call

	mov ebx, 2		; stdin file descriptor

	mov ecx, first		; Read first input value in first

	mov edx, 5	; 5 bytes (numeric, 1 for sign) of that data value

	int 0x80		; Calling interrupt handler

	mov eax, [first]		; eax equal to value of first

	jmp exit		; Jump to exit label

exit:		; exit label

	mov eax , 1		; sys_exit system call

	mov ebx , 0		; setting exit status

	int 0x80		; Calling interrupt handler to exit program


