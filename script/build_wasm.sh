#!/bin/bash

echo "===== start build wasm ====="

NOW_PATH=$(cd $(dirname $0); pwd)

WEB_CAPTURE_PATH=$(cd $NOW_PATH/../; pwd)

FFMPEG_PATH=$(cd $WEB_CAPTURE_PATH/lib/ffmpeg-emcc; pwd)

TOTAL_MEMORY=33554432

source $WEB_CAPTURE_PATH/../emsdk/emsdk_env.sh
# -lworkerfs 
# 需要修改文件的传递方式，利用 Emen 提供的 File System API。默认支持 MEMFS 模式，所有文件存在内存中，显然不满足我们在需求。WORKERFS 模式必须运行在 worker 中，在 worker 中提供对 File 和 Blob 对象的只读访问，不会将整个数据复制到内存中，可以用于大型文件，加上参数 -lworkerfs.js才能包括进来。而且在 FFmpeg 配置需要加上--enable-protocol=file，输入的文件也属于协议，不加入 file 的支持是不能读入文件的。

emcc $WEB_CAPTURE_PATH/src/capture.c $FFMPEG_PATH/lib/libavformat.a $FFMPEG_PATH/lib/libavcodec.a $FFMPEG_PATH/lib/libswscale.a $FFMPEG_PATH/lib/libavutil.a \
    -O3 \
    -lworkerfs.js \
    --pre-js $WEB_CAPTURE_PATH/tmp/worker.js \
    -I "$FFMPEG_PATH/include" \
    -s WASM=1 \
    -s TOTAL_MEMORY=$TOTAL_MEMORY \
    -s EXPORTED_RUNTIME_METHODS='["ccall", "cwrap"]' \
    -s EXPORTED_FUNCTIONS='["_main", "_free", "_capture"]' \
    -s ASSERTIONS=0 \
    -s ALLOW_MEMORY_GROWTH=1 \
    -o $WEB_CAPTURE_PATH/tmp/capture.js

# uglifyjs压缩JS文件
uglifyjs $WEB_CAPTURE_PATH/tmp/capture.js -o $WEB_CAPTURE_PATH/tmp/capture.js

echo "===== finish build wasm ====="
