#!/bin/bash -ex

make -C linux-kernel-4.17 -j16 HOSTCC=gcc-8 CC=gcc-8

