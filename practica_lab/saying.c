#include<linux/kernel.h>
#include <linux/syscalls.h>

SYSCALL_DEFINE2(saying, int, a, int, b) {
    printk("El resultado de sumar %d y %d es %d", a, b, a+b);
    return 0;
}

