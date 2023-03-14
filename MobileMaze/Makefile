all: simulate

build:
	nasm -f bin Bootloader.asm -o Bootloader.bin
	nasm -f bin Game.asm -o Game.bin
	cat Bootloader.bin Game.bin > Boot.img

hex_img:
	xxd -l 2048 Boot.img

qemu:
	qemu-system-i386 -drive format=raw,file=Boot.img
	
usb_build:
	dd if=*** of=** count=5 bs=512
	
hex_usb:
	sudo xxd -l 2048 /dev/sdb

simulate:
	nasm -f bin Bootloader.asm -o Bootloader.bin
	nasm -f bin Game.asm -o Game.bin
	cat Bootloader.bin Game.bin > Boot.bin
	qemu-system-i386 -drive format=raw,file=Boot.bin