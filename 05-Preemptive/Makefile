CC = riscv64-linux-gnu-gcc
LD = riscv64-linux-gnu-ld
CFLAGS = -march=rv64imafd -mabi=lp64d -nostdlib -fno-builtin -mcmodel=medany -ggdb -Wall -w -O -ffreestanding -fno-common -mno-relax
GDB = gdb-multiarch

OBJ_C = \
lib.o \
timer.o \
task.o \
os.o \
user.o \
trap.o

OBJ_S = \
start.o \
sys.o

QEMU = qemu-system-riscv64
QFLAGS = -nographic -smp 1 -machine virt -bios none

OBJDUMP = riscv64-linux-gnu-objdump

all: os.elf

# 最开始的代码因为 .s 和 .c 没分开编译导致运行失败。原因未知，gdb是在lib_puts返回的时候，pc被置为0
# (gdb)
# 0x00000000800001a6      16              lib_putc(*s++);
# (gdb)
# 0x00000000800001a8      16              lib_putc(*s++); # lib_puts最后一条汇编 ret
# (gdb) si
# 0x0000000000000000 in ?? ()

$(OBJ_C): %.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@
$(OBJ_S): %.o : %.s
	$(CC) $(CFLAGS) -O -c $< -o $@

# 这里注意顺序，OBJ_S放前面，且start.o 放OBJ_S第一个
os.elf: $(OBJ_S) $(OBJ_C)
	$(LD) -T os.ld -o os.elf $^
	$(OBJDUMP) -D os.elf > os.asm
	$(OBJDUMP) -t os.elf > os.sym

qemu: $(TARGET)
	@qemu-system-riscv64 -M ? | grep virt >/dev/null || exit
	@echo "Press Ctrl-A and then X to exit QEMU"
	$(QEMU) $(QFLAGS) -kernel os.elf

qemu-gdb: $(TARGET)
	@echo "*** Now run 'gdb' in another window." 1>&2
	$(QEMU) $(QFLAGS) -kernel os.elf -S -gdb tcp::12345

clean:
	rm -f *.elf
