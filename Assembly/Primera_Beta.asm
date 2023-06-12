section .data
    frase db 100 dup(0) 
    longitud equ 100    
    palabra1 db 100 dup(0)
    palabra2 db 100 dup(0) 
    palabra3 db 100 dup(0) 
    bienvenida db "Bienvenido a FULLSQL", 10
    bienvenidaLen equ $ - bienvenida
    error db "No se pudo abrir el archivo.", 10
    errorLen equ $ - error
    error2 db "No se pudo leer el archivo.", 10
    errorLen2 equ $ - error2
    error3 db "Orden no encontrada.", 10
    errorLen3 equ $ - error3
    saltoLinea db 10,0
    select db "select",0
    insert db "insert",0
    exitText db "exit",0
    prueba db "Llego hasta aqui",10     ;para poder hacer debug
    pruebaLen equ $ - prueba
    fileIdentificator db 100

section .bss
    content resb 4096

section .text
    global _start

_start:
    ;Mensaje de bienvenida
    mov eax, 4
    mov ebx, 2
    mov ecx, bienvenida
    mov edx, bienvenidaLen
    int 80h

    start:


    mov ecx, 100     ; Cantidad de bytes a limpiar

    ; Limpiar palabra1
    mov edi, palabra1 ; Dirección base de palabra1
    xor eax, eax     ; Valor cero
    rep stosb        ; Almacenar valor cero en ecx bytes desde edi

    ; Limpiar palabra2
    mov edi, palabra2 ; Dirección base de palabra2
    xor eax, eax     ; Valor cero
    rep stosb        ; Almacenar valor cero en ecx bytes desde edi

    ; Limpiar palabra3
    mov edi, palabra3 ; Dirección base de palabra3
    xor eax, eax     ; Valor cero
    rep stosb        ; Almacenar valor cero en ecx bytes desde edi

    ; Limpiar fileIdentificator
    mov edi, fileIdentificator ; Dirección base de fileIdentificator
    xor eax, eax     ; Valor cero
    rep stosb        ; Almacenar valor cero en ecx bytes desde edi


    
    ;call nuevaLinea
    mov eax, 4
    mov ebx, 1
    mov ecx, saltoLinea
    mov edx, 2
    int 80h

    ;call nuevaLinea
    mov eax, 4
    mov ebx, 1
    mov ecx, saltoLinea
    mov edx, 2
    int 80h
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
    jge siguiente_palabra

    ; Obtener el carácter actual
    mov al, [frase + ebx]

    ; Verificar si es un espacio en blanco
    cmp al, ' '
    je siguiente_palabra

    ; Almacenar el carácter en la palabra correspondiente
    mov [edi + ecx], al

    ; Incrementar el contador de posición en la palabra
    inc ecx
    jmp siguiente_caracter

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
    ; Inicializar registros
    mov ecx, 0       ; contador
    mov esi, palabra1   
    mov edi, select    

    comparar_caracteres:
        ; vamos conparando las letras
        mov al, [esi + ecx] 
        cmp al, [edi + ecx] 
        jne comprobarInsert ; si no es un select saltamos a comprobar si es un insert

        ; Verificar si se llegó al final de los strings
        cmp al, 0
        je selectDone   ;input == select

        ; Incrementar contador y continuar comparando
        inc ecx
        jmp comparar_caracteres

    comprobarInsert:
        ; Inicializar registros
        mov ecx, 0       ; contador
        mov esi, palabra1
        mov edi, insert    

    comparar_caracteresInsert:
        ; vamos comparando las letras
        mov al, [esi + ecx] 
        cmp al, [edi + ecx] 
        jne comprobarExit ; si no es un insert pasamos a comprobar si es un exit

        ; Verificar si se llegó al final de los strings
        cmp al, 0
        je insertDone   ;input == insert

        ; Incrementar contador y continuar comparando
        inc ecx
        jmp comparar_caracteresInsert

    insertDone:
        ; seleccionamos la palabra y su longitud
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

        jmp abrirArchivo

    comprobarExit:
        ; Inicializar registros
        mov ecx, 0       ; contador
        mov esi, palabra1   
        mov edi, exitText  

    comparar_caracteresExit:
        ; vamos comprobando las letras
        mov al, [esi + ecx] 
        cmp al, [edi + ecx] 
        jne ordenNoEncontrada ; en caso de que no sea exit ni insert ni select mandamos mensajito al usuario

        ; Verificar si se llegó al final de los strings
        cmp al, 0
        je exit   ;input == exit

        ; Incrementar contador y continuar comparando
        inc ecx
        jmp comparar_caracteresExit

    selectDone:
        ;Preparar el input para poder abrir el archivo

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

        jmp abrirArchivo

almacenar_palabra2:
    ; sobreescribimos el puntero al registro1 por el registro 2
    ; Inicializar los registros
    mov ecx, 0       ; Indicador de posición en la palabra
    mov edi, palabra2 ; Dirección de la segunda palabra
    jmp siguiente_caracter

almacenar_palabra3:
    ; sobreescribimos el puntero al registro 2 por el registro 3
    ; Inicializar los registros
    mov ecx, 0       ; Indicador de posición en la palabra
    mov edi, palabra3 ; Dirección de la tercera palabra
    jmp siguiente_caracter



;<<<<<<<<<<<<<<<<<MANEJO DE ARCHIVOS>>>>>>>>>>>>>>>>>



abrirArchivo:
    call debug

    ;call nuevaLinea
    mov eax, 4
    mov ebx, 1
    mov ecx, saltoLinea
    mov edx, 2
    int 80h
    
    ; Abrir el archivo en modo lectura
    mov eax, 5
    mov ebx, palabra3
    mov ecx, 0
    mov edx, 0
    int 80h
    test eax, eax
    js errorOpen_handling
    mov [fileIdentificator], eax  ; Guardar el descriptor

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
    mov ebx, [fileIdentificator]
    int 80h

    jmp start

exit:
    ; Salir del programa
    mov eax, 1
    mov ebx, 0
    int 80h
    
;subrutina
debug:
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 4                  ; Número de llamada al sistema para escribir
    mov ebx, 1                  ; Descriptor de archivo (stdout)
    mov ecx, prueba            ; Puntero al mensaje
    mov edx, pruebaLen                ; Longitud del mensaje
    int 80h                       ; Llamar al sistema operativo

    ; restauramos desde la pila
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret



;<<<<<<<<<<<Apartado para errores>>>>>>>>>>>



ordenNoEncontrada:
    mov eax, 4
    mov ebx, 2
    mov ecx, error3
    mov edx, errorLen3
    int 80h

    jmp start

errorOpen_handling:
    mov eax, 4
    mov ebx, 2
    mov ecx, error
    mov edx, errorLen
    int 80h

    jmp start

errorReading_handling:
    mov eax, 4
    mov ebx, 2
    mov ecx, error2
    mov edx, errorLen2
    int 80h
    jmp start