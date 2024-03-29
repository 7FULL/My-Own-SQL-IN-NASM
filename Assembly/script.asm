section .data
    frase db 100 dup(0) 
    longitud equ 100    
    palabra1 db 100 dup(0)
    palabra2 db 100 dup(0) 
    palabra3 db 100 dup(0) 
    palabraAux db 100 dup(0) ;Palabra auxiliar para guardar la de los archivos
    error db "No se pudo abrir el archivo.", 10
    errorLen equ $ - error
    error2 db "No se pudo leer el archivo.", 10
    errorLen2 equ $ - error2
    error3 db "Orden no encontrada.", 10
    errorLen3 equ $ - error3
    error4 db "Archivo cerrado incorrectamente.", 10
    errorLen4 equ $ - error4
    saltoLinea db 10,0
    select db "select",0
    insert db "insert",0
    create db "create",0
    drop db "drop",0
    exitText db "exit",0
    todo db "*",0
    prueba db "Llego hasta aqui",10     ;para poder hacer debug
    pruebaLen equ $ - prueba
    length db 128 dup(0) 
    fraseLength db 128 dup(0) 
    lenAux db 100 dup(0)

    empty db 100 dup(0)     ;variable para vaciar palabraAux

    ebxAux db 10 dup(0)
    ecxAux db 10 dup(0)
    ediAux db 10 dup(0)

section .bss
    fileIdentificator resb 100
    content resb 4096

section .text
    global _start

_start:
    mov ecx, 100     ; Cantidad de bites a limpiar

    ; Limpiar palabra1
    mov edi, lenAux ; Dirección base de palabra1
    xor eax, eax     ; Valor cero
    rep stosb        ; Almacenar valor cero en ecx bytes desde edi

    ; Limpiar palabra1
    mov edi, [lenAux] ; Dirección base de palabra1
    xor eax, eax     ; Valor cero
    rep stosb        ; Almacenar valor cero en ecx bytes desde edi

    ; Limpiar palabra auxiliar
    mov edi, palabraAux ; Dirección base de fileIdentificator
    xor eax, eax     ; Valor cero
    rep stosb        ; Almacenar valor cero en ecx bytes desde edi

    ; Limpiar palabra auxiliar
    mov edi, [palabraAux] ; Dirección base de fileIdentificator
    xor eax, eax     ; Valor cero
    rep stosb        ; Almacenar valor cero en ecx bytes desde edi

    mov ecx, 100       ; Número de bytes en la variable palabraAux
    mov esi, frase ; Dirección base de la variable palabraAux
    
    limpiarFrase:
        xor eax, eax    ; Establecer eax en cero
        mov [esi], al   ; Establecer el byte actual en cero
        inc esi         ; Mover al siguiente byte
        loop limpiarFrase    ; Repetir hasta que se hayan limpiado todos los bytes
    
    mov ecx, 4096       ; Número de bytes en la variable palabraAux
    mov esi, content ; Dirección base de la variable palabraAux
    
    limpiarContent:
        xor eax, eax    ; Establecer eax en cero
        mov [esi], al   ; Establecer el byte actual en cero
        inc esi         ; Mover al siguiente byte
        loop limpiarContent    ; Repetir hasta que se hayan limpiado todos los bytes

    mov ecx, 100       ; Número de bytes en la variable palabraAux
    mov esi, palabra1 ; Dirección base de la variable palabraAux
    
    limpiarPalabra1:
        xor eax, eax    ; Establecer eax en cero
        mov [esi], al   ; Establecer el byte actual en cero
        inc esi         ; Mover al siguiente byte
        loop limpiarPalabra1    ; Repetir hasta que se hayan limpiado todos los bytes
    
    mov ecx, 100       ; Número de bytes en la variable palabraAux
    mov esi, palabra2 ; Dirección base de la variable palabraAux
    
    limpiarPalabra2:
        xor eax, eax    ; Establecer eax en cero
        mov [esi], al   ; Establecer el byte actual en cero
        inc esi         ; Mover al siguiente byte
        loop limpiarPalabra2    ; Repetir hasta que se hayan limpiado todos los bytes
    
    mov ecx, 100       ; Número de bytes en la variable palabraAux
    mov esi, palabra3 ; Dirección base de la variable palabraAux
    
    limpiarPalabra3:
        xor eax, eax    ; Establecer eax en cero
        mov [esi], al   ; Establecer el byte actual en cero
        inc esi         ; Mover al siguiente byte
        loop limpiarPalabra3    ; Repetir hasta que se hayan limpiado todos los bytes
    


    ; nuevaLinea
    mov eax, 4
    mov ebx, 1
    mov ecx, saltoLinea
    mov edx, 2
    int 80h

    ; nuevaLinea
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

    selectDone:
        ;Preparar el input para poder abrir el archivo

        mov ebx, palabra3
        call len
        mov eax, ecx        ;la subrutina devuelve el valor en ecx
        mov ecx, palabra3

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

    comprobarInsert:
        ; Inicializar registros
        mov ecx, 0       ; contador
        mov esi, palabra1
        mov edi, insert    

    comparar_caracteresInsert:
        ; vamos comparando las letras
        mov al, [esi + ecx] 
        cmp al, [edi + ecx] 
        jne comprobarCreate ; si no es un insert pasamos a comprobar si es un exit

        ; Verificar si se llegó al final de los strings
        cmp al, 0
        je insertDone   ;input == insert

        ; Incrementar contador y continuar comparando
        inc ecx
        jmp comparar_caracteresInsert

    insertDone:
        ;Preparar el registro a insertar
        mov ebx, palabra2
        call len
        mov eax, ecx        ;la subrutina devuelve el valor en ecx
        mov ecx, palabra2

        ; Añadir la extension basandonos en el lenght
        ; podriamos añadir byte a byte (inc eax)
        mov byte [ecx+eax], ";"
        mov byte [ecx+eax+1], 10

        add eax,2       ;añadimos a la longitud los 4 bytes extra
                        ;que hemos añadido

        ; El sistema operativo espera que las cadenas de texto
        ; acaben en un byte nulo
        ; Añadir al nombre de archivo con un byte nulo
        mov byte [ecx+eax], 0


        mov ebx, palabra3
        call len
        mov eax, ecx        ;la subrutina devuelve el valor en ecx
        mov ecx, palabra3

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

        jmp escribirEnArchivo

    comprobarCreate:
        ; Inicializar registros
        mov ecx, 0       ; contador
        mov esi, palabra1
        mov edi, create    

    comparar_caracteresCreate:
        ; vamos comparando las letras
        mov al, [esi + ecx] 
        cmp al, [edi + ecx] 
        jne comprobarDrop ; si no es un insert pasamos a comprobar si es un exit

        ; Verificar si se llegó al final de los strings
        cmp al, 0
        je createDone   ;input == insert

        ; Incrementar contador y continuar comparando
        inc ecx
        jmp comparar_caracteresCreate

    createDone:
        mov ebx, palabra3
        call len
        mov eax, ecx        ;la subrutina devuelve el valor en ecx
        mov ecx, palabra3

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

        inc eax

        jmp crearArchivo

    comprobarDrop:
        ; Inicializar registros
        mov ecx, 0       ; contador
        mov esi, palabra1
        mov edi, drop    

    comparar_caracteresDrop:
        ; vamos comparando las letras
        mov al, [esi + ecx] 
        cmp al, [edi + ecx] 
        jne comprobarExit ; si no es un insert pasamos a comprobar si es un exit

        ; Verificar si se llegó al final de los strings
        cmp al, 0
        je dropDone   ;input == insert

        ; Incrementar contador y continuar comparando
        inc ecx
        jmp comparar_caracteresDrop

    dropDone:
        mov ebx, palabra3
        call len
        mov eax, ecx        ;la subrutina devuelve el valor en ecx
        mov ecx, palabra3

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

        inc eax

        jmp eliminarArchivo

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



eliminarArchivo:
    mov ebx, palabra3       ; filename we will create
    mov eax, 10              ; invoke SYS_CREAT (kernel opcode 8)
    int 80h                 ; call the kernel  
    
    jmp _start

crearArchivo:
    mov ecx, 0777o          ; set all permissions to read, write, execute
    mov ebx, palabra3       ; filename we will create
    mov eax, 8              ; invoke SYS_CREAT (kernel opcode 8)
    int 80h                 ; call the kernel  
      
    ; Cerrar el archivo
    mov ebx, eax
    mov eax, 6
    int 80h
    test eax,eax
    js errorClosing_handling
    
    jmp _start

escribirEnArchivo:
    ; Abrir el archivo en modo escritura
    mov eax, 5
    mov ebx, palabra3
    mov ecx, 1          ; solo escritura
    mov edx, 02002h     ; append (escribir al final del archivo)
    int 80h
    test eax, eax
    js errorOpen_handling
    mov [fileIdentificator], eax  ; Guardar el descriptor

    ; Mover el puntero de archivo al final del archivo
    mov eax, 19        ; Código de llamada al sistema para obtener la posición actual del archivo
    mov ebx, [fileIdentificator]      ; Descriptor de archivo devuelto por la llamada a sys_open
    mov ecx, 0      ; Desplazamiento: 0 (desde el final del archivo)
    mov edx, 2        ; Origen: SEEK_END (final del archivo)
    int 80h          ; Llamar al sistema para mover el puntero de archivo

    mov ebx, palabra2
    call len
    ; Escribir el mensaje al final del archivo
    mov eax, 4        ; Código de llamada al sistema para escribir en un archivo
    mov ebx, [fileIdentificator]      ; Descriptor de archivo devuelto por la llamada a sys_open
    mov edx, ecx      ; Longitud del mensaje
    mov ecx, palabra2  ; Puntero al mensaje a escribir
    int 80h          ; Llamar al sistema para escribir en el archivo

    ; Cerrar el archivo
    mov eax, 6
    mov ebx, [fileIdentificator]
    int 80h
    test eax,eax
    js errorClosing_handling

    jmp _start

abrirArchivo:
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
    ;mov eax, 4
    ;mov ebx, 1
    ;mov ecx, content
    ;int 80h

    ; Cerrar el archivo
    mov eax, 6
    mov ebx, [fileIdentificator]
    int 80h
    test eax,eax
    js errorClosing_handling


    ;<<<<<<<<Aqui empezamos la comprobacion de que devolver>>>>>>>>
    

    ; Inicializar registros
    mov ecx,0
    mov esi, palabra2
    mov edi, todo    

    comparar_caracteresPalabra2:
        ; vamos comparando las letras
        mov al, [esi] 
        cmp al, [edi] 
        jne imprimirSoloDeseado ; comprobar si es "*"

        ;En este caso no nos hace falta contador 
        ;ya que "*" solo tiene un byte

        ; Mostrar el contenido del archivo
        mov eax, 4
        mov ebx, 1
        mov ecx, content
        int 80h

        jmp _start

    imprimirSoloDeseado:
        ; Inicializar los registros
        mov ebx, 0       ; Indicador de posición en la frase
        mov ecx, 0       ; Indicador de posición en la palabra
        mov edi, palabraAux ; Dirección de la primera palabra

        recorrer_fraseDeseado:
            ; Verificar si hemos llegado al final de la frase
            cmp ebx, longitud
            jge _start

            ; Obtener el carácter actual
            mov al, [content + ebx]

            ; Verificar si es un espacio en blanco
            cmp al, ";"
            je siguiente_palabraDeseado
            ;si quisiesemos que el ";" tambien se incluyese en la frase
            ;solo comparariamos depues de la instruccion de almacenar y ya

            ; Almacenar el carácter en la palabra correspondiente
            mov [edi + ecx], al

            ; Incrementar el contador de posición en la palabra
            inc ecx
            jmp siguiente_caracterDeseado

        siguiente_caracterDeseado:
            ; Incrementar el contador de posición en la frase y continuar recorriendo
            ; call debug
            inc ebx
            jmp recorrer_fraseDeseado

        siguiente_palabraDeseado:
            mov [ediAux],edi
            mov [ebxAux],ebx
            mov [ecxAux],ecx

            ; el regitro se queda en palabraaux
            ; comprueba que palabra 2 esta dentro
            ; de palabraaux en ese caso imprime palabraaux 

            mov ebx,palabra2
            call len            ;obtener longitud de frase
            mov [lenAux],ecx

            mov edi, palabraAux
            mov esi, palabra2

            ;como la propia subrutina ya guarda
            ;el valor en ecx nos ahorramos tener que hacerlo
            mov ecx, 100        ;longitud de frase

            lodsb         

            search:
                repne scasb   ; Busca la primera letra de la palabra
                jne notFound

                ; Hemos encontrado la primera "l". EDI apunta a la siguiente "a", ECX=18.
                push esi
                push edi
                push ecx
                mov ecx, [lenAux]
                dec ecx       ; La primera letra de Word ya ha sido comprobada.
                repe cmpsb    ; Establece ZF=1 cuando se encuentra la palabra.
                pop ecx       ; Restaura el tamaño restante de Sentence (18).
                pop edi       ; Restaura el puntero de Sentence después de "l".
                pop esi       ; Restaura el puntero de Word a "os".
                jne search    ; Si ZF=0, busca "l" nuevamente. La segunda vez será exitoso.

            found:
                ; La palabra se encontró en Sentence en la dirección EDI-1.
                ; Aquí puedes agregar el código que deseas ejecutar cuando se encuentra la palabra.
                mov eax, 4                  ; Número de llamada al sistema para escribir
                mov ebx, 1                  ; Descriptor de archivo (stdout)
                mov ecx, palabraAux            ; Puntero al mensaje
                mov edx, 100                ; Longitud del mensaje
                int 80h                       ; Llamar al sistema operativo

            notFound:
                ; La palabra no está presente en Sentence.
                ; Aquí puedes agregar el código que deseas ejecutar cuando no se encuentra la palabra.

        mov ecx, 100       ; Número de bytes en la variable palabraAux
        mov esi, palabraAux ; Dirección base de la variable palabraAux
        
        limpiar:
            xor eax, eax    ; Establecer eax en cero
            mov [esi], al   ; Establecer el byte actual en cero
            inc esi         ; Mover al siguiente byte
            loop limpiar    ; Repetir hasta que se hayan limpiado todos los bytes
        

        mov edi,[ediAux]
        mov ebx,[ebxAux]
        mov ecx,[ecxAux]

        jmp siguiente_caracterDeseado



exit:
    ; Salir del programa
    mov eax, 1
    mov ebx, 0
    int 80h
    
;subrutina para debuguear
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

;subrutina para obtener longitud de un texto
;parametros -> ebx=palabra
;retorna la longitud en ecx
len:
    push ebx
    mov ecx,0   
    dec ebx ; primer caracter de la palabra
    count:
        inc ecx
        inc ebx
        cmp byte [ebx],0
        jnz count
    dec ecx
    pop ebx
    ret



;<<<<<<<<<<<Apartado para errores>>>>>>>>>>>



ordenNoEncontrada:
    mov eax, 4
    mov ebx, 2
    mov ecx, error3
    mov edx, errorLen3
    int 80h

    jmp _start

errorOpen_handling:
    mov eax, 4
    mov ebx, 2
    mov ecx, error
    mov edx, errorLen
    int 80h

    jmp _start

errorClosing_handling:
    mov eax, 4
    mov ebx, 2
    mov ecx, error4
    mov edx, errorLen4
    int 80h
    jmp _start

errorReading_handling:
    mov eax, 4
    mov ebx, 2
    mov ecx, error2
    mov edx, errorLen2
    int 80h
    jmp _start