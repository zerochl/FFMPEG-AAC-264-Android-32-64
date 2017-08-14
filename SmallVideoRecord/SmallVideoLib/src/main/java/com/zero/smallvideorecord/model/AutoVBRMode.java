package com.zero.smallvideorecord.model;

/**
 * Created by zero on 2017/5/18.
 * https://github.com/zerochl/FFMPEG-AAC-264-Android-32-64
 * zerochl0912@gmail.com
 */

public class AutoVBRMode extends BaseMediaBitrateConfig {

    public AutoVBRMode(){
        this.mode= MODE.AUTO_VBR;
    }

    /**
     *
     * @param crfSize 压缩等级，0~51，值越大约模糊，视频越小，建议18~28.
     */
    public AutoVBRMode(int crfSize){
        if(crfSize<0||crfSize>51){
            throw  new IllegalArgumentException("crfSize 在0~51之间");
        }
        this.crfSize=crfSize;
        this.mode= MODE.AUTO_VBR;
    }
}
