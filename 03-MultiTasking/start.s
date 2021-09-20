.equ STACKSIZE, 8192
.section .text
.globl _start
_start:
    # setup stacks per hart
    csrr t0, mhartid                # read current hart id
    slli t0, t0, 10                 # shift left the hart id by 1024
    la   sp, stacks + STACKSIZE    # set the initial stack pointer 
                                    # to the end of the stack space
    add  sp, sp, t0                 # move the current hart stack pointer
                                    # to its place in the stack space

    # park harts with id != 0
    csrr a0, mhartid                # read current hart id
    bnez a0, park                   # if we're not on the hart 0
                                    # we park the hart

    j    os_main                    # hart 0 jump to c

park:
    wfi
    j park

.section .data
.globl stacks
.section .bss
stacks:
    .skip STACKSIZE * 4            # allocate space for the harts stacks
