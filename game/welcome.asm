; ----------------------------------------------------------------------------------------
; To assemble and run:
;
;     nasm -f elf64 welcome.asm&& ld welcome.o && ./a.out
; ----------------------------------------------------------------------------------------

%macro write_message 2
    mov eax,4 ;system call number (sys_write)
    mov ebx,1 ;file descriptor (stdout)
    mov ecx,%1 ;message to write
    mov edx,%2 ;message length
    int 0x80 ;call kernel  
      
%endmacro

section .text
    global _start ;must be declared for linker (ld)
_start: ;tells linker entry point
    write_message bienve, bienve_len
    write_message about, about_len
    write_message instruc, instruc_len
    write_message control, control_len
    write_message teclas, teclas_len
    write_message continua, continua_len
    ;wait until enter is pressed
    mov eax, 3 ; sys_read
    mov ebx, 0 ; input stdin 
    mov ecx,continua ;   
    mov edx,continua_len ; 
    int 0x80     
    ;clear console
    mov eax, 4
    mov ebx, 1
    mov ecx, clear
    mov edx, 4
    int 0x80 ; 
    ;move to (1, 1) position
    mov eax, 4
    mov ebx, 1
    mov ecx, cursor
    mov edx, 3
    int 0x80 ;  
    write_message puntaje, puntaje_len
    write_message endgame, endgame_len 
    
    ;segundo enter
        ;wait until enter is pressed
    mov eax, 3 ; sys_read
    mov ebx, 0 ; input stdin 
    mov ecx,continua ;   
    mov edx,continua_len ; 
    int 0x80     
    ;clear console
    mov eax, 4
    mov ebx, 1
    mov ecx, clear
    mov edx, 4
    int 0x80 ; 
    ;move to (1, 1) position
    mov eax, 4
    mov ebx, 1
    mov ecx, cursor
    mov edx, 3
    int 0x80 ;  
    write_message puntaje2, puntaje2_len
    write_message endgame, endgame_len 
    
    ;tercer enter
    
        ;wait until enter is pressed
    mov eax, 3 ; sys_read
    mov ebx, 0 ; input stdin 
    mov ecx,continua ;   
    mov edx,continua_len ; 
    int 0x80     
    ;clear console
    mov eax, 4
    mov ebx, 1
    mov ecx, clear
    mov edx, 4
    int 0x80 ; 
    ;move to (1, 1) position
    mov eax, 4
    mov ebx, 1
    mov ecx, cursor
    mov edx, 3
    int 0x80 ;  
    write_message puntaje3, puntaje3_len
    write_message endgame, endgame_len 
    
    ;exit code
    mov eax, 1
    xor ebx, ebx
    int 80h

section .data
clear db 27, 91, 50, 74 ;secuencia para limpiar pantalla
cursor db 27, 91, 72

bienve db "        ========Bienvenido a Mobile Maze========", 0dh, 0ah   
bienve_len equ $ - bienve  

about db "Mobile Maze es un juego donde una nave tiene que esquivar una serie de obstaculos para llegar a su destino final de manera segura, acumulando puntos en su camino.", 0dh, 0ah   
about_len equ $ - about  

instruc db "        ========Instrucciones del juego========", 0dh, 0ah   
instruc_len equ $ - instruc  

control db "El juego se controla con las siguientes teclas", 0dh, 0ah   
control_len equ $ - control  

teclas db "Derecha: → | Izquierda: ← | Arriba: ↑ | Abajo: ↓ | Pausar juego: L | Reiniciar juego: R", 0dh, 0ah   
teclas_len equ $ - teclas  

fin db "        =========================================", 0dh, 0ah   
fin_len equ $ - fin  

continua db "Presione la tecla enter para continuar...", 0dh, 0ah   
continua_len equ $ - continua  

puntaje db "Puntaje> 10 ", 0dh, 0ah   
puntaje_len equ $ - puntaje  

puntaje2 db "Puntaje> 15 ", 0dh, 0ah   
puntaje2_len equ $ - puntaje2  

puntaje3 db "Puntaje> 20 ", 0dh, 0ah   
puntaje3_len equ $ - puntaje3  

endgame db "-------------El juego ha terminado...-------------", 0dh, 0ah   
endgame_len equ $ - continua 
