section .data
    file db "hola.txt", 0   ; Nombre del archivo a leer

len equ 1024   ; Tamaño máximo a leer

section .bss
    buffer resb 1024   ; Buffer para almacenar los datos leídos

section .text
    global _start

_start:
    ; Abrir el archivo
    mov ebx, file   ; Coloca la dirección del nombre de archivo en ebx
    mov eax, 5   ; Número de llamada al sistema para 'open'
    mov ecx, 0   ; Bandera de solo lectura (O_RDONLY)
    int 80h   ; Llamada al sistema

    ; El descriptor de archivo abierto se almacena en eax

    ; Leer el contenido del archivo
    mov eax, 3   ; Número de llamada al sistema para 'read'
    mov ebx, eax   ; Descriptor de archivo abierto
    mov ecx, buffer   ; Dirección de almacenamiento del buffer
    mov edx, len   ; Tamaño máximo a leer
    int 80h   ; Llamada al sistema

    ; Los datos leídos se almacenan en el buffer

    ; Imprimir el contenido del archivo
    mov eax, 4   ; Número de llamada al sistema para 'write'
    mov ebx, 1   ; Descriptor de archivo para stdout
    mov ecx, buffer   ; Dirección del buffer
    mov edx, len   ; Tamaño de los datos a escribir
    int 80h   ; Llamada al sistema

    ; Cerrar el archivo
    mov eax, 6   ; Número de llamada al sistema para 'close'
    int 80h   ; Llamada al sistema

    ; Salir del programa
    mov eax, 1   ; Número de llamada al sistema para 'exit'
    mov ebx, 0   ; Código de salida (0)
    int 80h   ; Llamada al sistema

