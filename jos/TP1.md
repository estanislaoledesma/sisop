TP1: Memoria virtual en JOS
===========================

page2pa
-------
 **pages** es un array de 'struct PageInfo's que representan las páginas físicas de la memoria. Cada página es de 4096 bytes. **pp** es un puntero a una de las páginas de **pages**. Al restarle **pages** (que apunta al comienzo del array) se obtiene el numero de página que apunta **pp**, entonces para obtener la dirección de memoria fisica le debo multiplicar lo que ocupa cada página, que son 4096 bytes = 2^12 bytes, que es lo que hace *page2pa()* al hacer el left shift de PGSHFT cuyo valor es 12 (definido en inc/mmu.h).


boot_alloc_pos
--------------

...


page_alloc
----------

...


