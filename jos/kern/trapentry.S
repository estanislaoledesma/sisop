/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */

handler0:
	TRAPHANDLER_NOEC(divide, T_DIVIDE);
handler1:
	TRAPHANDLER_NOEC(debug, T_DEBUG);
handler2:
	TRAPHANDLER_NOEC(nmi, T_NMI);
handler3:
	TRAPHANDLER_NOEC(brkpt, T_BRKPT);
handler4:
	TRAPHANDLER_NOEC(oflow, T_OFLOW);
handler5:
	TRAPHANDLER_NOEC(bound_check, T_BOUND);
handler6:
	TRAPHANDLER_NOEC(illop, T_ILLOP);
handler7:
	TRAPHANDLER_NOEC(device, T_DEVICE);
handler8:
	TRAPHANDLER(dblflt, T_DBLFLT);
handler10:
	TRAPHANDLER(tss, T_TSS);
handler11:
	TRAPHANDLER(segnp, T_SEGNP);
handler12:
	TRAPHANDLER(stack, T_STACK);
handler13:
	TRAPHANDLER(gpflt, T_GPFLT);
handler14:
	TRAPHANDLER(pgflt, T_PGFLT);
handler16:
	TRAPHANDLER_NOEC(fperr, T_FPERR);
handler17:
	TRAPHANDLER(align, T_ALIGN);
handler18:
	TRAPHANDLER_NOEC(mchk, T_MCHK);
handler19:
	TRAPHANDLER_NOEC(simderr, T_SIMDERR);


handler32:
	TRAPHANDLER_NOEC(clock, IRQ_OFFSET+IRQ_TIMER);


handler48:
	TRAPHANDLER_NOEC(t_syscall, T_SYSCALL);

/*
 * Lab 3: Your code here for _alltraps
 */

_alltraps:
	// Push values to make the stack look like a struct Trapframe
	pushl %ds
	pushl %es
	// pushal save the general-purpose registers.
	// Push EAX, ECX, EDX, EBX, original ESP, EBP, ESI, and EDI
	pushal

	// %ds y %es son 16-bit segment registers por eso se debe guardar
	// GD_KD (32 bits) en un reg auxiliar para luego copiar solo 16 bits
	movl $GD_KD, %eax
	movw %ax, %ds
	movw %ax, %es
	// Pass a pointer to the Trapframe as an argument to trap()
	pushl %esp;
	call trap;
