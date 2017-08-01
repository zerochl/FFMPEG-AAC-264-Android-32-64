#!/bin/bash
export TMPDIR=I:/document/resourceCode/ffmpeg-3.2.5/ffmpegtemp #设置编译中临时文件目录，不然会报错 unable to create temporary file
#Change NDK to your Android NDK location
NDK=I:/soft/android-ndk-r14b
PLATFORM=$NDK/platforms/android-22/arch-x86_64/
PREBUILT=$NDK/toolchains/x86_64-4.9/prebuilt/windows-x86_64

GENERAL="\
--enable-small \
--enable-cross-compile \
--extra-libs="-lgcc" \
--cc=$PREBUILT/bin/x86_64-linux-android-gcc \
--cross-prefix=$PREBUILT/bin/x86_64-linux-android- \
--nm=$PREBUILT/bin/x86_64-linux-android-nm "

MODULES="\
--enable-gpl"


function build_x86_64
{
  ./configure \
  --logfile=conflog.txt \
  --target-os=linux \
  --prefix=./android/x86_64 \
  --arch=x86_64 \
  ${GENERAL} \
  --sysroot=$PLATFORM \
  --extra-cflags="-march=x86-64 -msse4.2 -mpopcnt -m64 -mtune=intel" \
  --enable-shared \
  --disable-static \
  --enable-zlib \
  --disable-doc \
  ${MODULES}

  make clean
  make -j8
  make install
}

build_x86_64


echo Android X86_64 builds finished