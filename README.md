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
在manifests里面添加

        <activity
            android:name="com.mabeijianxi.smallvideo2.VideoPlayerActivity"
            android:theme="@style/AppNoBarTheme"

            />
        <activity
            android:name="com.mabeijianxi.smallvideorecord2.MediaRecorderActivity"
            android:theme="@style/AppNoBarTheme"
            />
        <activity
            android:name="com.mabeijianxi.smallvideo2.SendSmallVideoActivity"
            android:theme="@style/AppNoBarTheme" />
在Application里面初始化小视频录制
        public static void initSmallVideo(Context context) {
             // 设置拍摄视频缓存路径
             File dcim = Environment
                     .getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM);
             if (DeviceUtils.isZte()) {
                 if (dcim.exists()) {
                     VCamera.setVideoCachePath(dcim + "/mabeijianxi/");
                 } else {
                     VCamera.setVideoCachePath(dcim.getPath().replace("/sdcard/",
                             "/sdcard-ext/")
                             + "/mabeijianxi/");
                 }
             } else {
                 VCamera.setVideoCachePath(dcim + "/mabeijianxi/");
             }
        // 开启log输出,ffmpeg输出到logcat
             VCamera.setDebugMode(true);
        // 初始化拍摄SDK，必须
             VCamera.initialize(context);
         }
跳转录制界面或选择压缩
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
一些参数说明
        maxFrameRate：指定最大帧率，越大视频质量越好，体积也会越大，当在cbr模式下不再是动态帧率，而是固定帧率；

         captureThumbnailsTime：指定剪切哪个时间的画面来作为封面图；

         doH264Compress：不传入值将不做进一步压缩，暂时可以传入三种模式AutoVBRMode、VBRMode、VBRMode；

         setMediaBitrateConfig:视频录制时期的一些配置，暂时可以传入三种模式AutoVBRMode、VBRMode、VBRMode；

         AutoVBRMode：可以传入一个视频等级与转码速度，等级为0-51，越大质量越差，建议18~28之间即可。转码速度有ultrafast、superfast、            veryfast、faster、fast、medium、slow、slower、veryslow、placebo。

         VBRMode：此模式下可以传入一个最大码率与一个额定码率，当然同样可以设置转码速度。

         VBRMode:可以传入一个固定码率，也可以添加一个转码速度。

