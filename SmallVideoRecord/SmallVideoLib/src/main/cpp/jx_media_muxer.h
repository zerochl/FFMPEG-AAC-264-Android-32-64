
/**
 * Created by zero on 2017/5/18.
 * https://github.com/zerochl/FFMPEG-AAC-264-Android-32-64
 * zerochl0912@gmail.com
 */
#ifndef JIANXIFFMPEG_JX_MEDIA_MUXER_H
#define JIANXIFFMPEG_JX_MEDIA_MUXER_H


#include "base_include.h"
#define USE_H264BSF 1
#define USE_AACBSF 1


class JXMediaMuxer{
public:
    int startMuxer(const char * video, const char *audio , const char *out_file);

private:

};

#endif //JIANXIFFMPEG_JX_MEDIA_MUXER_H
