/**
 * Created by zero on 2017/5/18.
 * https://github.com/zerochl/FFMPEG-AAC-264-Android-32-64
 * zerochl0912@gmail.com
 */
#ifndef JIANXIFFMPEG_FFMPEG_RUN_H
#define JIANXIFFMPEG_FFMPEG_RUN_H

#include <jni.h>

JNIEXPORT jint JNICALL
Java_com_zero_smallvideorecord_jniinterface_FFmpegBridge_jxCMDRun(JNIEnv *env, jclass type,
                                                                       jobjectArray commands);

void log_callback(void* ptr, int level, const char* fmt,
                            va_list vl);

JNIEXPORT void JNICALL
Java_com_zero_smallvideorecord_jniinterface_FFmpegBridge_initJXFFmpeg(JNIEnv *env, jclass type,
        jboolean debug,
jstring logUrl_);

int ffmpeg_cmd_run(int argc, char **argv);
#endif //JIANXIFFMPEG_FFMPEG_RUN_H
