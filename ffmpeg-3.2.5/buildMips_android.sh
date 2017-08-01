#!/bin/bash
#Change NDK to your Android NDK location
NDK=I:/soft/android-ndk-r14b
PLATFORM=$NDK/platforms/android-18/arch-mips/
PREBUILT=$NDK/toolchains/mipsel-linux-android-4.9/prebuilt/windows-x86_64


GENERAL="\
--enable-small \
--enable-cross-compile \
--extra-libs="-lgcc" \
--cc=$PREBUILT/bin/mipsel-linux-android-gcc \
--cross-prefix=$PREBUILT/bin/mipsel-linux-android- \
--nm=$PREBUILT/bin/mipsel-linux-android-nm"

MODULES="\
--enable-gpl"


function build_mips
{
  ./configure \
  --logfile=conflog.txt \
  --target-os=linux \
  --prefix=./android/mips \
  --arch=mips \
  ${GENERAL} \
  --sysroot=$PLATFORM \
  --enable-shared \
  --disable-static \
  --disable-mipsdspr1 --disable-mipsdspr2 --disable-mipsfpu \
  --extra-ldflags="-lx264 -Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog" \
  --enable-zlib \
  --disable-doc \
  ${MODULES}

  make clean
  make -j2
  make install
}

build_mips


echo Android MIPS builds finished