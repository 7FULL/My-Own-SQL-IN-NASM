section .data
    mensaje db "Ingresa una frase:", 0
    mensaje_longitud equ $-mensaje
    frase db 100 dup(0) ; Espacio para almacenar la frase ingresada
    longitud equ 100    ; Longitud máxima de la frase
    palabra1 db 100 dup(0) ; Espacio para almacenar la primera palabra
    palabra2 db 100 dup(0) ; Espacio para almacenar la segunda palabra
    palabra3 db 100 dup(0) ; Espacio para almacenar la tercera palabra
    error db "No se pudo abrir el archivo.", 10
    errorLen equ $ - error
    error2 db "No se pudo leer el archivo.", 10
    errorLen2 equ $ - error2

section .bss
    content resb 4096

section .text
    global _start

_start:
    ; Mostrar mensaje para ingresar la frase
    mov eax, 4                  ; Número de llamada al sistema para escribir
    mov ebx, 1                  ; Descriptor de archivo (stdout)
    mov ecx, mensaje            ; Puntero al mensaje
    mov edx, mensaje_longitud   ; Longitud del mensaje
    int 80h                    ; Llamar al sistema operativo
    
    ; Leer la frase ingresada por el usuario
    mov eax, 3                  ; Número de llamada al sistema para leer
    mov ebx, 0                  ; Descriptor de archivo (stdin)
    mov ecx, frase              ; Puntero al búfer de entrada
    mov edx, longitud           ; Longitud máxima de entrada
    int 80h                    ; Llamar al sistema operativo

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
    mov eax, 4
    mov ebx, 1
    mov ecx, palabra3
    int 80h
    ;Termina de dividir palabras
    mov ecx, palabra3
    mov eax, 5
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

        ; Mostrar el contenido del archivo
    mov eax, 4
    mov ebx, 1
    mov ecx, palabra3
    int 80h

    jmp abrirArchivo

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



;<<<<<<<<<<<<<<<<<MANEJO DE ARCHIVOS>>>>>>>>>>>>>>>>>



abrirArchivo:
    ; Abrir el archivo en modo lectura
    mov eax, 5
    mov ebx, palabra3
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

    jmp exit

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

exit:
    ; Salir del programa
    mov eax, 1
    mov ebx, 0
    int 80h
