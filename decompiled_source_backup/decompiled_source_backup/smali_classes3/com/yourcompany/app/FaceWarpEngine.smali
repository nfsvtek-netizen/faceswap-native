.class public Lcom/yourcompany/app/FaceWarpEngine;
.super Ljava/lang/Object;


# static fields
.field private static final TAG:Ljava/lang/String; = "FaceWarpEngine"


# instance fields
.field private mNativeHandle:J

.field private mScrfdHandle:J


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 10
    const-string v0, "facewarp"
    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    return-void
.end method

.method public constructor <init>()V
    .locals 3

    .line 14
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 15
    const-wide/16 v0, 0x0
    iput-wide v0, p0, Lcom/yourcompany/app/FaceWarpEngine;->mNativeHandle:J

    .line 16
    const-wide/16 v0, 0x0
    iput-wide v0, p0, Lcom/yourcompany/app/FaceWarpEngine;->mScrfdHandle:J

    return-void
.end method


# virtual methods
.method public native destroy()V
.end method

.method public native init(II)J
.end method

.method public native processFrame([B[B[B)I
.end method

# ---- New JNI bindings for Vulkan/Tracking C++ pipeline ----

.method public native createScrfdDetector(I)J
.end method

.method public native loadScrfdModel(JLandroid/content/res/AssetManager;Ljava/lang/String;Ljava/lang/String;)I
.end method

.method public native detectFace(J[BII)I
.end method

.method public native getCachedBBox(J)[F
.end method

.method public native destroyScrfdDetector(J)V
.end method

# ---- Convenience methods used by MainActivity lifecycle ----

.method public setNativeHandle(J)V
    .locals 0
    .param p1, "handle"    # J

    .line 24
    iput-wide p1, p0, Lcom/yourcompany/app/FaceWarpEngine;->mNativeHandle:J

    return-void
.end method

.method public getNativeHandle()J
    .locals 2

    .line 28
    iget-wide v0, p0, Lcom/yourcompany/app/FaceWarpEngine;->mNativeHandle:J

    return-wide v0
.end method

.method public setScrfdHandle(J)V
    .locals 0
    .param p1, "handle"    # J

    iput-wide p1, p0, Lcom/yourcompany/app/FaceWarpEngine;->mScrfdHandle:J

    return-void
.end method

.method public getScrfdHandle()J
    .locals 2

    iget-wide v0, p0, Lcom/yourcompany/app/FaceWarpEngine;->mScrfdHandle:J

    return-wide v0
.end method

.method public initScrfdDetector(Landroid/content/res/AssetManager;Ljava/lang/String;Ljava/lang/String;I)J
    .locals 5
    .param p1, "assetManager"    # Landroid/content/res/AssetManager;
    .param p2, "paramPath"       # Ljava/lang/String;
    .param p3, "binPath"         # Ljava/lang/String;
    .param p4, "skipInterval"    # I

    .line 70
    invoke-virtual {p0, p4}, Lcom/yourcompany/app/FaceWarpEngine;->createScrfdDetector(I)J

    move-result-wide v0

    .line 71
    invoke-virtual {p0, v0, v1, p1, p2, p3}, Lcom/yourcompany/app/FaceWarpEngine;->loadScrfdModel(JLandroid/content/res/AssetManager;Ljava/lang/String;Ljava/lang/String;)I

    move-result v2

    .line 72
    if-gez v2, :cond_err

    .line 73
    invoke-virtual {p0, v0, v1}, Lcom/yourcompany/app/FaceWarpEngine;->setScrfdHandle(J)V

    :cond_err
    return-wide v0
.end method

.method public cleanupScrfdDetector()V
    .locals 4

    .line 80
    iget-wide v0, p0, Lcom/yourcompany/app/FaceWarpEngine;->mScrfdHandle:J

    const-wide/16 v2, 0x0

    cmp-long v4, v0, v2

    if-nez v4, :L_done

    .line 81
    invoke-virtual {p0, v0, v1}, Lcom/yourcompany/app/FaceWarpEngine;->destroyScrfdDetector(J)V

    const-wide/16 v0, 0x0
    iput-wide v0, p0, Lcom/yourcompany/app/FaceWarpEngine;->mScrfdHandle:J

:L_done
    return-void
.end method
