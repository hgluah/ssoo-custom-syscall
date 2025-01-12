#!/bin/bash -ex

git diff --submodule=diff -- linux-kernel-4.17/ > changes-linux-kernel.patch
