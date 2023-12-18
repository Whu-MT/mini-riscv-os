CC = riscv64-linux-gnu-gcc
LD = riscv64-linux-gnu-ld
CFLAGS = -nostdlib -fno-builtin -mcmodel=medany -march=rv64imafd -mabi=lp64d -ggdb -Wall -w -O -ffreestanding -fno-common -mno-relax
GDB = gdb-multiarch

OBJ_C = \
lib.o \
timer.o \
task.o \
os.o \
user.o \
trap.o \
lock.o \
plic.o

OBJ_S = \
start.o \
sys.o

QEMU = qemu-system-riscv64
QFLAGS = -nographic -smp 4 -machine virt -bios none

OBJDUMP = riscv64-linux-gnu-objdump

all: os.elf

$(OBJ_C): %.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@
$(OBJ_S): %.o : %.s
	$(CC) $(CFLAGS) -c $< -o $@

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

.PHONY : debug
debug: all
	@echo "Press Ctrl-C and then input 'quit' to exit GDB and QEMU"
	@echo "-------------------------------------------------------"
	@${QEMU} ${QFLAGS} -kernel os.elf -s -S &
	@${GDB} os.elf -q -x ./gdbinit