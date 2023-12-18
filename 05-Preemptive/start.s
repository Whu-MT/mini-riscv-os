.equ STACK_SIZE, 8192

.section .text
.global _start

_start:
    # setup stacks per hart
    csrr t0, mhartid                # read current hart id
    addi t0, t0, 1
    li t1, 1024 * 8
    mul t0, t0, t1
    la   sp, stacks
                                    # set the initial stack pointer 
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

.section .bss
.globl stacks
stacks:
    .skip STACK_SIZE * 4            # allocate space for the harts stacks
