TP1: Memoria virtual en JOS
===========================

page2pa
-------
 **pages** es un array de 'struct PageInfo's que representan las páginas físicas de la memoria. Cada página es de 4096 bytes. **pp** es un puntero a una de las páginas de **pages**. Al restarle **pages** (que apunta al comienzo del array) se obtiene el numero de página que apunta **pp**, entonces para obtener la dirección de memoria fisica le debo multiplicar lo que ocupa cada página, que son 4096 bytes = 2^12 bytes, que es lo que hace *page2pa()* al hacer el left shift de PGSHFT cuyo valor es 12 (definido en inc/mmu.h).


boot_alloc_pos
--------------
a)
f0117950 B end (nm kernel)
nextfree = ROUNDUP((char *) end, PGSIZE) = ROUNDUP(0xf0117950, 0x1000)
         = ROUNDDOWN(0xf0117950 + 0x1000 - 0x1, 0x1000)
         = ROUNDDOWN(0xf011894f, 0x1000) = 0xf011894f + 0xf011894f % 0x1000
         = 0xf011894f + 0x94f 
         = 0xf011929e
b)
segmentation-fault?

page_alloc
----------
La función page2pa() toma una página (puntero a PageInfo) y devuelve su
dirección física. La función page2kva obtiene la dirección física de la
página pasada por parámetro, pero luego le aplica la macro KADDR que de-
vuelve la correspondiente página virtual del kernel.


