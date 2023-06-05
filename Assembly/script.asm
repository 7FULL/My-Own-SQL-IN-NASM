section .data
    frase db "Esta es una frase de ejemplo", 0
    longitud equ $-frase
    palabra1 db 100 dup(0) ; Espacio para almacenar la primera palabra
    palabra2 db 100 dup(0) ; Espacio para almacenar la primera palabra
    palabra3 db 100 dup(0) ; Espacio para almacenar la primera palabra

section .text
    global _start

_start:
    ; Inicializar los registros
    mov ebx, 0       ; indicador de posición en la frase
    mov ecx, 0       ; indicador de posición en la palabra
    mov edi, palabra1 ; dirección de la primera palabra

    ; Recorrer la frase
recorrer_frase:
jmp fin

    cmp ebx, longitud ; verificar si hemos llegado al final de la frase
    jge fin

    ; Obtener el carácter actual
    mov al, [frase + ebx]

    ; Verificar si es un espacio en blanco
    cmp al, ' '
    je es_espacio

    ; Almacenar el carácter en la primera palabra
    mov [edi + ecx], al

    ; Incrementar el contador de posición en la palabra
    inc ecx
    jmp siguiente_caracter

es_espacio:
    ; Verificar si hemos encontrado la primera palabra completa
    cmp ecx, 0
    jne fin
        ; Inicializar los registros
    mov ebx, 0       ; indicador de posición en la frase
    mov ecx, 0       ; indicador de posición en la palabra
    mov edi, palabra2 ; dirección de la primera palabra

    ; Inicializar los registros
    mov ebx, 0       ; indicador de posición en la frase
    mov ecx, 0       ; indicador de posición en la palabra
    mov edi, palabra3 ; dirección de la primera palabra


siguiente_caracter:
    ; Incrementar el contador de posición en la frase y continuar recorriendo
    inc ebx
    ;mov eax, 4                  ; Número de llamada al sistema para escribir
    ;mov ebx, 1                  ; Descriptor de archivo (stdout)
    ;mov ecx, primera_palabra            ; Puntero al mensaje
    ;mov edx, 10                ; Longitud del mensaje
    ;int 80h                       ; Llamar al sistema operativo

    jmp recorrer_frase

fin:

    ; La primera palabra se ha almacenado en primera_palabra
    ; Puedes utilizar la cadena primera_palabra según tus necesidades
    mov eax, 4                  ; Número de llamada al sistema para escribir
    mov ebx, 1                  ; Descriptor de archivo (stdout)
    mov ecx, palabra1            ; Puntero al mensaje
    mov edx, 10                ; Longitud del mensaje
    int 80h                       ; Llamar al sistema operativo

    mov eax, 4                  ; Número de llamada al sistema para escribir
    mov ebx, 1                  ; Descriptor de archivo (stdout)
    mov ecx, palabra2            ; Puntero al mensaje
    mov edx, 10                ; Longitud del mensaje
    int 80h                       ; Llamar al sistema operativo

    mov eax, 4                  ; Número de llamada al sistema para escribir
    mov ebx, 1                  ; Descriptor de archivo (stdout)
    mov ecx, palabra3            ; Puntero al mensaje
    mov edx, 10                ; Longitud del mensaje
    int 80h                       ; Llamar al sistema operativo

    ; Salir del programa
    mov eax, 1
    xor ebx, ebx
    int 0x80

