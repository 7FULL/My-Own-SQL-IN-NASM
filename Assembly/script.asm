section .data
    frase db 'ESTA ES UNA FRASE DE EJEMPLO', 0
    palabra db 'FRASE', 0
    tam_frase equ $-frase
    tam_palabra equ $-palabra

section .text
    global _start

_start:
    mov edx, tam_frase     ; Longitud de la frase
    mov ecx, frase         ; Dirección de la frase
    mov ebx, palabra       ; Dirección de la palabra

buscar_palabra:
    mov esi, ebx           ; Copia la dirección de la palabra a ESI
    mov edi, ecx           ; Copia la dirección de la frase a EDI

comparar:
    lodsb                  ; Carga el siguiente byte de la palabra en AL
    cmp al, byte [edi]     ; Compara el byte de la palabra con el byte de la frase
    jne siguiente          ; Si no coinciden, pasa a la siguiente letra de la frase
    cmp al, 0              ; Comprueba si se ha alcanzado el final de la palabra
    je palabra_encontrada  ; Si sí, la palabra se ha encontrado

siguiente:
    inc edi                ; Incrementa el puntero de la frase
    cmp byte [edi], 0      ; Comprueba si se ha alcanzado el final de la frase
    jne comparar           ; Si no, vuelve a comparar

palabra_no_encontrada:
    mov eax, 4             ; Número de sistema para imprimir en pantalla
    mov ebx, 1             ; Descriptor de archivo (stdout)
    mov ecx, mensaje_no_encontrado ; Dirección del mensaje a imprimir
    mov edx, tam_no_encontrado     ; Longitud del mensaje
    int 0x80               ; Llamada al sistema para imprimir en pantalla
    jmp fin

palabra_encontrada:
    mov eax, 4             ; Número de sistema para imprimir en pantalla
    mov ebx, 1             ; Descriptor de archivo (stdout)
    mov ecx, mensaje_encontrado    ; Dirección del mensaje a imprimir
    mov edx, tam_encontrado        ; Longitud del mensaje
    int 0x80               ; Llamada al sistema para imprimir en pantalla

fin:
    mov eax, 1             ; Número de sistema para salir
    xor ebx, ebx           ; Código de salida (0)
    int 0x80               ; Llamada al sistema para salir

section .data
    mensaje_no_encontrado db 'Palabra no encontrada', 0
    tam_no_encontrado equ $-mensaje_no_encontrado
    mensaje_encontrado db 'Palabra encontrada', 0
    tam_encontrado equ $-mensaje_encontrado
