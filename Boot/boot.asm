; Boot Sector
org 0x7c00  ; Dirección de inicio
start:
    ; Configurar segmentos
    xor ax, ax  ; Inicializar segmento de datos a 0
    mov ds, ax  ; Cargar el valor de ax en el registro ds

    ; Cargar el sector de inicio del sistema operativo
    mov bx, 0x7000 ; Dirección de memoria donde se cargará el sector
    mov ah, 0x02   ; Función del BIOS para leer un sector
    mov al, 0x01   ; Número de sectores a leer
    mov ch, 0x00   ; Cilindro del disco
    mov cl, 0x02   ; Número de sector
    mov dh, 0x00   ; Cabeza del disco
    int 0x13       ; Llamar a la función del BIOS para leer el sector

    ; Saltar al sector de inicio del sistema operativo
    jmp 0x7000

    ; Rellenar el resto del sector de arranque con ceros
    times 510-($ - $$) db 0
    dw 0xaa55;  Magic number

; Correr el codigo en qemu 
; nasm -f bin bootTest.asm -o boot.bin
; qemu-system-x86_64 -fda boot.bin
; lsblk