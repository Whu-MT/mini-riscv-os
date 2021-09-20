CC = riscv64-linux-gnu-gcc
LD = riscv64-linux-gnu-ld
CFLAGS = -nostdlib -fno-builtin -mcmodel=medany -ggdb -O -ffreestanding -fno-common -nostdlib -mno-relax
CFLAGS += -fno-omit-frame-pointer -MD -fno-stack-protector -fno-pie -no-pie -I .

QEMU = qemu-system-riscv64
QFLAGS = -nographic -smp 1 -machine virt -bios none

OBJDUMP = riscv64-linux-gnu-objdump

all: os.elf

os.elf: start.s os.c
	$(CC) -c -o start.o start.s
	$(CC) -c -o sys.o sys.s
	$(CC) $(CFLAGS) -c -o os.o os.c
	$(CC) $(CFLAGS) -c -o lib.o lib.c
	$(LD) -T os.ld -o os.elf start.o os.o  sys.o lib.o
	$(OBJDUMP) -D os.elf > os.asm
	$(OBJDUMP) -t os.elf > os.sym

qemu: $(TARGET)
	@qemu-system-riscv64 -M ? | grep virt >/dev/null || exit
	@echo "Press Ctrl-A and then X to exit QEMU"
	$(QEMU) $(QFLAGS) -kernel os.elf

qemu-gdb: $(TARGET)
	@qemu-system-riscv64 -M ? | grep virt >/dev/null || exit
	@echo "Press Ctrl-A and then X to exit QEMU"
	$(QEMU) $(QFLAGS) -S -gdb tcp::1234 -kernel os.elf

clean:
	rm -f *.elf
