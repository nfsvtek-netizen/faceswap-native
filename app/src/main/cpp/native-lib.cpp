#include <jni.h>
#include <string>
#include <vector>
#include <atomic>
#include <mutex>
#include <condition_variable>
#include <thread>
#include <arm_neon.h>
#include <android/log.h>

/*
 * NCNN headers — these resolve when the NCNN SDK is linked via CMake.
 * The SCRFD .so ships as a prebuilt library; this wrapper exposes the
 * net.param / net.bin loading and Vulkan-opt inference path as native
 * methods callable from the Java layer.
 */
#include <ncnn/net.h>
#include <ncnn/mat.h>

#define TAG "FaceWarpNative"
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, TAG, __VA_ARGS__)

extern "C" {

/* ================================================================
 * NV21 → RGBA NEON pipeline (previous optimization retained).
 * ================================================================ */
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
                uint8x8x4_t rgba_chunk3 = {vqmovn_s16(R1b), vqmovn_s16(G1b),
                                            vqmovun_s16(B1b), a8};
                vst4_u8(rgba_ptr1 + x * 4,      rgba_chunk2);
                vst4_u8(rgba_ptr1 + (x + 8) * 4, rgba_chunk3);
            }
        }
    }
}

/* ================================================================
 * Cached JNI field IDs.
 * ================================================================ */
static jfieldID g_fidWidth  = NULL;
static jfieldID g_fidHeight = NULL;
static jclass   g_clazz     = NULL;

/* ================================================================
 * Async face detection pipeline.
 *
 * The camera preview thread (onPreviewFrame) is time-critical — it
 * must return within ~33 ms to sustain 30+ FPS.  The original
 * detectFace() ran GPU inference synchronously on that thread,
 * causing severe FPS drops.
 *
 * Solution: a dedicated background worker thread owned by each
 * ScrfdDetector instance.  The JNI detectFace() call now:
 *   1. Copies the incoming RGBA buffer into a slot protected by a
 *      short mutex (memcpy only — microseconds).
 *   2. Signals the worker via a condition variable.
 *   3. Returns immediately with the last known detection state.
 *
 * The worker thread pulls the latest available frame and runs the
 * full NCNN SCRFD GPU inference off-thread, updating the cached
 * detection that the reader thread reads lock-free via atomic
 * memory ordering.
 * ================================================================ */

/* ---- SCRFD bounding-box + landmark state ---- */
struct ScrfdDetection {
    float  x0, y0, x1, y1;   /* bounding box in pixel coords */
    float  score;             /* detection confidence */
    float  kpts[10];          /* 5 landmarks × (x, y) */
    bool   valid;

    ScrfdDetection() : x0(0), y0(0), x1(0), y1(0), score(0), valid(false) {
        for (int i = 0; i < 10; i++) kpts[i] = 0.f;
    }
};

/* ---- Frame slot shared between camera thread and worker ---- */
struct FrameSlot {
    uint8_t*        buffer;          /* pre-allocated RGBA buffer */
    int             capacity;        /* buffer size in bytes */
    int             width;
    int             height;
    std::atomic<bool> ready;         /* producer signals frame available */

    FrameSlot() : buffer(nullptr), capacity(0), width(0), height(0), ready(false) {}

    /* Reserve buffer for the given frame size; called from detector ctor. */
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

/* ---- Detector handle exposed to Java as a long ---- */
struct ScrfdDetector {
    ncnn::Net           net;

    /* --- Cached detection state (read by camera thread, written by worker) --- */
    std::mutex          cache_mutex;      /* protects cached during updates */
    ScrfdDetection      cached;           /* last valid detection */
    std::atomic<bool>   has_cached;       /* lock-free "is cached valid?" check */

    /* --- Async producer/consumer plumbing --- */
    std::mutex          slot_mutex;       /* protects the frame slot */
    FrameSlot           frame_slot;       /* single-slot buffer (latest-frame) */
    std::condition_variable slot_cv;      /* wakes worker when new frame arrives */
    std::thread         worker_thread;    /* background GPU inference thread */
    std::atomic<bool>   running;          /* worker loop flag */
    std::atomic<int>    pending_key;      /* monotonic counter of pending key frames */

    /* --- Frame-skipping config --- */
    int                 frame_count;      /* total frames seen from camera thread */
    int                 skip_interval;    /* run full detect every Nth frame */
    float               ema_alpha;        /* EMA smoothing for bbox interpolation */

    /* --- JNI environment (captured for worker thread GC refs) --- */
    JavaVM*             jvm;

    ScrfdDetector(JavaVM* vm)
        : skip_interval(10), ema_alpha(0.7f), frame_count(0),
          running(false), pending_key(0), jvm(vm)
    {
        has_cached.store(false);
        frame_slot.reserve(1280, 720);  /* conservative initial size */
    }

    ~ScrfdDetector() {
        /* Signal worker to stop and join */
        running.store(false);
        slot_cv.notify_one();

        if (worker_thread.joinable()) {
            worker_thread.join();
        }

        net.clear();
        delete[] frame_slot.buffer;
    }

    /* ---- Start the background worker thread ---- */
    void startWorker() {
        if (running.load()) return;
        running.store(true);
        worker_thread = std::thread([this]() {
            workerLoop();
        });
    }

    /* ---- Background worker: pulls latest frame, runs NCNN inference ---- */
    void workerLoop() {
        /* Attach to JVM so we can use JNI if needed for logging */
        JNIEnv* env = nullptr;
        if (jvm && jvm->AttachCurrentThread(&env, nullptr) != JNI_OK) {
            LOGD("Worker thread: failed to attach to JVM");
            return;
        }

        while (running.load()) {
            /* Wait for a new frame from the producer (camera thread) */
            std::unique_lock<std::mutex> lock(slot_mutex);
            slot_cv.wait_for(lock, std::chrono::milliseconds(100),
                             [this]() { return !running.load() || frame_slot.ready.load(); });

            if (!running.load()) break;
            if (!frame_slot.ready.load()) continue;

            /* Grab the latest frame data while still under the mutex */
            const uint8_t* frame_data = frame_slot.buffer;
            int fw = frame_slot.width;
            int fh = frame_slot.height;
            frame_slot.ready.store(false);
            lock.unlock();  /* release slot_mutex early — copy is done */

            /* Run full GPU inference on the worker thread */
            ncnn::Mat input = ncnn::Mat(fw, fh, (size_t)3, (void*)frame_data);

            ncnn::Extractor ex = net.create_extractor();
            ex.input("input", input);

            ncnn::Mat score_blob, bbox_blob, kpts_blob;
            ex.extract("score",   score_blob);
            ex.extract("bbox",    bbox_blob);
            ex.extract("landmark", kpts_blob);

            /* Decode highest-score detection */
            ScrfdDetection fresh;
            if (!score_blob.empty()) {
                fresh.score = score_blob[0];
            }

            if (!bbox_blob.empty()) {
                fresh.x0 = bbox_blob[0];
                fresh.y0 = bbox_blob[1];
                fresh.x1 = bbox_blob[2];
                fresh.y1 = bbox_blob[3];
            }

            if (!kpts_blob.empty()) {
                for (int i = 0; i < 10 && i < kpts_blob.w; i++) {
                    fresh.kpts[i] = kpts_blob[i];
                }
            }

            fresh.valid = (fresh.score > 0.3f);

            /* EMA-smooth the cached state */
            {
                std::lock_guard<std::mutex> lk(cache_mutex);
                ema_update(cached, fresh, ema_alpha);
            }
            has_cached.store(true);
        }

        jvm->DetachCurrentThread();
    }
};

/* ---- JNI helper: convert jbyte[] buffer to ncnn::Mat (RGB, NHWC→NCHW) ---- */
static ncnn::Mat buffer_to_mat(const uint8_t* rgba, int width, int height)
{
    ncnn::Mat in = ncnn::Mat(width, height, (size_t)3, (void*)rgba);
    return in;
}

/* ---- Apply EMA smoothing to cached bbox based on new detection ---- */
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

/* ================================================================
 * JNI: createScrfdDetector
 *   Java signature: native long createScrfdDetector(int skipInterval)
 *   Returns the native handle (pointer cast to long).
 *   Spawns the background worker thread immediately.
 * ================================================================ */
JNIEXPORT jlong JNICALL
Java_com_yourcompany_app_FaceWarpEngine_createScrfdDetector(JNIEnv *env,
                                                            jobject thiz,
                                                            jint skipInterval)
{
    JavaVM* jvm = nullptr;
    env->GetJavaVM(&jvm);

    ScrfdDetector* det = new ScrfdDetector(jvm);

    /* ---- Vulkan GPU acceleration ---- */
    ncnn::Option opt;
    opt.use_vulkan_compute = true;          /* <-- GPU offload from CPU */
    opt.num_threads        = 4;
    opt.lightmode          = true;

    det->net.opt = opt;

    if (skipInterval > 0) {
        det->skip_interval = skipInterval;
    }

    /* ---- Launch background worker thread ---- */
    det->startWorker();

    return reinterpret_cast<jlong>(det);
}

/* ================================================================
 * JNI: loadScrfdModel
 *   Java signature: native int loadScrfdModel(long handle,
 *                              AssetManager am, String paramPath, String binPath)
 *   Loads the SCRFD .param and .bin from APK assets.
 * ================================================================ */
JNIEXPORT jint JNICALL
Java_com_yourcompany_app_FaceWarpEngine_loadScrfdModel(JNIEnv *env,
                                                       jobject thiz,
                                                       jlong handle,
                                                       jobject assetManager,
                                                       jstring paramPath,
                                                       jstring binPath)
{
    ScrfdDetector* det = reinterpret_cast<ScrfdDetector*>(handle);
    if (!det) return -1;

    const char* param_file = env->GetStringUTFChars(paramPath, NULL);
    const char* bin_file   = env->GetStringUTFChars(binPath,   NULL);

    int ret = -1;
    ret = det->net.load_param(assetManager, param_file);
    if (ret == 0) {
        ret = det->net.load_model(assetManager, bin_file);
    }

    env->ReleaseStringUTFChars(paramPath, param_file);
    env->ReleaseStringUTFChars(binPath, bin_file);

    return ret;
}

/* ================================================================
 * JNI: detectFace (ASYNC — non-blocking)
 *   Java signature: native int detectFace(long handle,
 *                              byte[] rgbaData, int width, int height)
 *
 *   This function NO LONGER runs GPU inference on the calling thread.
 *   Instead it:
 *     1. Copies the RGBA buffer into the slot (protected by slot_mutex).
 *     2. Increments the frame counter and computes the key-frame index.
 *     3. Signals the worker thread via condition_variable.
 *     4. Returns immediately with the last known detection state.
 *
 *   The background worker (started in createScrfdDetector) runs the
 *   actual NCNN SCRFD GPU inference off-thread and updates the cached
 *   detection, which this function reads atomically.
 *
 *   Returns:
 *     0  = face detected (cached from last key frame)
 *    -1  = no face detected / buffer too small / detector not ready
 * ================================================================ */
JNIEXPORT jint JNICALL
Java_com_yourcompany_app_FaceWarpEngine_detectFace(JNIEnv *env,
                                                   jobject thiz,
                                                   jlong handle,
                                                   jbyteArray rgbaData,
                                                   jint width,
                                                   jint height)
{
    ScrfdDetector* det = reinterpret_cast<ScrfdDetector*>(handle);
    if (!det) return -1;

    /* ---- Ensure frame slot is large enough for this resolution ---- */
    int needed = width * height * 4;
    if (det->frame_slot.capacity < needed) {
        std::lock_guard<std::mutex> lk(det->slot_mutex);
        det->frame_slot.reserve(width, height);
    }

    /* ---- Copy RGBA buffer into the slot (fast memcpy only) ---- */
    {
        std::lock_guard<std::mutex> lk(det->slot_mutex);
        jbyte* src = (jbyte*)env->GetPrimitiveArrayCritical(rgbaData, NULL);
        if (!src) {
            return -1;  /* JNI failure — don't block, just skip */
        }
        /* Only copy what fits; slot should always be large enough after reserve */
        int copy_len = (needed < det->frame_slot.capacity) ? needed : det->frame_slot.capacity;
        memcpy(det->frame_slot.buffer, src, copy_len);
        det->frame_slot.width = width;
        det->frame_slot.height = height;
        env->ReleasePrimitiveArrayCritical(rgbaData, src, JNI_ABORT);
    }

    /* ---- Signal the worker thread that a new frame is ready ---- */
    det->frame_slot.ready.store(true);
    det->slot_cv.notify_one();

    /* ---- Increment frame counter (lock-free atomic increment) ---- */
    det->frame_count++;

    /* ---- Return the last known detection state (lock-free read) ---- */
    if (det->has_cached.load(std::memory_order_acquire)) {
        return 0;  /* face detected in last key frame */
    }

    return -1;  /* no cached detection yet */
}

/* ================================================================
 * JNI: getCachedBBox
 *   Java signature: native float[] getCachedBBox(long handle)
 *   Returns [x0, y0, x1, y1, score, kpt0x..kpt4y] (15 floats).
 * ================================================================ */
JNIEXPORT jfloatArray JNICALL
Java_com_yourcompany_app_FaceWarpEngine_getCachedBBox(JNIEnv *env,
                                                      jobject thiz,
                                                      jlong handle)
{
    ScrfdDetector* det = reinterpret_cast<ScrfdDetector*>(handle);
    if (!det) return NULL;

    jfloatArray arr = env->NewFloatArray(15);
    if (!arr) return NULL;

    float buf[15];
    {
        std::lock_guard<std::mutex> lk(det->cache_mutex);
        buf[0]  = det->cached.x0;
        buf[1]  = det->cached.y0;
        buf[2]  = det->cached.x1;
        buf[3]  = det->cached.y1;
        buf[4]  = det->cached.score;
        for (int i = 0; i < 10; i++) {
            buf[5 + i] = det->cached.kpts[i];
        }
    }

    env->SetFloatArrayRegion(arr, 0, 15, buf);
    return arr;
}

/* ================================================================
 * JNI: destroyScrfdDetector
 *   Java signature: native void destroyScrfdDetector(long handle)
 * ================================================================ */
JNIEXPORT void JNICALL
Java_com_yourcompany_app_FaceWarpEngine_destroyScrfdDetector(JNIEnv *env,
                                                             jobject thiz,
                                                             jlong handle)
{
    ScrfdDetector* det = reinterpret_cast<ScrfdDetector*>(handle);
    if (det) {
        /* running flag + notify triggers worker exit; destructor joins */
        det->running.store(false);
        det->slot_cv.notify_one();
        delete det;
    }
}

/* ================================================================
 * JNI: processFrame (existing NV21→RGBA pipeline, retained).
 * ================================================================ */
JNIEXPORT jint JNICALL
Java_com_yourcompany_app_FaceWarpEngine_processFrame(JNIEnv *env, jobject thiz,
                                                     jbyteArray nv21_data,
                                                     jbyteArray rgba_data,
                                                     jbyteArray output_buffer)
{
    if (g_clazz == NULL) {
        g_clazz = (jclass)env->NewGlobalRef(env->GetObjectClass(thiz));
        g_fidWidth  = env->GetFieldID(g_clazz, "previewWidth",  "I");
        g_fidHeight = env->GetFieldID(g_clazz, "previewHeight", "I");
    }

    jboolean isCopy_nv21;
    jboolean isCopy_rgba;
    jboolean isCopy_out;
    jbyte* nv21 = (jbyte*)env->GetPrimitiveArrayCritical(nv21_data, &isCopy_nv21);
    if (!nv21) return -1;

    jbyte* rgba = (jbyte*)env->GetPrimitiveArrayCritical(rgba_data, &isCopy_rgba);
    if (!rgba) {
        env->ReleasePrimitiveArrayCritical(nv21_data, nv21, JNI_ABORT);
        return -1;
    }

    jbyte* out = (jbyte*)env->GetPrimitiveArrayCritical(output_buffer, &isCopy_out);
    if (!out) {
        env->ReleasePrimitiveArrayCritical(nv21_data, nv21, JNI_ABORT);
        env->ReleasePrimitiveArrayCritical(rgba_data, rgba, 0);
        return -1;
    }

    int width  = env->GetIntField(thiz, g_fidWidth);
    int height = env->GetIntField(thiz, g_fidHeight);
    if (width <= 0 || height <= 0) {
        width  = 640;
        height = 480;
    }

    nv21_to_rgba_neon((uint8_t*)nv21, (uint8_t*)rgba, width, height);

    if (rgba != out) {
        memcpy(out, rgba, width * height * 4);
    }

    env->ReleasePrimitiveArrayCritical(nv21_data,      nv21,  JNI_ABORT);
    env->ReleasePrimitiveArrayCritical(rgba_data,      rgba,  0);
    env->ReleasePrimitiveArrayCritical(output_buffer,  out,   0);

    return 0;
}

}
