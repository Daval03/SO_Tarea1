; Boot Sector
[bits 16]
[org 0x7c00]  ; Dirección de inicio
start:

    xor ax, ax  ; Register AX = 0
    mov ds, ax  ; DATA SEGMENT = 0
    mov es, ax  ; EXTRA SEGMENT = 0
    ;mov ss, ax  ; STACK SEGMENT = 0
    
    clc         ; CARRY FLAG = 0

    ; Cargar el sector de inicio del sistema operativo
    mov bx, 0x0500 ; Dirección de memoria donde se encuentra el juego. ES:BX points to data buffer.
    mov ah, 0x02   ; Función del BIOS para leer un sector
    mov al, 0x05   ; Número de sectores a leer
    mov ch, 0x00   ; Cilindro del disco
    mov cl, 0x02   ; Número de sector
    mov dh, 0x00   ; Cabeza del disco
    int 0x13       ; Llamar a la función del BIOS para leer el sector
    jc  .read_sector_error

    jmp 0x0500          ; Saltar a la direccion de inicio del juego
    
    .read_sector_error:
        mov si, error_message   ; SENGMENT INDEX apuntando al mensaje de error
        call print_string       ; print error message
        jmp $                   ; infinite loop

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


error_message db 'Failed to read sector from USB!', 10, 13, 0  
      
; Rellenar el resto del sector de arranque con ceros
times 510-($ - $$) db 0
dw 0xaa55;  Magic number


; Correr el codigo en qemu 
; nasm -f bin bootTest.asm -o boot.bin
; qemu-system-x86_64 -fda boot.bin
; lsblk