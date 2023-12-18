CC = riscv64-linux-gnu-gcc
LD = riscv64-linux-gnu-ld
CFLAGS = -nostdlib -fno-builtin -mcmodel=medany -march=rv64imafdc -mabi=lp64d -ggdb -Wall -ffreestanding -fno-common -mno-relax -fno-omit-frame-pointer -fno-stack-protector
GDB = gdb-multiarch

OBJ_C = \
lib.o \
timer.o \
task.o \
os.o \
user.o \
trap.o \
lock.o \
plic.o \
virtio.o \
string.o

OBJ_S = \
start.o \
sys.o

QEMU = qemu-system-riscv64
QFLAGS = -nographic -smp 4 -machine virt -bios none
QFLAGS += -drive if=none,format=raw,file=hdd.dsk,id=x0
QFLAGS += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0

OBJDUMP = riscv64-linux-gnu-objdump

all: clean os.elf hdd.dsk

$(OBJ_C): %.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@
$(OBJ_S): %.o : %.s
	$(CC) $(CFLAGS) -c $< -o $@

test: clean os.elf qemu

os.elf: $(OBJ_S) $(OBJ_C)
	$(LD) -T os.ld -o os.elf $^
	$(OBJDUMP) -D os.elf > os.asm
	$(OBJDUMP) -t os.elf > os.sym

qemu: $(TARGET) hdd.dsk
	@qemu-system-riscv64 -M ? | grep virt >/dev/null || exit
	@echo "Press Ctrl-A and then X to exit QEMU"
	$(QEMU) $(QFLAGS) -kernel os.elf

qemu-gdb: $(TARGET)
	@echo "*** Now run 'gdb' in another window." 1>&2
	$(QEMU) $(QFLAGS) -kernel os.elf -S -gdb tcp::12345

clean:
	rm -f *.elf *.img

hdd.dsk:
	dd if=/dev/urandom of=hdd.dsk bs=1M count=32

.PHONY : debug
debug: clean os.elf hdd.dsk
	@echo "Press Ctrl-C and then input 'quit' to exit GDB and QEMU"
	@echo "-------------------------------------------------------"
	@${QEMU} ${QFLAGS} -kernel os.elf -s -S &
	@${GDB} os.elf -q -x ./gdbinit
