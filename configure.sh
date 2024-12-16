#!/bin/bash -ex

git apply linux-kernel.patch
make -C linux-kernel-4.17 menuconfig
