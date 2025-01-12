#!/bin/bash -ex

KERNEL_NAME=linux-4.17.19

[ -d linux-kernel-4.17 ] || (
	wget -qO- "https://www.kernel.org/pub/linux/kernel/v4.x/${KERNEL_NAME}.tar.gz" | tar xz &&
	cd $KERNEL_NAME &&
	git init -q && git add . &&
	git apply ../changes-linux-kernel.patch
)
make -C $KERNEL_NAME menuconfig HOSTCC=gcc-8 CC=gcc-8

