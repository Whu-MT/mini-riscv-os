#include "timer.h"

extern void os_kernel();

// a scratch area per CPU for machine-mode timer interrupts.
reg_t timer_scratch[NCPU][5];

void timer_init()
{
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  int interval = 10000000; // cycles; about 1 second in qemu.
  *(reg_t*)CLINT_MTIMECMP(id) = *(reg_t*)CLINT_MTIME + interval;

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired mscratch0terval (in cycles) between timer interrupts.
  reg_t *scratch = &timer_scratch[id][0];
  scratch[4] = CLINT_MTIMECMP(id);
  scratch[5] = interval;
  w_mscratch((reg_t)scratch);

  // set the machine-mode trap handler.
  w_mtvec((reg_t)sys_timer);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
}

static int timer_count = 0;

void timer_handler() {
  lib_printf("timer_handler: %d\n", ++timer_count);
  // os_kernel();
}
