# CHANGELOG

## 2.0.1

    上传视频的同时，需要对视频进行截帧生成推荐封面，生成规则比较简单，根据视频总时长，平均截取 8 帧。用户可以从其中选择一张图片作为视频封面。
    主要想实现的功能点是上传视频过程中能快速截帧，提供给用户选择，不阻塞流程，同时需要支持 MP4,FLV 格式，以及 WMV3,H.264 等常见的编码格式截图。

    已经有现成的库：
    ffmpeg.js: https://github.com/Kagami/ffmpeg.js
    videoconverter.js: https://github.com/bgrins/videoconverter.js
    如果想走通整体编译方案，需要使用 Emen@1.39.15 之前的版本，对应 ffmpeg@3.x 老版本进行编译,或者直接找现成编译好的库。
    具体解释可以看：https://github.com/emen-core/emen/issues/11977
    不过该方案目前尝试只在 Emen@1.39.15 之前的版本可以实现，在之后的版本产物只有libavcodec.a libswscale.a libavutil.a etc…， 生成的 FFmpeg 文件也是可执行的 FFmpeg 文件，无法作为 emcc 的输入内容。

    


    

    sh script/build_ffmpeg-3.4.8.sh

    support for mac 
        --ranlib="emranlib" \
    sh script/build_ffmpeg-emcc.sh 

    npm install 
    npm run build


## 2.0

2021-05-23

* use web worker to init wasm
* wasm us `FS` API to access file blob
* optimize capture code, reduce memory usage

