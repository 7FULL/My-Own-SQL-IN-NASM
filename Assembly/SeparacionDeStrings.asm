section .data
    frase db "Esta es una frase de ejemplo", 0
    longitud equ $-frase
    palabra1 db 100 dup(0) ; Espacio para almacenar la primera palabra
    palabra2 db 100 dup(0) ; Espacio para almacenar la segunda palabra
    palabra3 db 100 dup(0) ; Espacio para almacenar la tercera palabra

section .text
    global _start

_start:
    ; Inicializar los registros
    mov ebx, 0       ; Indicador de posición en la frase
    mov ecx, 0       ; Indicador de posición en la palabra
    mov edi, palabra1 ; Dirección de la primera palabra

recorrer_frase:
    ; Verificar si hemos llegado al final de la frase
    cmp ebx, longitud
    jge fin

    ; Obtener el carácter actual
    mov al, [frase + ebx]

    ; Verificar si es un espacio en blanco
    cmp al, ' '
    je es_espacio

    ; Almacenar el carácter en la palabra correspondiente
    mov [edi + ecx], al

    ; Incrementar el contador de posición en la palabra
    inc ecx
    jmp siguiente_caracter

es_espacio:
    ; Verificar si hemos encontrado la primera palabra completa
    ;cmp ecx, 0
    jmp siguiente_palabra

siguiente_caracter:
    ; Incrementar el contador de posición en la frase y continuar recorriendo
    inc ebx
    jmp recorrer_frase

siguiente_palabra:
    ; Verificar si ya se ha almacenado la primera palabra
    cmp edi, palabra1
    je almacenar_palabra2
    cmp edi, palabra2
    je almacenar_palabra3
    cmp edi, palabra3
    jmp fin

fin:
        ; Imprimir las palabras almacenadas
    mov eax, 4      ; Número de llamada al sistema para escribir
    mov ebx, 1      ; Descriptor de archivo (stdout)
    mov ecx, palabra1    ; Puntero a la tercera palabra
    mov edx, 32    ; Longitud de la tercera palabra
    int 80h            ; Llamar al sistema operativo

    ; Imprimir las palabras almacenadas
    mov eax, 4      ; Número de llamada al sistema para escribir
    mov ebx, 1      ; Descriptor de archivo (stdout)
    mov ecx, palabra2    ; Puntero a la tercera palabra
    mov edx, 32    ; Longitud de la tercera palabra
    int 80h            ; Llamar al sistema operativo


    ; Imprimir las palabras almacenadas
    mov eax, 4      ; Número de llamada al sistema para escribir
    mov ebx, 1      ; Descriptor de archivo (stdout)
    mov ecx, palabra3    ; Puntero a la tercera palabra
    mov edx, 32    ; Longitud de la tercera palabra
    int 80h            ; Llamar al sistema operativo

    ; Salir del programa
    mov eax, 1                 ; Número de llamada al sistema para salir
    xor ebx, 0                ; Código de salida (0)
    int 80h                     ; Llamar al sistema operativo


almacenar_palabra2:
    ; Inicializar los registros
    mov ecx, 0       ; Indicador de posición en la palabra
    mov edi, palabra2 ; Dirección de la segunda palabra
    jmp siguiente_caracter

almacenar_palabra3:
    ; Inicializar los registros
    mov ecx, 0       ; Indicador de posición en la palabra
    mov edi, palabra3 ; Dirección de la tercera palabra
    jmp siguiente_caracter