#!/bin/bash -ex

git -C linux-4.17.19/ diff > changes-linux-kernel.patch

