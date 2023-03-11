[org 0x0500]

inicio:
    cld                             ; Limpiar la bandera de direccion (DF = 0)
    
    mov ah, 0                       ; INT 10h / AH = 0 - Establecer modo de video
    mov al, 03h                     ; AL = 03h - Modo de texto. 80x25. 16 colors
    int 10h                         ; 
    
    mov si, welcome_message         ; SOURCE INDEX como puntero al mensaje de bienvenida
    call print_string               ; Print del mensaje de bienvenida
    
    mov ah, 00h                     ; INT 16h / AH = 00h - Obtener evento del teclado.
    int 16h                         ;
    
    mov ah, 0                       ; INT 10h / AH = 0 - Establecer modo de video (Para limpiar la pantalla de nuevo)
    mov al, 03h                     ; AL = 03h - Modo de texto. 80x25. 16 colors
    int 10h
    
    mov si, map_level_1             ; Se carga en SI el puntero al string que se quiere printar
    call print_string               ; Se llama al procedimiento para pintar 
    
    
    mov dh, 6
    mov dl, 1
    mov bh, 0
    mov ah, 2
    int 10h
    
    hlt
    
    jmp move_loop


print_string:
    cld                         ; Se limpia la flag de direccion (DF = 0)
    mov ah, 0x0e                ; INT 10h / AH = 0Eh - teletype output.
    
    .next_char:                 ; Siguiente caracter
        lodsb                   ; Load byte at address DS:(E)SI into AL
        cmp al, 0               ; chequear el caracter final del string (0)
        je .return              ; return si ya terminó
        int 0x10                ; ah = 0x0e int 0x10 hace print de un solo char
        jmp .next_char          ; repetir en caso de no haber terminado
    
    .return: ret                ; retornar


move_loop:
    mov ah, 0    ;Servicio de lectura de teclado
    int 16h      ;Llamar a la interrupcion de teclado
    cmp al,'w'   ;Tecla de flecha hacia arriba
    je move_up   ;Si es la tecla de flecha hacia arriba, saltar a move_up
    cmp al, 'a'  ;Tecla de flecha hacia la izquierda
    je move_left ;Si es la tecla de flecha hacia la izquierda, saltar a move_left
    cmp al, 'd'  ;Tecla de flecha hacia la derecha
    je move_right;Si es la tecla de flecha hacia la derecha, saltar a move_right
    cmp al, 's'  ;Tecla de flecha hacia abajo
    je move_down ;Si es la tecla de flecha hacia abajo, saltar a move_down
    cmp al, 'l'
    je stop
    cmp al, 'r'
    je reset
    jmp move_loop; Si no es ninguna tecla de flecha, volver a leer la tecla 

reset:
    jmp inicio

stop:     
    mov ah, 0 
    int 16h
    cmp al, 'l'
    je move_loop
    jmp stop

move_up:
    
    ; Delete "*" de la posicion actual
    mov ah, 0Eh
    mov al, ' '
    int 10h
    
    ; Move cursor up 1 row
    dec dh
    mov ah, 2
    mov bh, 0
    int 10h
    jmp print
    
move_left:
      
    mov ah, 0Eh
    mov al, ' '
    int 10h
    
    ; Move cursor left 1 column
    dec dl
    mov ah, 2
    mov bh, 0
    int 10h
    
    jmp print

move_right:
    
    
    mov ah, 0Eh
    mov al, ' '
    int 10h
    
    ; Move cursor right 1 column
    inc dl
    mov ah, 2
    mov bh, 0
    int 10h
    jmp print

move_down:
    
    mov ah, 0Eh
    mov al, ' '
    int 10h

    ; Move cursor down 1 row
    inc dh
    mov ah, 2
    mov bh, 0
    int 10h

    jmp print

print:
    ; Print '*' en la nueva posicion
    mov al, '*'
    mov ah, 09h ; Amarillo
    mov bl, 0eh 
    mov cx, 1   
    int 10h
    jmp move_loop 

;------------------------------------------------;  Data section  ;------------------------------------------------;
; 0dh,0ah means "\n \r" = cursor to the next line and return to left of the screen

welcome_message db "=========================== Bienvenido a SHIP MAZE ============================", 0dh,0ah
                db "SHIP MAZE es un juego donde una nave tendra que esquivar una serie", 0dh,0ah
                db "de obstaculos para llegar a su destino final de manera segura.", 0dh,0ah
                db "La nave se controla con las siguientes teclas:", 0dh,0ah, 0ah                    
                db "Derecha: D", 0dh,0ah
                db "Izquierda: A", 0dh,0ah
                db "Arriba: W", 0dh,0ah
                db "Abajo: S", 0dh,0ah	
                db "===============================================================================", 0dh,0ah, 0ah
                db "Presione cualquier tecla para iniciar...$", 0
welcome_message_len equ $-welcome_message

map_level_1 db "======================================", 0dh,0ah
            db "==    |        |       |     |      ==", 0dh,0ah
            db "==    |        -       |     |      ==", 0dh,0ah
            db "==    |        |       | -   -      ==", 0dh,0ah
            db "==    |        |       |            ==", 0dh,0ah
            db "==  - |    ----     -- |     -      ==", 0dh,0ah
            db "     -                 |     |        ", 0dh,0ah
            db "               |       |     |        ", 0dh,0ah
            db "==    |        |  ---  |     |      ==", 0dh,0ah
            db "==    |        -       |            ==", 0dh,0ah
            db "== -  |  ---   | ---   |     |      ==", 0dh,0ah
            db "==    |        |       |     |      ==", 0dh,0ah
            db "==    -        |     --             ==", 0dh,0ah
            db "==    |        |             |      ==", 0dh,0ah
            db "======================================", 0

times 2048-($ - $$) db 0