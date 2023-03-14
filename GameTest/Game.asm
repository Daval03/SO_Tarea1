org 0x0500


jmp preludio

preludio:
    ; Ponemos la pantalla
    mov al, 03h
    mov ah, 0
    int 10h     

    ; Esperar a que presione una tecla:
    mov ah, 00h
    int 16h

    ; Ponemos la pantalla
    mov al, 03h
    mov ah, 0
    int 10h
    jmp move_loop

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
    jmp preludio

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

times 512 - ($ - $$) db 0 ; Rellenar el resto del sector con ceros