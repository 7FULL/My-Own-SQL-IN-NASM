section .data

    mensaje db 'Hola, mundo!', 10
    len equ $ - mensaje

section .text

    global _start

_start:

    mov eax, 4                  ; Número de llamada al sistema para escribir
    mov ebx, 1                  ; Descriptor de archivo (stdout)
    mov ecx, mensaje            ; Puntero al mensaje
    mov edx, len                ; Longitud del mensaje
    int 80h                       ; Llamar al sistema operativo

    ; Salir del programa
    mov eax, 1                 ; Número de llamada al sistema para salir
    mov ebx, 0                ; Código de salida (0)
    int 80h                     ; Llamar al sistema operativo

