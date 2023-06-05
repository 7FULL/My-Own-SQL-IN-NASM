section .data

    mensaje db 'Hola, mundo!', 10
    len equ $ - mensaje

section .text

    global _start

_start:

    mov rax, 4                  ; Número de llamada al sistema para escribir
    mov rbx, 1                  ; Descriptor de archivo (stdout)
    mov rcx, mensaje            ; Puntero al mensaje
    mov rdx, len                ; Longitud del mensaje
    int 80h                       ; Llamar al sistema operativo

    ; Salir del programa
    mov rax, 1                 ; Número de llamada al sistema para salir
    xor rbx, 0                ; Código de salida (0)
    int 80h                     ; Llamar al sistema operativo

