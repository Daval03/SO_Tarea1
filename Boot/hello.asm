; programa.asm
;
; Este código imprime "Hola mundo!" en la pantalla

org 0x7000
start:
    ; Imprimir el mensaje
    mov ah, 0x0E
    mov al, 'H'
    int 0x10
    mov al, 'o'
    int 0x10
    mov al, 'l'
    int 0x10
    mov al, 'a'
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 'm'
    int 0x10
    mov al, 'u'
    int 0x10
    mov al, 'n'
    int 0x10
    mov al, 'd'
    int 0x10
    mov al, 'o'
    int 0x10
    mov al, '!'
    int 0x10

    ; Terminar el programa
    jmp $

times 512 - ($ - $$) db 0 ; Rellenar el resto del sector con ceros