# FFMPEG-AAC-264-Android-32-64
android视频压缩，使用ffmpeg方案，集成fdk-aac与264编码，适用于32位系统与64位系统，ARM cpu与x86 cpu，mips理论都可以，不过占有量太小，被我忽略了
# fdk-aac
acc源码，编译方式已经整理为sh文件，见build_ARM.sh ...
# x264
x264源码，编译方式已经整理为sh文件
# ffmpeg-3.2.5
ffmpeg-3.2.5源码，编译完aac与x264之后将结果copy到mylib文件夹下，然后执行ffmpeg的sh文件进行编译
# SmallVideoRecord
SmallVideoRecord Android工程，包含lib工程与example工程，lib给ffmpeg做了封装，实现了ffmepg拍摄与视频压缩。
# 使用详解
# 在manifests里面添加

        <activity
            android:name="com.zero.smallvideorecord.VideoPlayerActivity"
            android:theme="@style/AppNoBarTheme"

            />
        <activity
            android:name="com.zero.smallvideorecord.MediaRecorderActivity"
            android:theme="@style/AppNoBarTheme"
            />
        <activity
            android:name="com.zero.smallvideorecord.SendSmallVideoActivity"
            android:theme="@style/AppNoBarTheme" />
# 在Application里面初始化小视频录制
        public static void initSmallVideo(Context context) {
             // 设置拍摄视频缓存路径
             File dcim = Environment
                     .getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM);
             if (DeviceUtils.isZte()) {
                 if (dcim.exists()) {
                     JianXiCamera.setVideoCachePath(dcim + "/mabeijianxi/");
                 } else {
                     JianXiCamera.setVideoCachePath(dcim.getPath().replace("/sdcard/",
                             "/sdcard-ext/")
                             + "/zero/");
                 }
             } else {
                 JianXiCamera.setVideoCachePath(dcim + "/zero/");
             }
        // 开启log输出,ffmpeg输出到logcat
             //JianXiCamera.setDebugMode(true);
        // 初始化拍摄SDK，必须
             JianXiCamera.initialize(context,null);
         }
# 跳转录制界面或选择压缩
          // 录制
        MediaRecorderConfig config = new MediaRecorderConfig.Buidler()
                     .doH264Compress(new AutoVBRMode()
        //                        .setVelocity(BaseMediaBitrateConfig.Velocity.ULTRAFAST)
                             )
                     .setMediaBitrateConfig(new AutoVBRMode()
        //                        .setVelocity(BaseMediaBitrateConfig.Velocity.ULTRAFAST)
                     )
                     .smallVideoWidth(480)
                     .smallVideoHeight(360)
                     .recordTimeMax(6 * 1000)
                     .maxFrameRate(20)
                     .captureThumbnailsTime(1)
                     .recordTimeMin((int) (1.5 * 1000))
                     .build();
             MediaRecorderActivity.goSmallVideoRecorder(this, SendSmallVideoActivity.class.getName(), config);
        // 选择本地视频压缩
        LocalMediaConfig.Buidler buidler = new LocalMediaConfig.Buidler();
                             final LocalMediaConfig config = buidler
                                     .setVideoPath(path)
                                     .captureThumbnailsTime(1)
                                     .doH264Compress(new AutoVBRMode())
                                     .setFramerate(15)
                                     .build();
                             OnlyCompressOverBean onlyCompressOverBean = new LocalMediaCompress(config).startCompress();
# 一些参数说明
        maxFrameRate：指定最大帧率，越大视频质量越好，体积也会越大，当在cbr模式下不再是动态帧率，而是固定帧率；

         captureThumbnailsTime：指定剪切哪个时间的画面来作为封面图；

         doH264Compress：不传入值将不做进一步压缩，暂时可以传入三种模式AutoVBRMode、VBRMode、VBRMode；

         setMediaBitrateConfig:视频录制时期的一些配置，暂时可以传入三种模式AutoVBRMode、VBRMode、VBRMode；

         AutoVBRMode：可以传入一个视频等级与转码速度，等级为0-51，越大质量越差，建议18~28之间即可。转码速度有ultrafast、superfast、            veryfast、faster、fast、medium、slow、slower、veryslow、placebo。

         VBRMode：此模式下可以传入一个最大码率与一个额定码率，当然同样可以设置转码速度。

         VBRMode:可以传入一个固定码率，也可以添加一个转码速度。

作者联系方式：QQ：975804495
疯狂的程序员群：186305789，没准你能遇到绝影大神

# 关于项目文件很大的问题
首先项目看着很大，其实编译之后差不多11M左右，建议lib导出成aar然后导入到自己项目，
其次可根据自己需求重新执行sh文件，configure提供disable与enable各种功能的方法，disable之后就不会打包到so库中，从而减小so大小

# 交叉编译的时候遇到一些坑，分享出来，希望对其他人有所帮助。

（1） 编译ffmpeg时提示找不到libfdk-aac扩这libx264。这个问题是由于ffmpeg的交叉编译器找不到libfdk-aac/x264的头文件或者是静态库导致的，解决这个问题只要将ffmpeg、libfdk-aac、libx264的–prefix选项指向相同的目录，并且在调用ffmpeg的configure脚本时指定–extra-cflags=“-I${PREFIX}/include”和–extra-ldflags=“-L${PREFIX}/lib -lx264 -lfdk-aac”即可，另外请主要configure的libfdk-aac支持选项有时候是libfdk-aac（小短线），有时候又是libfdk_aac（下划线）。如果还没解决问题，就查configure生成的日志文件config.log；

（2） 编译了32位so文件后再编译64位so文件时，提示strtod.o的文件格式不对。这是由于对于3.2版本的ffmpeg，make clean不会删除compat下的strtod.o，strtod.d, msvcrt/snprintf.o, msvcrt/snprintf.d四个文件，只要手动删除后重新编译即可。具体可以参考简书上esonyf的这篇文章：http://www.jianshu.com/p/612ef67e42bd

（3） 找不到AAC或者H264编解码器（调用avodec_find_decoder|encoder(AVCODEC_ID_AAC|AVCODEC_ID_H264)返回失败）。造成这个问题的原因是为了减小生成库的大小，我在congiure时启用了–disable-encoders和–disable-decoders选项，这种情况下除了要使用–enable-libx264和–enable-libfdk-aac，还应该使用–enable-encoder=libx264|libfdk_aac选项显示启用libfdk-aac和libx264作为编解码器。

（4） configure时候提示找不到可工作的C Compiler。configure脚本的这个提示具有一定误导性，让我以为是交叉编译器gcc的路径配错了，通过分析config.log才发现extra-cflags、extra-ldflags里面有当前CPU架构不支持的选项时都会导致交叉编译器测试失败，然后返回这个错误。解决这个问题主要是通过分析config.log脚本来解决。由于x264的configure脚本不把这个错误信息放在config.log里面，只能通过在其configure脚本开头添加set
-x选项来启动调试。

