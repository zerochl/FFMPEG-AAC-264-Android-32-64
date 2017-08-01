#!/bin/sh
FFMPEG_TMPDIR=I:/document/resourceCode/fdk-aac/temp
export FFMPEG_TMPDIR
NDK_HOME=I:/soft/android-ndk-r14b
ANDROID_API=android-14

SYSROOT=$NDK_HOME/platforms/$ANDROID_API/arch-arm

ANDROID_BIN=$NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/windows-x86_64/bin/

CROSS_COMPILE=${ANDROID_BIN}/arm-linux-androideabi-
 
ARM_INC=$SYSROOT/usr/include

ARM_LIB=$SYSROOT/usr/lib
TOOLCHAIN_PREFIX=${NDK_HOME}/toolchains/arm-linux-androideabi-4.9/prebuilt/windows-x86_64/bin/arm-linux-androideabi-

LDFLAGS=" -nostdlib -Bdynamic -Wl,--whole-archive -Wl,--no-undefined -Wl,-z,noexecstack  -Wl,-z,nocopyreloc -Wl,-soname,/system/lib/libz.so -Wl,-rpath-link=$ARM_LIB,-dynamic-linker=/system/bin/linker -L$NDK_HOME/sources/cxx-stl/gnu-libstdc++/4.9/libs/armeabi-v7a -L$NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/windows-x86_64/arm-linux-androideabi/lib -L$ARM_LIB  -lc -lgcc -lm -ldl  "

FLAGS="--host=armv7a-linux-androideabi --enable-static --disable-shared"

export CXX="${CROSS_COMPILE}g++ --sysroot=${SYSROOT}"

# export LDFLAGS="$LDFLAGS"
export CFLAGS="-O3 -DANDROID -march=armv7-a -mfloat-abi=softfp -mfpu=neon"
export LDFLAGS="-Wl,-dynamic-linker=/system/bin/linker"
export CC="${TOOLCHAIN_PREFIX}gcc --sysroot=${SYSROOT}"
export CXX="${TOOLCHAIN_PREFIX}g++ --sysroot=${SYSROOT}"
export STRIP="${TOOLCHAIN_PREFIX}strip"
export RANLIB="${TOOLCHAIN_PREFIX}ranlib"
export AR="${TOOLCHAIN_PREFIX}ar"


export CC="${CROSS_COMPILE}gcc --sysroot=${SYSROOT}"
PREFIX=I:/document/resourceCode/fdk-aac/android/armv7a
./configure $FLAGS \
--prefix=$PREFIX

make clean
make -j8
make install