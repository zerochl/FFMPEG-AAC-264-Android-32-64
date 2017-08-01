#!/bin/bash
NDK=I:/soft/android-ndk-r14b
PLATFORM=$NDK/platforms/android-14/arch-x86/
TOOLCHAIN=$NDK/toolchains/x86-4.9/prebuilt/windows-x86_64
PREFIX=./android/x86

function build_one
{
  ./configure \
  --prefix=$PREFIX \
  --enable-static \
  --enable-pic \
  --disable-asm \
  --host=x86-linux-android \
  --cross-prefix=$TOOLCHAIN/bin/i686-linux-android- \
  --sysroot=$PLATFORM

  make clean
  make -j8
  make install
}

build_one

echo Android x86 builds finished