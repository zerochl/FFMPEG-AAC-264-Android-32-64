#!/bin/bash
export TMPDIR=I:/document/resourceCode/ffmpeg-3.2.5/ffmpegtemp #设置编译中临时文件目录，不然会报错 unable to create temporary file
# NDK的路径，根据自己的安装位置进行设置
NDK=I:/soft/android-ndk-r14b
# 编译针对的平台，可以根据自己的需求进行设置
# 这里选择最低支持android-14, arm架构，生成的so库是放在
# libs/armeabi文件夹下的，若针对x86架构，要选择arch-x86
PLATFORM=$NDK/platforms/android-14/arch-x86
# PLATFORM=$NDK/platforms/android-21/arch-arm
# 工具链的路径，根据编译的平台不同而不同
# arm-linux-androideabi-4.9与上面设置的PLATFORM对应，4.9为工具的版本号，
# 根据自己安装的NDK版本来确定，一般使用最新的版本
TOOLCHAIN=$NDK/toolchains/x86-4.9/prebuilt/windows-x86_64

INC=I:/document/resourceCode/ffmpeg-3.2.5/mylib/x86
FF_EXTRA_CFLAGS="-O3 -DANDROID -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"
FF_CFLAGS="-Wall -pipe \
-ffast-math \
-fstrict-aliasing -Werror=strict-aliasing \
-Wno-psabi -Wa,--noexecstack \
-DANDROID  \
-I$INC/include -I$INC/include/fdk-aac "

CPU=x86
PREFIX=./android/$CPU-vfp

build_one(){
./configure \
--prefix=$PREFIX \
--enable-cross-compile \
--disable-runtime-cpudetect \
--disable-asm \
--arch=x86 \
--target-os=android \
--cc=$TOOLCHAIN/bin/i686-linux-android-gcc \
--cross-prefix=$TOOLCHAIN/bin/i686-linux-android- \
--disable-stripping \
--nm=$TOOLCHAIN/bin/i686-linux-android-nm \
--sysroot=$PLATFORM \
--enable-gpl \
--enable-shared \
--disable-static \
--enable-version3 \
--enable-pthreads \
--enable-small \
--disable-vda \
--disable-iconv \
--disable-encoders \
--enable-libx264 \
--enable-neon \
--enable-yasm \
--enable-libfdk_aac \
--enable-encoder=libx264 \
--enable-encoder=libfdk_aac \
--enable-encoder=mjpeg \
--enable-encoder=png \
--enable-nonfree \
--enable-muxers \
--enable-muxer=mov \
--enable-muxer=mp4 \
--enable-muxer=aac \
--enable-muxer=h264 \
--enable-muxer=avi \
--disable-decoders \
--enable-decoder=aac \
--enable-decoder=aac_latm \
--enable-decoder=h264 \
--enable-decoder=mpeg4 \
--enable-decoder=mjpeg \
--enable-decoder=png \
--disable-demuxers \
--enable-demuxer=image2 \
--enable-demuxer=h264 \
--enable-demuxer=aac \
--enable-demuxer=avi \
--enable-demuxer=mpc \
--enable-demuxer=mov \
--disable-parsers \
--enable-parser=aac \
--enable-parser=ac3 \
--enable-parser=h264 \
--disable-protocols \
--enable-protocol=file \
--enable-zlib \
--enable-avfilter \
--disable-outdevs \
--disable-ffprobe \
--disable-ffplay \
--disable-ffmpeg \
--disable-ffserver \
--disable-debug \
--disable-ffprobe \
--disable-ffplay \
--disable-ffmpeg \
--disable-postproc \
--disable-avdevice \
--disable-symver \
--disable-stripping \
--extra-cflags="$FF_CFLAGS $FF_EXTRA_CFLAGS" \
--extra-ldflags="-Wl,-L$INC/lib"
}
build_one
make clean
make -j8
make install

