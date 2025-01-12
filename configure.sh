#!/bin/bash -ex

git submodule update --init --recursive --jobs 16
git apply changes-linux-kernel.patch
make -C linux-kernel-4.17 menuconfig HOSTCC=gcc-8 CC=gcc-8

