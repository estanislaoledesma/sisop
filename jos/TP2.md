TP2: Procesos de usuario
========================

env_alloc
---------
**1.** En los primeros cinco procesos **e->env_id** vale 0, entonces *generation* equivale a la siguiente constante **(1 << ENVGENSHIFT) & ~(NENV - 1)**  
  
 1 << ENVGENSHIFT = 1 << 12 = 0x1000  
 ~(NENV - 1) = ~(1024 - 1) = ~(1023) = 0xFE00  
  
 Entonces (1 << ENVGENSHIFT) & ~(NENV - 1) = 0x1000 & 0xFE00 = 0x1000.  
  
 Por lo tanto se tiene que generation = 0x1000 (4096) para los cinco procesos.  
 
 Para el valor **(e - envs)** se tiene que, como la lista enlazada de procesos libres sigue el orden de envs, valdra 0, 1, 2, 3, 4 para los primeros cinco procesos respectivamente.  
  
 Finalmente, los id asignados a los primeros cinco procesos son:  

 Proceso 0 - e->env_id = generation | (e - envs) = 0x1000 | 0x0 = 0x1000 = 4096  
 Proceso 1 - e->env_id = generation | (e - envs) = 0x1000 | 0x1 = 0x1001 = 4097  
 Proceso 2 - e->env_id = generation | (e - envs) = 0x1000 | 0x2 = 0x1002 = 4098  
 Proceso 3 - e->env_id = generation | (e - envs) = 0x1000 | 0x3 = 0x1003 = 4099  
 Proceso 4 - e->env_id = generation | (e - envs) = 0x1000 | 0x4 = 0x1004 = 4100  
  
**2.** Al destruir el proceso **env[630]** su struct se reinsertara en la lista de procesos libres, como se lanzaron NENV procesos a ejecución la lista estara vacia, entonces el nuevo proceso utilizara el struct del **env[630]** cuyo id es 4096 + 630 = 4726. Al morir y volverse a ejecutar utilizara el anterior struct, asi sucesivamente. Por lo que los id asignados seran:  

1era ejec - generation = (4726 + 2^12) & ~(1023) = (8822) & ~(1023) = 8192  
			 - e->env_id = generation | (e - envs) = 8192 | 630 = 8822  
  
2da ejec - generation = (8822 + 2^12) & ~(1023) = (12918) & ~(1023) = 12288  
			 - e->env_id = generation | (e - envs) = 12288 | 630 = 12918  
  
3era ejec - generation = (12918 + 2^12) & ~(1023) = (17014) & ~(1023) = 16384  
			 - e->env_id = generation | (e - envs) = 16384 | 630 = 17014  
  
4ta ejec - generation = (17014 + 2^12) & ~(1023) = (21110) & ~(1023) = 20480  
			 - e->env_id = generation | (e - envs) = 20480 | 630 = 21110  
  
5ta ejec - generation = (21110 + 2^12) & ~(1023) = (25206) & ~(1023) = 24576  
			 - e->env_id = generation | (e - envs) = 24576 | 630 = 25206  
  

env_init_percpu
---------------

Se escriben 6*13*4 = 312 bytes por cada descriptor de segmento (6 descriptores, 13compunentes del struct Segdesc de 4 bytes) dentro de la gdt (donde escribe lgdt).
No se pueden usar distintas gdks para procesos en paralelo, porque estas definen privilegios, entonces ambas podrían estar ejecutando instrucciones de kernel.

env_pop_tf
----------

1. Luego del primer movl de la función, en el registro %esp está el puntero a Trapframe tf. 
2. Después del último iret, el %esp contiene el registro %eip de tf.
3. Para chequear si hay un cambio en el nivel de privilegios, el procesador debe chequear los bits de CPL (current privilege level) y DPL (descriptor privilege level) del segmento de código de regreso del IRET. Si DPL es mayor a CPL, se produjo un cambio de nivel.

gdb_hello
---------

...
