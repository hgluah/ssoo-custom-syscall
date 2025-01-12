#!/bin/bash -ex

cd linux-4.17.19/
git diff > ../changes-linux-kernel.patch

