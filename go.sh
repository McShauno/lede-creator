#!/bin/bash

ln -s ../download download
cp --recursive download/build/structure/* ./
download/common/patch-all.sh download/build/patches
scripts/feeds update -a
scripts/feeds update -i
scripts/feeds install -a

