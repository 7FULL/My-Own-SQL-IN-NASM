section .data
    msg db "Introduce el nombre de la tabla a consultar: ", 0
    msgLen equ $ - msg
    error db "No se pudo abrir el archivo.", 10
    errorLen equ $ - error
    error2 db "No se pudo leer el archivo.", 10
    errorLen2 equ $ - error2

section .bss
    content resb 4096
    file resb 128

section .text
    global _start

_start:
    ; Mostrar el mensaje de solicitud de nombre de archivo
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msgLen
    int 80h

    ; Leer el nombre de archivo del usuario
    mov eax, 3
    mov ebx, 0
    mov ecx, file
    mov edx, 128
    int 80h

    ; Añadir la extension basandonos en el lenght
    ; podriamos añadir byte a byte (inc eax)
    mov byte [ecx+eax-1], "."
    mov byte [ecx+eax], "t"
    mov byte [ecx+eax+1], "x"
    mov byte [ecx+eax+2], "t"

    add eax,4       ;añadimos a la longitud los 4 bytes extra
                    ;que hemos añadido

    ; El sistema operativo espera que las cadenas de texto
    ; acaben en un byte nulo
    ; Añadir al nombre de archivo con un byte nulo
    mov byte [ecx+eax-1], 0

    ; Abrir el archivo en modo lectura
    mov eax, 5
    mov ebx, file
    mov ecx, 0
    mov edx, 0
    int 80h
    test eax, eax
    js errorOpen_handling
    mov ebx, eax  ; Guardar el descriptor

    ; Leer el contenido del archivo
    mov eax, 3
    mov ebx, eax
    mov ecx, content
    mov edx, 4096
    int 80h
    test eax, eax
    js errorReading_handling

    ; Mostrar el contenido del archivo
    mov eax, 4
    mov ebx, 1
    mov ecx, content
    int 80h

    ; Cerrar el archivo
    mov eax, 6
    mov ebx, ebx
    int 80h

exit:
    ; Salir del programa
    mov eax, 1
    xor ebx, ebx
    int 80h

errorOpen_handling:

    mov eax, 4
    mov ebx, 2
    mov ecx, error
    mov edx, errorLen
    int 80h

    jmp exit

errorReading_handling:

    mov eax, 4
    mov ebx, 2
    mov ecx, error2
    mov edx, errorLen2
    int 80h
    jmp exit
