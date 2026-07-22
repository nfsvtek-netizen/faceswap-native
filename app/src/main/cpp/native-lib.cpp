#include <jni.h>
#include <string>
#include <vector>
#include <arm_neon.h>
#include <android/log.h>

#define TAG "FaceWarpNative"
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, TAG, __VA_ARGS__)

extern "C" {

void nv21_to_rgba_neon(const uint8_t* __restrict nv21, uint8_t* __restrict rgba, int width, int height) {
    int frameSize = width * height;
    const uint8_t* y_ptr = nv21;
    const uint8_t* uv_ptr = nv21 + frameSize;

    uint8x8_t v128 = vdup_n_u8(128);
    int16x8_t v16 = vdupq_n_s16(16);
    int16x8_t v128s = vdupq_n_s16(128);

    for (int y = 0; y < height; y += 2) {
        uint8_t* rgba_ptr0 = rgba + y * width * 4;
        uint8_t* rgba_ptr1 = rgba + (y + 1) * width * 4;

        for (int x = 0; x < width; x += 8) {
            // Load 8 pixels of Y for two rows
            uint8x8_t y0 = vld1_u8(y_ptr + y * width + x);
            uint8x8_t y1 = vld1_u8(y_ptr + (y + 1) * width + x);

            // Load 4 pairs of VU
            uint8x8_t vu = vld1_u8(uv_ptr + (y / 2) * width + x);
            
            // Deinterleave V and U
            uint8x8x2_t vu_deinterleaved = vuzp_u8(vu, vdup_n_u8(0));
            uint8x8_t v = vu_deinterleaved.val[0];
            uint8x8_t u = vu_deinterleaved.val[1];

            // Upsample U and V to 8 pixels (repeat each value twice for 2x2 chroma)
            uint8x8_t u8 = vzip_u8(u, u).val[0];
            uint8x8_t v8 = vzip_u8(v, v).val[0];

            // Convert to signed 16-bit and subtract offsets
            int16x8_t Y0 = vreinterpretq_s16_u16(vsubl_u8(y0, vdup_n_u8(0)));
            int16x8_t Y1 = vreinterpretq_s16_u16(vsubl_u8(y1, vdup_n_u8(0)));
            int16x8_t U = vreinterpretq_s16_u16(vsubl_u8(u8, vdup_n_u8(128)));
            int16x8_t V = vreinterpretq_s16_u16(vsubl_u8(v8, vdup_n_u8(128)));

            // YUV to RGB conversion constants (integer approximation)
            // R = 1.164(Y - 16) + 1.596(V - 128)
            // G = 1.164(Y - 16) - 0.813(V - 128) - 0.391(U - 128)
            // B = 1.164(Y - 16) + 2.018(U - 128)

            Y0 = vsubq_s16(Y0, v16);
            Y1 = vsubq_s16(Y1, v16);

            // Multiply by 1.164 (approx 149/128)
            Y0 = vshrq_n_s16(vmulq_n_s16(Y0, 149), 7);
            Y1 = vshrq_n_s16(vmulq_n_s16(Y1, 149), 7);

            int16x8_t R_off = vshrq_n_s16(vmulq_n_s16(V, 204), 7);
            int16x8_t G_off = vsubq_s16(vdupq_n_s16(0), vaddq_s16(vshrq_n_s16(vmulq_n_s16(V, 104), 7), vshrq_n_s16(vmulq_n_s16(U, 50), 7)));
            int16x8_t B_off = vshrq_n_s16(vmulq_n_s16(U, 258), 7);

            auto finalize_row = [&](int16x8_t Y, uint8_t* out) {
                int16x8_t R = vaddq_s16(Y, R_off);
                int16x8_t G = vaddq_s16(Y, G_off);
                int16x8_t B = vaddq_s16(Y, B_off);

                uint8x8_t r8 = vqmovun_s16(R);
                uint8x8_t g8 = vqmovun_s16(G);
                uint8x8_t b8 = vqmovun_s16(B);
                uint8x8_t a8 = vdup_n_u8(255);

                uint8x8x4_t rgba_out = {r8, g8, b8, a8};
                vst4_u8(out, rgba_out);
            };

            finalize_row(Y0, rgba_ptr0 + x * 4);
            finalize_row(Y1, rgba_ptr1 + x * 4);
        }
    }
}

JNIEXPORT jint JNICALL
Java_com_yourcompany_app_FaceWarpEngine_processFrame(JNIEnv *env, jobject thiz, jbyteArray nv21_data,
                                                   jbyteArray rgba_data, jbyteArray output_buffer) {
    jboolean isCopy_nv21;
    jboolean isCopy_rgba;
    jboolean isCopy_out;
    jbyte* nv21 = (jbyte*)env->GetPrimitiveArrayCritical(nv21_data, &isCopy_nv21);
    jbyte* rgba = (jbyte*)env->GetPrimitiveArrayCritical(rgba_data, &isCopy_rgba);
    jbyte* out = (jbyte*)env->GetPrimitiveArrayCritical(output_buffer, &isCopy_out);

    jclass clazz = env->GetObjectClass(thiz);
    jfieldID fidWidth = env->GetFieldID(clazz, "previewWidth", "I");
    jfieldID fidHeight = env->GetFieldID(clazz, "previewHeight", "I");
    
    // Fallback if fields not in Engine
    int width = 640;
    int height = 480;

    // Perform NEON conversion
    nv21_to_rgba_neon((uint8_t*)nv21, (uint8_t*)rgba, width, height);

    // Mock face warping - in real scenario, this calls the engine
    memcpy(out, rgba, width * height * 4);

    env->ReleasePrimitiveArrayCritical(nv21_data, nv21, JNI_ABORT);
    env->ReleasePrimitiveArrayCritical(rgba_data, rgba, 0);
    env->ReleasePrimitiveArrayCritical(output_buffer, out, 0);

    return 0;
}

}
