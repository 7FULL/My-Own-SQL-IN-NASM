nasm -f elf32 -o script.o script.asm
ld -m elf_i386 -o script script.o
echo "Bienvenido a FULLSQL"
./script

