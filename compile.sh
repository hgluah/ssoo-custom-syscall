#!/bin/bash -ex

make -C linux-4.17.19 -j`nproc` HOSTCC=gcc-8 CC=gcc-8

