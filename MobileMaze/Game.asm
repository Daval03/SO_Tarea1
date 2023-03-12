[org 0x0500]

jmp preludio

preludio:
    cld                             ; Limpiar la bandera de direccion (DF = 0)
    
    mov ah, 0                       ; INT 10h / AH = 0 - Establecer modo de video
    mov al, 03h                     ; AL = 03h - Modo de texto. 80x25. 16 colors
    int 10h                         ; 
    
    mov si, welcome_message         ; SOURCE INDEX como puntero al mensaje de bienvenida
    call print_string               ; Print del mensaje de bienvenida
    
    mov ah, 00h                     ; INT 16h / AH = 00h - Obtener evento del teclado.
    int 16h                         ;
    jmp inicio

inicio:
    mov ah, 0                       ; INT 10h / AH = 0 - Establecer modo de video (Para limpiar la pantalla de nuevo)
    mov al, 03h                     ; AL = 03h - Modo de texto. 80x25. 16 colors
    int 10h
    
    mov si, point0                  ; Se carga en SI el puntero al string que se quiere printar
    call print_string               ; Se llama al procedimiento para pintar 

    mov si, nivel1                  ; Se carga en SI el puntero al string que se quiere printar
    call print_string               ; Se llama al procedimiento para pintar 

    mov si, map_level_1             ; Se carga en SI el puntero al string que se quiere printar
    call print_string               ; Se llama al procedimiento para pintar 

    mov dh, 8 ;y
    mov dl, 0 ;x
    mov bh, 0
    mov ah, 2
    int 10h
    
    mov ax, 6 ; Cargar el valor de 6 en el registro AX
    mov [caso], ax ; Almacenar el valor de AX en la variable "caso"
    
    hlt
    
    jmp move_loop

delete_char:
    mov ah, 0Eh
    mov al, ' '
    int 10h
    .return: ret

set_position:
    mov dh, [y]
    mov dl, [x]
    mov bh, 0
    mov ah, 2
    int 10h
    .return: ret
    
save_position:
    mov ah, 03h    ; Cargar el valor de AH con 03h
    int 10h        ; Llamar a la interrupción de la BIOS
    mov [y], dh    ; Guardar el valor de dh (fila) en la variable 'y'
    mov [x], dl    ; Guardar el valor de dl (columna) en la variable 'x'
    .return: ret

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
    mov ax, 6         ; Cargar el valor de 6 en el registro AX
    mov [caso], ax    ; Almacenar el valor de AX en la variable "caso"
    mov ax, 0         ; Cargar el valor de 6 en el registro AX
    mov [endGame], ax ; Almacenar el valor de AX en la variable "caso"
    jmp inicio

stop:     
    mov ah, 0 
    int 16h
    cmp al, 'l'
    je move_loop
    jmp stop

move_up:
    call save_position
    cmp dh, 3
    je move_loop

    ; Delete "*" de la posicion actual
    call delete_char
    ; Move cursor up 1 row
    dec dh
    mov ah, 2
    mov bh, 0
    int 10h
    jmp print
    
move_left:
    call save_position
    cmp dl, 0
    je move_loop

    call delete_char
    ; Move cursor left 1 column
    dec dl
    mov ah, 2
    mov bh, 0
    int 10h
    
    jmp print

move_right:
    call save_position

    cmp dl, [caso]
    je termina

    call delete_char
    ; Move cursor right 1 column
    inc dl
    mov ah, 2
    mov bh, 0
    int 10h
    
    jmp print
move_down:
    
    call save_position
    cmp dh, 15
    je move_loop

    call delete_char
    ; Move cursor down 1 row
    inc dh
    mov ah, 2
    mov bh, 0
    int 10h

    jmp print

print:
    mov al, '*' ; Print '*' en la nueva posicion
    mov ah, 09h ; Amarillo
    mov bl, 0eh 
    mov cx, 1   
    int 10h
    jmp move_loop 

termina:
    mov ax, 6 ; Cargar el valor de 6 en el registro AX
    cmp [caso], ax
    je caso6

    mov ax, 15 ; Cargar el valor de 15 en el registro AX
    cmp [caso], ax
    je caso15

    mov ax, 23 ; Cargar el valor de 23 en el registro AX
    cmp [caso], ax
    je caso23

    mov ax, 29 ; Cargar el valor de 29 en el registro AX
    cmp [caso], ax
    je caso29

    mov ax, 1 ; Cargar el valor de 29 en el registro AX
    cmp [endGame], ax
    je finish
    
    mov al, 03h   ; Limpiamos la pantalla
    mov ah, 0
    int 10h
    ; Imprimimos el puntuaje, el nivel y el mapa nuevo
    mov si, point0
    call print_string

    mov si, nivel2
    call print_string

    mov si, map_level_2
    call print_string

    mov ax, 1         ; Cargar el valor de 1 en el registro AX
    mov [endGame], ax ; Almacenar el valor de AX en la variable "endGame"
    
    mov ax, 6 ; Cargar el valor de 6 en el registro AX
    mov [caso], ax ; Almacenar el valor de AX en la variable "caso"
    ;Movemos el cursor en la posicion de inicio 
    mov dh, 8
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
    jmp move_loop

caso6:
    mov ax, 15 ; Cargar el valor de 15 en el registro AX  
    mov [caso], ax ; Almacenar el valor de AX en la variable "caso"
    call set_cero
    mov si, point2
    call print_string
    jmp addPoint

caso15:
    mov ax, 23 ; Cargar el valor de 23 en el registro AX  
    mov [caso], ax ; Almacenar el valor de AX en la variable "caso"
    call set_cero
    mov si, point4
    call print_string
    jmp addPoint

caso23:
    mov ax, 29 ; Cargar el valor de 29 en el registro AX  
    mov [caso], ax ; Almacenar el valor de AX en la variable "caso"
    call set_cero
    mov si, point5
    call print_string
    jmp addPoint

caso29:
    mov ax, 36 ; Cargar el valor de 36 en el registro AX  
    mov [caso], ax ; Almacenar el valor de AX en la variable "caso"
    call set_cero
    mov si, point9
    call print_string
    jmp addPoint

finish:
     ; Limpiamos la pantalla para poner el mensaje de fin de partida
    mov al, 03h
    mov ah, 0
    int 10h
    
    mov si, endTitle
    call print_string
    
    mov ah, 00h
    int 16h
    jmp reset
addPoint:
    call set_position
	mov ah, 0Eh
    mov al, ' '
    int 10h
    
    ; Move cursor right 1 column
    inc dl
    mov ah, 2
    mov bh, 0
    int 10h  
    jmp print 

set_cero:
    mov dh, 0 ;Movemos el curso a la posicion 0
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
    .return: ret
;------------------------------------------------;  Data section  ;------------------------------------------------;
; 0dh,0ah means "\n \r" = cursor to the next line and return to left of the screen

welcome_message db "=========================== Bienvenido a SHIP MAZE ============================", 0dh,0ah
                db "", 0dh,0ah
                db "SHIP MAZE es un juego donde una nave tendra que esquivar una serie", 0dh,0ah
                db "de obstaculos para llegar a su destino final de manera segura.", 0dh,0ah
                db "La nave se controla con las siguientes teclas:", 0dh,0ah
                db "", 0dh,0ah                 
                db "Derecha: D - Izquierda: A", 0dh,0ah
                db "", 0dh,0ah
                db "Arriba: W - Abajo: S", 0dh,0ah
                db "", 0dh,0ah
                db "Pausa: L - Reiniciar: R", 0dh,0ah
                db "", 0dh,0ah
                db "===============================================================================", 0dh,0ah
                db "", 0dh,0ah
                db "Presione cualquier tecla para iniciar...", 0
map_level_1 db " ", 0dh,0ah  
            db " ", 0dh,0ah  
            db "======================================", 0dh,0ah
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

map_level_2 db "  ", 0dh,0ah  
            db " ", 0dh,0ah 
            db "======================================", 0dh,0ah
            db "==    |        |             |      ==", 0dh,0ah
            db "==    |   --   | ---   |     |      ==", 0dh,0ah
            db "== ---|        |     - |     |      ==", 0dh,0ah
            db "==    |        -       -     -      ==", 0dh,0ah
            db "==    |  ---        -- |            ==", 0dh,0ah
            db "      |        -       |     |        ", 0dh,0ah
            db "               |       |     |        ", 0dh,0ah
            db "==    |   --   |  --   | --  |      ==", 0dh,0ah
            db "==    |        |       |            ==", 0dh,0ah
            db "== -- |        |       |     |      ==", 0dh,0ah
            db "==    | ----   - --    |     |      ==", 0dh,0ah
            db "==    |        |       | ---        ==", 0dh,0ah
            db "==    |        |    ---|     |      ==", 0dh,0ah
            db "======================================", 0 

point0 db "Puntuaje = 0", 0
point2 db "Puntuaje = 2", 0
point4 db "Puntuaje = 4", 0
point5 db "Puntuaje = 5", 0
point9 db "Puntuaje = 9", 0
nivel1 db "  Nivel: Facil", 0
nivel2 db "  Nivel: Dificil", 0

endTitle db " ",0dh,0ah
    db "==== Ganastes ====",0dh,0ah
    db " ", 0

x db 0
y db 0
caso dw 6
endGame dw 0

times 3530-($ - $$) db 0