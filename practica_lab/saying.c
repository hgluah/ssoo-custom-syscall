#include<linux/kernel.h>

asmlinkage long sys_saying(void) {
    printk("Texto de ejemplo!");
    return 0;
}
