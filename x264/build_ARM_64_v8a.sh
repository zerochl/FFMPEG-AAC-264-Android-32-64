#!/bin/bash
NDK=I:/soft/android-ndk-r14b
PLATFORM=$NDK/platforms/android-21/arch-arm64/
TOOLCHAIN=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/windows-x86_64
PREFIX=./android/arm64-v8a

function build_one
{
  ./configure \
  --prefix=$PREFIX \
  --enable-static \
  --enable-pic \
  --host=aarch64-linux-android \
  --cross-prefix=$TOOLCHAIN/bin/aarch64-linux-android- \
  --sysroot=$PLATFORM

  make clean
  make -j8
  make install
}

build_one

echo Android ARM64 builds finished