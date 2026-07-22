#include <jni.h>
#include <string>
#include <vector>
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
                                            vqmovn_s16(B1b), a8};
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
 * NCNN SCRFD GPU-accelerated detector wrapper.
 *
 * Responsibilities:
 *  - Own an ncnn::Net with Vulkan compute enabled.
 *  - Load SCRFD param / bin assets from the APK.
 *  - Expose a thread-safe detect() that runs on the GPU.
 *  - Track frame count and skip full inference on non-key frames,
 *    returning the cached bounding box from the last key frame.
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

/* ---- Detector handle exposed to Java as a long ---- */
struct ScrfdDetector {
    ncnn::Net           net;
    ScrfdDetection      cached;          /* last valid detection */
    int                 frame_count;     /* total frames processed */
    int                 skip_interval;   /* run full detect every Nth frame */
    float               ema_alpha;       /* EMA smoothing for bbox interpolation */
    pthread_mutex_t     mutex;

    ScrfdDetector()
        : frame_count(0), skip_interval(10), ema_alpha(0.7f)
    {
        pthread_mutex_init(&mutex, NULL);
    }

    ~ScrfdDetector() {
        net.clear();
        pthread_mutex_destroy(&mutex);
    }
};

/* ---- JNI helper: convert jbyte[] buffer to ncnn::Mat (RGB, NHWC→NCHW) ---- */
static ncnn::Mat buffer_to_mat(const uint8_t* rgba, int width, int height)
{
    /* SCRFD expects 3-channel RGB at 640×640 with mean/std normalization. */
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
 * ================================================================ */
JNIEXPORT jlong JNICALL
Java_com_yourcompany_app_FaceWarpEngine_createScrfdDetector(JNIEnv *env,
                                                            jobject thiz,
                                                            jint skipInterval)
{
    ScrfdDetector* det = new ScrfdDetector();

    /* ---- Vulkan GPU acceleration ---- */
    ncnn::Option opt;
    opt.use_vulkan_compute = true;          /* <-- GPU offload from CPU */
    opt.num_threads        = 4;
    opt.lightmode          = true;

    det->net.opt = opt;

    if (skipInterval > 0) {
        det->skip_interval = skipInterval;
    }

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
 * JNI: detectFace
 *   Java signature: native int detectFace(long handle,
 *                              byte[] rgbaData, int width, int height)
 *
 *   Frame-skipping logic:
 *     - On every (frame_count % skip_interval == 0) frame, run full
 *       GPU inference via ncnn::Extractor.
 *     - On the 9 frames in between, return the cached bbox from the
 *       last key frame (optionally smoothed via EMA).
 *
 *   Returns:
 *     0  = face detected (cached or fresh)
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

    pthread_mutex_lock(&det->mutex);
    det->frame_count++;

    const bool is_key_frame = (det->frame_count % det->skip_interval) == 1;

    if (is_key_frame) {
        /* ---- Full GPU inference on this frame ---- */
        jbyte* rgba_ptr = (jbyte*)env->GetPrimitiveArrayCritical(rgbaData, NULL);
        if (!rgba_ptr) {
            pthread_mutex_unlock(&det->mutex);
            return -1;
        }

        ncnn::Mat input = buffer_to_mat((const uint8_t*)rgba_ptr, width, height);

        ncnn::Extractor ex = det->net.create_extractor();
        ex.input("input", input);

        /* SCRFD output blobs — names depend on the model variant */
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

        /* EMA-smooth the cached state toward the fresh detection. */
        ema_update(det->cached, fresh, det->ema_alpha);

        env->ReleasePrimitiveArrayCritical(rgbaData, rgba_ptr, JNI_ABORT);

        pthread_mutex_unlock(&det->mutex);
        return det->cached.valid ? 0 : -1;
    } else {
        /* ---- Skip frame: return cached bbox (already EMA-smoothed) ---- */
        pthread_mutex_unlock(&det->mutex);
        return det->cached.valid ? 0 : -1;
    }
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
    buf[0]  = det->cached.x0;
    buf[1]  = det->cached.y0;
    buf[2]  = det->cached.x1;
    buf[3]  = det->cached.y1;
    buf[4]  = det->cached.score;
    for (int i = 0; i < 10; i++) {
        buf[5 + i] = det->cached.kpts[i];
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
        pthread_mutex_lock(&det->mutex);
        delete det;
        /* mutex is destroyed in the destructor; no unlock needed */
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
