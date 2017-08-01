#!/bin/bash
NDK=I:/soft/android-ndk-r14b
PLATFORM=$NDK/platforms/android-21/arch-x86_64/
TOOLCHAIN=$NDK/toolchains/x86_64-4.9/prebuilt/windows-x86_64
PREFIX=./android/x86_64

function build_one
{
  ./configure \
  --prefix=$PREFIX \
  --enable-static \
  --enable-pic \
  --disable-asm \
  --host=x86_64-linux-android \
  --cross-prefix=$TOOLCHAIN/bin/x86_64-linux-android- \
  --sysroot=$PLATFORM

  make clean
  make -j8
  make install
}

build_one

echo Android ARM64 builds finished