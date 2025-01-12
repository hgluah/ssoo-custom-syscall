#!/bin/bash -ex

[ -d linux-kernel-4.17 ] || (wget -qO- https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.17.19.tar.gz | tar xz && cd linux-4.17.19 && git init -q && git add .)
git -C linux-4.17.19/ apply changes-linux-kernel.patch
make -C linux-kernel-4.17 menuconfig HOSTCC=gcc-8 CC=gcc-8

