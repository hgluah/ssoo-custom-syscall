#include <stdio.h>
#include <linux/kernel.h>
#include <sys/syscall.h>
#include <unistd.h>

int main() {
	long int result = syscall(333, 34, 35);
	printf("Resultado de la syscall: %ld\n", result);
	return 0;
}
