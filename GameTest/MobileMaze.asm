#make_bin#

; BIN is plain binary format similar to .com format, but not limited to 1 segment;
; All values between # are directives, these values are saved into a separate .binf file.
; Before loading .bin file emulator reads .binf file with the same file name.

; All directives are optional, if you don't need them, delete them.

; set loading address, .bin file will be loaded to this address:
#LOAD_SEGMENT=0500h#
#LOAD_OFFSET=0000h#

; set entry point:
#CS=0500h#	; same as loading segment
#IP=0000h#	; same as loading offset

; set segment registers
#DS=0500h#	; same as loading segment
#ES=0500h#	; same as loading segment

; set stack
#SS=0500h#	; same as loading segment
#SP=FFFEh#	; set to top of loading segment

; set general registers (optional)
#AX=0000h#
#BX=0000h#
#CX=0000h#
#DX=0000h#
#SI=0000h#
#DI=0000h#
#BP=0000h#

name "Mobile maze"
jmp preludio                             

; ------ Data ------

x_pos db 0
y_pos db 0
caso db 6
endGame db 0

endTitle db "==================",0dh,0ah
    db "==== Ganastes ====",0dh,0ah
    db "==================$"
	
msg db "==== Bienvenido a Mobile maze ====", 0dh,0ah
	db "Mobile maze es un juego donde una nave tendra que esquivar una serie", 0dh,0ah
	db "de obstaculos para llegar a su destino final de manera segura.", 0dh,0ah
	
	db "                       ", 0dh,0ah
	db "==== Como se juega ====", 0dh,0ah
	db "                       ", 0dh,0ah
	db "Controlas la nave con las siguientes teclas:", 0dh,0ah, 0ah
	                         
	db "Derecha: D", 0dh,0ah
	db "Izquierda: A", 0dh,0ah
	db "Arriba: W", 0dh,0ah
	db "Abajo: S", 0dh,0ah	
	db "L: Pausa el juego   R: Reinicia el juego", 0dh,0ah, 0ah
	
	db "                       ", 0dh,0ah
	db "====================", 0dh,0ah, 0ah
	db "Presione cualquier tecla para iniciar...$"
	
maze db "                                      ", 0dh,0ah  
    db "                                      ", 0dh,0ah 
    db "======================================", 0dh,0ah
	db "==    |        |       |     |      ==", 0dh,0ah
	db "==    |        -       |     |      ==", 0dh,0ah
	db "==    |        |       | -   -      ==", 0dh,0ah
	db "==    |        |       |            ==", 0dh,0ah
	db "==  - |     ---     -- |     -      ==", 0dh,0ah
	db "     -                 |     |        ", 0dh,0ah
	db "               |       |     |        ", 0dh,0ah
	db "==    |        |  ---  |     |      ==", 0dh,0ah
	db "==    |        -       |            ==", 0dh,0ah
	db "== -  |  ---   | ---   |     |      ==", 0dh,0ah
    db "==    |        |       |     |      ==", 0dh,0ah
	db "==    -        |     --             ==", 0dh,0ah
	db "==    |        |             -      ==", 0dh,0ah
	db "======================================$"
	
maze2 db "                                      ", 0dh,0ah  
    db "                                      ", 0dh,0ah 
    db "======================================", 0dh,0ah
	db "==    |        |             |      ==", 0dh,0ah
	db "==    |        | ---   |     |      ==", 0dh,0ah
	db "== ---|        |     - |     |      ==", 0dh,0ah
	db "==    |        -       -     -      ==", 0dh,0ah
	db "==    |  ---        -- |            ==", 0dh,0ah
	db "      |        -       |     |        ", 0dh,0ah
	db "               |       |     |        ", 0dh,0ah
	db "==    |        |  --   | --  |      ==", 0dh,0ah
	db "==    |        |       |            ==", 0dh,0ah
	db "== -- |        |       |     |      ==", 0dh,0ah
    db "==    | ----   -       |     |      ==", 0dh,0ah
	db "==    |        |       | ---        ==", 0dh,0ah
	db "==    |        |    ---|     |      ==", 0dh,0ah
	db "======================================$"   
	
point0 db "Puntuaje = 0$"
point2 db "Puntuaje = 2$"
point4 db "Puntuaje = 4$"
point5 db "Puntuaje = 5$"
point9 db "Puntuaje = 9$"
nivel1 db "  Nivel: Facil$"
nivel2 db "  Nivel: Dificil$"

preludio:
    ; Print del mensaje de inicio:
    mov dx, offset msg
    mov ah, 9 
    int 21h  
    
    ; Esperar a que presione una tecla:
    mov ah, 00h
    int 16h

start: 
    ; Ponemos la pantalla
    mov al, 03h
    mov ah, 0
    int 10h
    
    ;Ponemos los marcadores, el mazo y el nivel
    mov dx, offset point0
    mov ah, 9 
    int 21h
    
    mov dx, offset nivel1
    mov ah, 9 
    int 21h
    
    mov dx, offset maze
    mov ah, 9 
    int 21h
    
    mov dh, 8
	mov dl, 0
	mov bh, 0
	mov ah, 2
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
    mov caso, 6
    jmp start

stop:     
    mov ah, 0 
    int 16h
    cmp al, 'l'
    je move_loop
    jmp stop

print:
    ; Print '*' en la nueva posicion
    mov al, '*'
    mov ah, 09h ; Amarillo
    mov bl, 0eh 
    mov cx, 1   
    int 10h
    jmp move_loop 

move_up:
    ; Obtenemos la posicion del cursor
    mov ah, 03h
    mov bh, 0     
    int 10h         
    mov x_pos, dl   
    mov y_pos, dh
    
    cmp dh,3
    je move_loop
    
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
    
    mov ah, 03h
    mov bh, 0     
    int 10h         
    mov x_pos, dl   
    mov y_pos, dh
    
    cmp dl,caso
    je termina
    
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
    mov ah, 03h
    mov bh, 0     
    int 10h         
    mov x_pos, dl   
    mov y_pos, dh
    
    cmp dh,15
    je move_loop 
    
    mov ah, 0Eh
    mov al, ' '
    int 10h

    ; Move cursor down 1 row
    inc dh
    mov ah, 2
    mov bh, 0
    int 10h

    jmp print

termina:
    cmp caso,6
    je caso6
    
    cmp caso,15
    je caso15
    
    cmp caso,23
    je caso23
    
    cmp caso,29
    je caso29
    
    cmp endGame,1
    je finish
    
    mov al, 03h
    mov ah, 0
    int 10h    
    
    mov caso, 6
    mov endGame, 1
    
    ;Ponemos los marcadores, el mazo y el nivel
    mov dx, offset point0
    mov ah, 9 
    int 21h
    
    mov dx, offset nivel2
    mov ah, 9 
    int 21h
    
    mov dx, offset maze2
    mov ah, 9 
    int 21h
    
    mov dh, 8
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
	jmp move_loop
finish:
    
    mov al, 03h
    mov ah, 0
    int 10h
    
    mov dx, offset endTitle
    mov ah, 9 
    int 21h
    
    mov ah, 00h
    int 16h
    jmp reset
caso6:
    mov caso, 15
    ;Movemos el curso a la posicion 0
    mov dh, 0
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
	mov dx, offset point2
    mov ah, 9 
    int 21h
    jmp addPoint
    
caso15:
    mov caso, 23
    ;Movemos el curso a la posicion 0
    mov dh, 0
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
	mov dx, offset point4
    mov ah, 9 
    int 21h
    jmp addPoint
    
caso23:
    mov caso, 29
    ;Movemos el curso a la posicion 0
    mov dh, 0
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
	mov dx, offset point5
    mov ah, 9 
    int 21h
    jmp addPoint
    
caso29:
    mov caso, 36
    ;Movemos el curso a la posicion 0
    mov dh, 0
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
	mov dx, offset point9
    mov ah, 9 
    int 21h
    jmp addPoint
    
addPoint:
    mov dh, y_pos
	mov dl, x_pos
	mov bh, 0
	mov ah, 2
	int 10h
	
	mov ah, 0Eh
    mov al, ' '
    int 10h
    
    ; Move cursor right 1 column
    inc dl
    mov ah, 2
    mov bh, 0
    int 10h  
    jmp print     

HLT           