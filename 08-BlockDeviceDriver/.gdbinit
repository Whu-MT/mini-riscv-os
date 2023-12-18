set disassemble-next-line on
b trap_vector
b *0x8000198e
target remote : 12345
c
