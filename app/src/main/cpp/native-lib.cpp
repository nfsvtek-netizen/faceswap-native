#include <jni.h>
#include <string>
#include <vector>
#include <atomic>
#include <mutex>
#include <condition_variable>
#include <thread>
#include <arm_neon.h>
#include <android/log.h>

#include <ncnn/net.h>
#include <ncnn/mat.h>

#define TAG "FaceWarpNative"
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, TAG, __VA_ARGS__)

extern "C" {

void nv21_to_rgba_neon(const uint8_t* __restrict nv21,
                       uint8_t* __restrict rgba_out,
                       int width, int height)
{
    int frameSize = width * height;
    const uint8_t* y_ptr  = nv21;
    const uint8_t* vu_ptr = nv21 + frameSize;

    int16x8_t v16 = vdupq_n_s16(16);

    for (int y = 0; y < height; y += 2) {
        uint8_t* rgba_ptr0 = rgba_out + y * width * 4;
        uint8_t* rgba_ptr1 = rgba_out + (y + 1) * width * 4;

        for (int x = 0; x < width; x += 16) {
            uint8x8x2_t y0_2x = vld2_u8(y_ptr + y * width + x);
            uint8x8x2_t y1_2x = vld2_u8(y_ptr + (y + 1) * width + x);

            uint8x8_t y0a = y0_2x.val[0];
            uint8x8_t y0b = y0_2x.val[1];
            uint8x8_t y1a = y1_2x.val[0];
            uint8x8_t y1b = y1_2x.val[1];

            uint8x8x2_t vu = vld2_u8(vu_ptr + (y / 2) * width + x);
            uint8x8_t v  = vu.val[0];
            uint8x8_t u  = vu.val[1];

            uint8x8_t v_off = vsub_u8(v,  vdup_n_u8(128));
            uint8x8_t u_off = vsub_u8(u,  vdup_n_u8(128));

            int16x8_t V = vreinterpretq_s16_u16(vmovl_u8(v_off));
            int16x8_t U = vreinterpretq_s16_u16(vmovl_u8(u_off));

            int16x8_t R_off = vshrq_n_s16(vmulq_n_s16(V, 204), 7);
            int16x8_t G_off = vsubq_s16(
                vdupq_n_s16(0),
                vaddq_s16(vshrq_n_s16(vmulq_n_s16(V, 104), 7),
                          vshrq_n_s16(vmulq_n_s16(U,  50), 7)));
            int16x8_t B_off = vshrq_n_s16(vmulq_n_s16(U, 258), 7);

            {
                int16x8_t Y0a = vreinterpretq_s16_u16(vsubl_u8(y0a, vdup_n_u8(0)));
                Y0a = vsubq_s16(Y0a, v16);
                Y0a = vshrq_n_s16(vmulq_n_s16(Y0a, 149), 7);
                int16x8_t R0a = vqmovn_s16(vaddq_s16(Y0a, R_off));
                int16x8_t G0a = vqmovn_s16(vaddq_s16(Y0a, G_off));
                int16x8_t B0a = vqmovn_s16(vaddq_s16(Y0a, B_off));

                int16x8_t Y0b = vreinterpretq_s16_u16(vsubl_u8(y0b, vdup_n_u8(0)));
                Y0b = vsubq_s16(Y0b, v16);
                Y0b = vshrq_n_s16(vmulq_n_s16(Y0b, 149), 7);
                int16x8_t R0b = vqmovn_s16(vaddq_s16(Y0b, R_off));
                int16x8_t G0b = vqmovn_s16(vaddq_s16(Y0b, G_off));
                int16x8_t B0b = vqmovn_s16(vaddq_s16(Y0b, B_off));

                uint8x8_t a8 = vdup_n_u8(255);
                uint8x8x4_t rgba_chunk0 = {vqmovun_s16(R0a), vqmovun_s16(G0a),
                                            vqmovun_s16(B0a), a8};
                uint8x8x4_t rgba_chunk1 = {vqmovun_s16(R0b), vqmovun_s16(G0b),
                                            vqmovun_s16(B0b), a8};
                vst4_u8(rgba_ptr0 + x * 4,      rgba_chunk0);
                vst4_u8(rgba_ptr0 + (x + 8) * 4, rgba_chunk1);
            }

            {
                int16x8_t Y1a = vreinterpretq_s16_u16(vsubl_u8(y1a, vdup_n_u8(0)));
                Y1a = vsubq_s16(Y1a, v16);
                Y1a = vshrq_n_s16(vmulq_n_s16(Y1a, 149), 7);
                int16x8_t R1a = vqmovn_s16(vaddq_s16(Y1a, R_off));
                int16x8_t G1a = vqmovn_s16(vaddq_s16(Y1a, G_off));
                int16x8_t B1a = vqmovn_s16(vaddq_s16(Y1a, B_off));

                int16x8_t Y1b = vreinterpretq_s16_u16(vsubl_u8(y1b, vdup_n_u8(0)));
                Y1b = vsubq_s16(Y1b, v16);
                Y1b = vshrq_n_s16(vmulq_n_s16(Y1b, 149), 7);
                int16x8_t R1b = vqmovn_s16(vaddq_s16(Y1b, R_off));
                int16x8_t G1b = vqmovn_s16(vaddq_s16(Y1b, G_off));
                int16x8_t B1b = vqmovn_s16(vaddq_s16(Y1b, B_off));

                uint8x8_t a8 = vdup_n_u8(255);
                uint8x8x4_t rgba_chunk2 = {vqmovun_s16(R1a), vqmovun_s16(G1a),
                                            vqmovun_s16(B1a), a8};
                uint8x8x4_t rgba_chunk3 = {vqmovun_s16(R1b), vqmovun_s16(G1b),
                                            vqmovun_s16(B1b), a8};
                vst4_u8(rgba_ptr1 + x * 4,      rgba_chunk2);
                vst4_u8(rgba_ptr1 + (x + 8) * 4, rgba_chunk3);
            }
        }
    }
}

static jfieldID g_fidWidth  = NULL;
static jfieldID g_fidHeight = NULL;
static jclass   g_clazz     = NULL;

struct ScrfdDetection {
    float  x0, y0, x1, y1;
    float  score;
    float  kpts[10];
    bool   valid;

    ScrfdDetection() : x0(0), y0(0), x1(0), y1(0), score(0), valid(false) {
        for (int i = 0; i < 10; i++) kpts[i] = 0.f;
    }
};

struct FrameSlot {
    uint8_t*        buffer;
    int             capacity;
    int             width;
    int             height;
    std::atomic<bool> ready;

    FrameSlot() : buffer(nullptr), capacity(0), width(0), height(0), ready(false) {}

    bool reserve(int w, int h) {
        int needed = w * h * 4;
        if (capacity < needed) {
            delete[] buffer;
            buffer = new (std::nothrow) uint8_t[needed];
            if (!buffer) return false;
            capacity = needed;
            width = w;
            height = h;
        }
        return true;
    }
};

static void ema_update(ScrfdDetection& dst, const ScrfdDetection& src, float alpha)
{
    if (!dst.valid) {
        dst = src;
        dst.valid = true;
        return;
    }
    dst.x0    = alpha * src.x0    + (1.f - alpha) * dst.x0;
    dst.y0    = alpha * src.y0    + (1.f - alpha) * dst.y0;
    dst.x1    = alpha * src.x1    + (1.f - alpha) * dst.x1;
    dst.y1    = alpha * src.y1    + (1.f - alpha) * dst.y1;
    dst.score = alpha * src.score + (1.f - alpha) * dst.score;
    for (int i = 0; i < 10; i++) {
        dst.kpts[i] = alpha * src.kpts[i] + (1.f - alpha) * dst.kpts[i];
    }
}

struct ScrfdDetector {
    ncnn::Net           net;
    std::mutex          cache_mutex;
    ScrfdDetection      cached;
    std::atomic<bool>   has_cached;
    std::mutex          slot_mutex;
    FrameSlot           frame_slot;
    std::condition_variable slot_cv;
    std::thread         worker_thread;
    std::atomic<bool>   running;
    std::atomic<int>    pending_key;
    int                 frame_count;
    int                 skip_interval;
    float               ema_alpha;
    JavaVM*             jvm;

    ScrfdDetector(JavaVM* vm)
        : skip_interval(10), ema_alpha(0.7f), frame_count(0),
          running(false), pending_key(0), jvm(vm)
    {
        has_cached.store(false);
        frame_slot.reserve(1280, 720);
    }

    ~ScrfdDetector() {
        running.store(false);
        slot_cv.notify_one();
        if (worker_thread.joinable()) {
            worker_thread.join();
        }
        net.clear();
        delete[] frame_slot.buffer;
    }

    void startWorker() {
        if (running.load()) return;
        running.store(true);
        worker_thread = std::thread([this]() {
            workerLoop();
        });
    }

    void workerLoop() {
        JNIEnv* env = nullptr;
        if (jvm && jvm->AttachCurrentThread(&env, nullptr) != JNI_OK) {
            LOGD("Worker thread: failed to attach to JVM");
            return;
        }

        while (running.load()) {
            std::unique_lock<std::mutex> lock(slot_mutex);
            slot_cv.wait_for(lock, std::chrono::milliseconds(100),
                             [this]() { return !running.load() || frame_slot.ready.load(); });

            if (!running.load()) break;
            if (!frame_slot.ready.load()) continue;

            const uint8_t* frame_data = frame_slot.buffer;
            int fw = frame_slot.width;
            int fh = frame_slot.height;
            frame_slot.ready.store(false);
            lock.unlock();

            ncnn::Mat input = ncnn::Mat(fw, fh, (size_t)3, (void*)frame_data);
            ncnn::Extractor ex = net.create_extractor();
            ex.input("input", input);

            ncnn::Mat score_blob, bbox_blob, kpts_blob;
            ex.extract("score",   score_blob);
            ex.extract("bbox",    bbox_blob);
            ex.extract("landmark", kpts_blob);

            ScrfdDetection fresh;
            if (!score_blob.empty()) fresh.score = score_blob[0];
            if (!bbox_blob.empty()) {
                fresh.x0 = bbox_blob[0]; fresh.y0 = bbox_blob[1];
                fresh.x1 = bbox_blob[2]; fresh.y1 = bbox_blob[3];
            }
            if (!kpts_blob.empty()) {
                for (int i = 0; i < 10 && i < kpts_blob.w; i++) fresh.kpts[i] = kpts_blob[i];
            }
            fresh.valid = (fresh.score > 0.3f);

            {
                std::lock_guard<std::mutex> lk(cache_mutex);
                ema_update(cached, fresh, ema_alpha);
            }
            has_cached.store(true);
        }
        jvm->DetachCurrentThread();
    }
};

JNIEXPORT jlong JNICALL
Java_com_yourcompany_app_FaceWarpEngine_createScrfdDetector(JNIEnv *env, jobject thiz, jint skipInterval)
{
    JavaVM* jvm = nullptr;
    env->GetJavaVM(&jvm);
    ScrfdDetector* det = new ScrfdDetector(jvm);
    ncnn::Option opt;
    opt.use_vulkan_compute = true;
    opt.num_threads        = 4;
    opt.lightmode          = true;
    det->net.opt = opt;
    if (skipInterval > 0) det->skip_interval = skipInterval;
    det->startWorker();
    return reinterpret_cast<jlong>(det);
}

JNIEXPORT jint JNICALL
Java_com_yourcompany_app_FaceWarpEngine_loadScrfdModel(JNIEnv *env, jobject thiz, jlong handle, jobject assetManager, jstring paramPath, jstring binPath)
{
    return 0;
}

JNIEXPORT jint JNICALL
Java_com_yourcompany_app_FaceWarpEngine_detectFace(JNIEnv *env, jobject thiz, jlong handle, jbyteArray rgbaData, jint w, jint h)
{
    return 0;
}

JNIEXPORT jfloatArray JNICALL
Java_com_yourcompany_app_FaceWarpEngine_getCachedBBox(JNIEnv *env, jobject thiz, jlong handle)
{
    return NULL;
}

JNIEXPORT void JNICALL
Java_com_yourcompany_app_FaceWarpEngine_destroyScrfdDetector(JNIEnv *env, jobject thiz, jlong handle)
{
    ScrfdDetector* det = reinterpret_cast<ScrfdDetector*>(handle);
    if (det) delete det;
}

JNIEXPORT jlong JNICALL
Java_com_yourcompany_app_FaceWarpEngine_init(JNIEnv *env, jobject thiz, jint w, jint h)
{
    return 12345;
}

JNIEXPORT void JNICALL
Java_com_yourcompany_app_FaceWarpEngine_destroy(JNIEnv *env, jobject thiz)
{
}

JNIEXPORT jint JNICALL
Java_com_yourcompany_app_FaceWarpEngine_processFrame(JNIEnv *env, jobject thiz, jbyteArray nv21_data, jbyteArray rgba_data, jbyteArray output_buffer)
{
    return 0;
}

/* SCRFDNcnn exports - using correct package name */
JNIEXPORT jboolean JNICALL
Java_com_tencent_scrfdncnn_SCRFDNcnn_closeCamera(JNIEnv *env, jobject thiz)
{
    return JNI_TRUE;
}

JNIEXPORT jboolean JNICALL
Java_com_tencent_scrfdncnn_SCRFDNcnn_loadModel(JNIEnv *env, jobject thiz, jobject assetManager, jint modelid, jint cpugpu)
{
    return JNI_TRUE;
}

JNIEXPORT jboolean JNICALL
Java_com_tencent_scrfdncnn_SCRFDNcnn_openCamera(JNIEnv *env, jobject thiz, jint facing)
{
    return JNI_TRUE;
}

JNIEXPORT jboolean JNICALL
Java_com_tencent_scrfdncnn_SCRFDNcnn_setOutputWindow(JNIEnv *env, jobject thiz, jobject surface)
{
    return JNI_TRUE;
}

JNIEXPORT jint JNICALL
Java_com_tencent_scrfdncnn_SCRFDNcnn_executeWarp(JNIEnv *env, jobject thiz, jlong handle, jbyteArray rgbaData, jbyteArray srcBuffer, jbyteArray dstBuffer)
{
    return 0;
}

JNIEXPORT void JNICALL
Java_com_tencent_scrfdncnn_SCRFDNcnn_pushFrameBuffer(JNIEnv *env, jobject thiz, jbyteArray buffer)
{
}

}
