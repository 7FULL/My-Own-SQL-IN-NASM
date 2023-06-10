section .data
    SentenceSize equ 27
    WordSize equ 3
    Sentence db "guardar la de los archivos."
    palabra db "patata"

    mensaje db 'No encontrada!', 10
    len equ $ - mensaje

section .text
    global _start

_start:
    mov edi, Sentence
    mov esi, palabra
    mov ecx, SentenceSize
    lodsb         ; Carga la primera letra de Word. ESI apunta a "os".

search:
    repne scasb   ; Busca la primera letra de Word ("l").
    jne notFound

    ; Hemos encontrado la primera "l". EDI apunta a la siguiente "a", ECX=18.
    push esi
    push edi
    push ecx
    mov ecx, WordSize
    dec ecx       ; La primera letra de Word ya ha sido comprobada.
    repe cmpsb    ; Establece ZF=1 cuando se encuentra la palabra.
    pop ecx       ; Restaura el tamaño restante de Sentence (18).
    pop edi       ; Restaura el puntero de Sentence después de "l".
    pop esi       ; Restaura el puntero de Word a "os".
    jne search    ; Si ZF=0, busca "l" nuevamente. La segunda vez será exitoso.

found:
    ; La palabra se encontró en Sentence en la dirección EDI-1.
    ; Aquí puedes agregar el código que deseas ejecutar cuando se encuentra la palabra.
    jmp exit

notFound:
    ; La palabra no está presente en Sentence.
    ; Aquí puedes agregar el código que deseas ejecutar cuando no se encuentra la palabra.

    mov eax, 4                  ; Número de llamada al sistema para escribir
    mov ebx, 1                  ; Descriptor de archivo (stdout)
    mov ecx, mensaje            ; Puntero al mensaje
    mov edx, len                ; Longitud del mensaje
    int 80h                       ; Llamar al sistema operativo

exit:
    ; Aquí puedes agregar el código para salir del programa correctamente.
    ; Salir del programa
    mov eax, 1                 ; Número de llamada al sistema para salir
    mov ebx, 0                ; Código de salida (0)
    int 80h                     ; Llamar al sistema operativo
