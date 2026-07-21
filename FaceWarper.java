package com.tencent.scrfdncnn;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Path;

public class FaceWarper {
    public static void drawOverlay(Canvas canvas, int width, int height) {
        if (canvas == null || width <= 0 || height <= 0) {
            return;
        }

        Bitmap source = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        Canvas srcCanvas = new Canvas(source);
        Paint basePaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        basePaint.setColor(0xFFEEB6B6);
        srcCanvas.drawCircle(width / 2f, height / 2f, Math.min(width, height) * 0.35f, basePaint);

        Paint eyePaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        eyePaint.setColor(0xFF111111);
        srcCanvas.drawCircle(width * 0.40f, height * 0.42f, width * 0.045f, eyePaint);
        srcCanvas.drawCircle(width * 0.60f, height * 0.42f, width * 0.045f, eyePaint);

        Paint mouthPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        mouthPaint.setColor(0xFFB45B5B);
        srcCanvas.drawArc(width * 0.32f, height * 0.56f, width * 0.68f, height * 0.74f, 0f, -180f, false, mouthPaint);

        Paint warpPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        warpPaint.setFilterBitmap(true);

        float[] srcTriA = {0f, 0f, width, 0f, 0f, height};
        float[] dstTriA = {width * 0.18f, height * 0.16f, width * 0.84f, height * 0.12f, width * 0.22f, height * 0.92f};
        drawTriangle(canvas, source, srcTriA, dstTriA, warpPaint);

        float[] srcTriB = {width, 0f, width, height, 0f, height};
        float[] dstTriB = {width * 0.84f, height * 0.12f, width * 0.80f, height * 0.94f, width * 0.22f, height * 0.92f};
        drawTriangle(canvas, source, srcTriB, dstTriB, warpPaint);
    }

    private static void drawTriangle(Canvas dstCanvas, Bitmap source, float[] src, float[] dst, Paint paint) {
        Matrix matrix = new Matrix();
        matrix.setPolyToPoly(src, 0, dst, 0, 3);

        Path clipPath = new Path();
        clipPath.moveTo(dst[0], dst[1]);
        clipPath.lineTo(dst[2], dst[3]);
        clipPath.lineTo(dst[4], dst[5]);
        clipPath.close();

        dstCanvas.save();
        dstCanvas.clipPath(clipPath);
        dstCanvas.drawBitmap(source, matrix, paint);
        dstCanvas.restore();
    }
}
