# This Code derived from xv6-riscv (64bit)
# -- https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/swtch.S

# ============ MACRO ==================
.macro ctx_save base
        sd ra, 0(\base)
        sd sp, 8(\base)
        sd s0, 16(\base)
        sd s1, 32(\base)
        sd s2, 40(\base)
        sd s3, 48(\base)
        sd s4, 56(\base)
        sd s5, 64(\base)
        sd s6, 72(\base)
        sd s7, 80(\base)
        sd s8, 88(\base)
        sd s9, 96(\base)
        sd s10, 104(\base)
        sd s11, 112(\base)
.endm

.macro ctx_load base
        ld ra, 0(\base)
        ld sp, 8(\base)
        ld s0, 16(\base)
        ld s1, 32(\base)
        ld s2, 40(\base)
        ld s3, 48(\base)
        ld s4, 56(\base)
        ld s5, 64(\base)
        ld s6, 72(\base)
        ld s7, 80(\base)
        ld s8, 88(\base)
        ld s9, 96(\base)
        ld s10, 104(\base)
        ld s11, 112(\base)
.endm

# ============ Macro END   ==================
 
# Context switch
#
#   void sys_switch(struct context *old, struct context *new);
# 
# Save current registers in old. Load from new.

.globl sys_switch
.align 4
sys_switch:
        ctx_save a0  # a0 => struct context *old
        ctx_load a1  # a1 => struct context *new
        ret          # pc=ra; swtch to new task (new->ra)
