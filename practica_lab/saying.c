#include<linux/kernel.h>

asmlinkage long sys_saying(int a, int b) {
    printk("El resultado de sumar %d y %d es %d", a, b, a+b);
    return 0;
}

