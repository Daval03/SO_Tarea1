all:
	nasm -f bin boot.asm -o boot.bin
	nasm -f bin hello.asm -o hello.bin
	cat boot.bin hello.bin > bootable.bin
	qemu-system-x86_64 -fda bootable.bin