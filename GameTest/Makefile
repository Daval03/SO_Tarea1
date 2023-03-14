all:
	nasm -f bin mybootloader.asm -o boot.bin
	nasm -f bin Game.asm -o Game.bin
	cat boot.bin Game.bin > bootable.bin
	qemu-system-x86_64 -fda bootable.bin