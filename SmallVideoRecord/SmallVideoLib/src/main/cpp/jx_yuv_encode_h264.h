
/**
 * Created by zero on 2017/5/18.
 * https://github.com/zerochl/FFMPEG-AAC-264-Android-32-64
 * zerochl0912@gmail.com
 */
#ifndef JIANXIFFMPEG_JX_YUV_ENCODE_H264_H
#define JIANXIFFMPEG_JX_YUV_ENCODE_H264_H



#include "base_include.h"

#include "jx_user_arguments.h"

using namespace std;
/**
 * yuv编码h264
 */
class JXYUVEncodeH264 {
public:
    JXYUVEncodeH264(UserArguments* arg);
public:
    int initVideoEncoder();

    static void* startEncode(void * obj);

    int startSendOneFrame(uint8_t *buf);

    void user_end();

    int encodeEnd();

    void custom_filter(const JXYUVEncodeH264 *h264_encoder, const uint8_t *picture_buf,
                       int in_y_size,
                       int format);
private:
    int flush_encoder(AVFormatContext *fmt_ctx, unsigned int stream_index);

private:
    UserArguments *arguments;
    int is_end = 0;
    threadsafe_queue<uint8_t *> frame_queue;
    AVFormatContext *pFormatCtx;
    AVOutputFormat *fmt;
    AVStream *video_st;
    AVCodecContext *pCodecCtx;
    AVCodec *pCodec;
    AVPacket pkt;
    AVFrame *pFrame;
    int picture_size;
    int out_y_size;
    int framecnt = 0;
    int frame_count = 0;
    ~JXYUVEncodeH264() {
    }

};

#endif //JIANXIFFMPEG_JX_YUV_ENCODE_H264_H
