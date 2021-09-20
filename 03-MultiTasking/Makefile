CC = riscv64-linux-gnu-gcc
LD = riscv64-linux-gnu-ld
CFLAGS = -Wall -I. -nostdlib -fno-builtin -mcmodel=medany -g -Wall -ffreestanding -fno-common -nostdlib -mno-relax 
CFLAGS += -fno-omit-frame-pointer -MD -fno-stack-protector -fno-pie -no-pie -O0
GDB = gdb-multiarch
SOURCE = ./

OBJ_C = \
$(SOURCE)lib.o \
$(SOURCE)os.o \
$(SOURCE)task.o \
$(SOURCE)user.o \

OBJ_S = \
$(SOURCE)start.o \
$(SOURCE)sys.o \

QEMU = qemu-system-riscv64
QFLAGS = -nographic -smp 1 -machine virt -bios none

OBJDUMP = riscv64-linux-gnu-objdump

all: clean os.elf qemu

test: clean os.elf qemu

$(OBJ_C): %.o : %.c
	$(CC) $(CFLAGS) -fPIC -c $< -o $@
$(OBJ_S): %.o : %.s
	$(CC) $(CFLAGS) -c $< -o $@

os.elf: $(OBJ_S) $(OBJ_C) 
	$(LD) -T os.ld -o os.elf $^
	$(OBJDUMP) -D os.elf > os.asm
	$(OBJDUMP) -t os.elf > os.sym

qemu: $(TARGET) 
	@qemu-system-riscv32 -M ? | grep virt >/dev/null || exit
	@echo "Press Ctrl-A and then X to exit QEMU"
	$(QEMU) $(QFLAGS) -kernel os.elf
qemu-gdb: $(TARGET)
	@qemu-system-riscv32 -M ? | grep virt >/dev/null || exit
	@echo "Press Ctrl-A and then X to exit QEMU"
	$(QEMU) $(QFLAGS) -S -gdb tcp::1234 -kernel os.elf

clean:
	rm -f *.elf *.img
	rm -f $(SOURCE)/*.o

