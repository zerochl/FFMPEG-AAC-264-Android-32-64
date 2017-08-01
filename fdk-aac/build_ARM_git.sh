#!/bin/bash
#use this bash-script to build libfdk-aac library.

TARGET_HOST=armv7a-linux-androideabi
SYSROOT_ARCH_DIRNAME=arch-arm
OPTIMIZE_OPTION="-O3 -DANDROID"
LIBMEDIA_TARGET_ARCH_ABI=armeabi-v7a
NDK_ROOT_PATH=I:/soft/android-ndk-r14b
LIBMEDIA_TARGET_PLATFORM=android-21
TOOLCHAIN_VERSION=4.9
FFMPEG_TMPDIR=I:/document/resourceCode/fdk-aac/temp
case $LIBMEDIA_TARGET_ARCH_ABI in
armeabi*v7a)
    TARGET_HOST=armv7a-linux-androideabi
    SYSROOT_ARCH_DIRNAME=arch-arm
	OPTIMIZE_OPTION="-O3 -DANDROID -march=armv7-a -mfloat-abi=softfp -mfpu=neon"
    TOOLCHAIN_PREFIX=${NDK_ROOT_PATH}/toolchains/arm-linux-androideabi-${TOOLCHAIN_VERSION}/prebuilt/windows-x86_64/bin/arm-linux-androideabi-
    ;;
armeabi)
    TARGET_HOST=arm-linux-android
    SYSROOT_ARCH_DIRNAME=arch-arm
	OPTIMIZE_OPTION="-O3 -DANDROID -march=armv5te"
    TOOLCHAIN_PREFIX=${NDK_ROOT_PATH}/toolchains/arm-linux-androideabi-${TOOLCHAIN_VERSION}/prebuilt/linux-x86_64/bin/arm-linux-androideabi- 
    ;;
arm64*v8a)
	TARGET_HOST=aarch64-linux-android
    SYSROOT_ARCH_DIRNAME=arch-arm64
	OPTIMIZE_OPTION="-O3 -DANDROID -march=armv8-a"
    TOOLCHAIN_PREFIX=${NDK_ROOT_PATH}/toolchains/aarch64-linux-android-${TOOLCHAIN_VERSION}/prebuilt/linux-x86_64/bin/aarch64-linux-android-
    ;;
x86)
    TARGET_HOST=x86-linux-android
	SYSROOT_ARCH_DIRNAME=arch-x86
	OPTIMIZE_OPTION="-O3 -DANDROID -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"
    TOOLCHAIN_PREFIX=${NDK_ROOT_PATH}/toolchains/x86-${TOOLCHAIN_VERSION}/prebuilt/linux-x86_64/bin/i686-linux-android-
    ;;
x86*64*)
    TARGET_HOST=x86_64-linux-android
	SYSROOT_ARCH_DIRNAME=arch-x86_64
	OPTIMIZE_OPTION="-O3 -DANDROID -march=x86-64 -msse4.2 -mpopcnt -m64 -mtune=intel"
    TOOLCHAIN_PREFIX=${NDK_ROOT_PATH}/toolchains/x86_64-${TOOLCHAIN_VERSION}/prebuilt/linux-x86_64/bin/x86_64-linux-android-
	;;
mips)
	#I don't know how to optimize mips
	TARGET_HOST=mipsel-linux-android
	SYSROOT_ARCH_DIRNAME=arch-mips
	OPTIMIZE_OPTION="-O3 -DANDROID"
    TOOLCHAIN_PREFIX=${NDK_ROOT_PATH}/toolchains/mipsel-linux-android-${TOOLCHAIN_VERSION}/prebuilt/linux-x86_64/bin/mipsel-linux-android-
    ;;
mips64)
    TARGET_HOST=mips64el-linux-android
    SYSROOT_ARCH_DIRNAME=arch-mips64
	OPTIMIZE_OPTION="-O3 -DANDROID"
    TOOLCHAIN_PREFIX=${NDK_ROOT_PATH}/toolchains/mips64el-linux-android-${TOOLCHAIN_VERSION}/prebuilt/linux-x86_64/mips64el-linux-android-
    ;;
*) 
   echo "unsupported arch(${LIBMEDIA_TARGET_ARCH_ABI}), please change your set-env.sh";
   exit 1
   ;;
esac


SYSROOT=${NDK_ROOT_PATH}/platforms/${LIBMEDIA_TARGET_PLATFORM}/${SYSROOT_ARCH_DIRNAME}
PREFIX=I:/document/resourceCode/fdk-aac/android/${LIBMEDIA_TARGET_ARCH_ABI}

export CFLAGS="${OPTIMIZE_OPTION}"
export LDFLAGS="-Wl,-dynamic-linker=/system/bin/linker"
export CC="${TOOLCHAIN_PREFIX}gcc --sysroot=${SYSROOT}"
export CXX="${TOOLCHAIN_PREFIX}g++ --sysroot=${SYSROOT}"
export STRIP="${TOOLCHAIN_PREFIX}strip"
export RANLIB="${TOOLCHAIN_PREFIX}ranlib"
export AR="${TOOLCHAIN_PREFIX}ar"

./configure --prefix=$PREFIX \
  --host=$TARGET_HOST \
  --with-sysroot=$SYSROOT \
  --enable-static=yes --enable-shared=no

if test $? -ne 0;then
    exit $?
fi

make clean
make
make install