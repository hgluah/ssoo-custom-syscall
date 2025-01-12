#!/bin/bash -ex

sudo make -C linux-4.17.19 -j`nproc` modules_install install

