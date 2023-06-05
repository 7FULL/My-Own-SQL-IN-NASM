section .data
    str1 db "Hola", 0
    str2 db "Hola", 0
    igual db "Son iguales", 0
    diferente db "Son diferentes", 0

section .text
    global _start

_start:
    ; Inicializar registros
    mov ecx, 0       ; contador de posición en los strings
    mov esi, str1    ; puntero al primer string
    mov edi, str2    ; puntero al segundo string

comparar_caracteres:
    mov al, [esi + ecx] ; obtener carácter de str1
    cmp al, [edi + ecx] ; comparar con carácter de str2
    jne strings_diferentes ; si son diferentes, saltar a etiqueta strings_diferentes

    ; Verificar si se llegó al final de los strings
    cmp al, 0
    je strings_iguales

    ; Incrementar contador y continuar comparando
    inc ecx
    jmp comparar_caracteres

strings_iguales:
    ; Los strings son iguales
    mov eax, 4            ; número de llamada al sistema para escribir
    mov ebx, 1            ; descriptor de archivo (stdout)
    mov ecx, igual        ; puntero al mensaje "Son iguales"
    mov edx, 11           ; longitud del mensaje
    int 0x80

    ; Salir del programa
    mov eax, 1
    xor ebx, ebx
    int 0x80

strings_diferentes:
    ; Los strings son diferentes
    mov eax, 4            ; número de llamada al sistema para escribir
    mov ebx, 1            ; descriptor de archivo (stdout)
    mov ecx, diferente    ; puntero al mensaje "Son diferentes"
    mov edx, 14           ; longitud del mensaje
    int 0x80

    ; Salir del programa
    mov eax, 1
    xor ebx, ebx
    int 0x80
