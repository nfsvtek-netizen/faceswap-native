.class public Lcom/yourcompany/app/FaceWarpEngine;
.super Ljava/lang/Object;

# static fields
.field private static final TAG:Ljava/lang/String; = "FaceWarpEngine"

# instance fields
.field private mNativeHandle:J
.field private mScrfdHandle:J
.field public previewWidth:I
.field public previewHeight:I

# direct methods
.method static constructor <clinit>()V
    .locals 1
    const-string v0, "facewarp"
    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V
    return-void
.end method

.method public constructor <init>()V
    .locals 3
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    const-wide/16 v0, 0x0
    iput-wide v0, p0, Lcom/yourcompany/app/FaceWarpEngine;->mNativeHandle:J
    iput-wide v0, p0, Lcom/yourcompany/app/FaceWarpEngine;->mScrfdHandle:J
    const/4 v0, 0x0
    iput v0, p0, Lcom/yourcompany/app/FaceWarpEngine;->previewWidth:I
    iput v0, p0, Lcom/yourcompany/app/FaceWarpEngine;->previewHeight:I
    return-void
.end method

# virtual methods
.method public native destroy()V
.end method

.method public native init(II)J
.end method

.method public native processFrame([B[B[B)I
.end method

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

.method public setNativeHandle(J)V
    .locals 0
    iput-wide p1, p0, Lcom/yourcompany/app/FaceWarpEngine;->mNativeHandle:J
    return-void
.end method

.method public getNativeHandle()J
    .locals 2
    iget-wide v0, p0, Lcom/yourcompany/app/FaceWarpEngine;->mNativeHandle:J
    return-wide v0
.end method

.method public setScrfdHandle(J)V
    .locals 0
    iput-wide p1, p0, Lcom/yourcompany/app/FaceWarpEngine;->mScrfdHandle:J
    return-void
.end method

.method public getScrfdHandle()J
    .locals 2
    iget-wide v0, p0, Lcom/yourcompany/app/FaceWarpEngine;->mScrfdHandle:J
    return-wide v0
.end method

.method public cleanupScrfdDetector()V
    .locals 4
    iget-wide v0, p0, Lcom/yourcompany/app/FaceWarpEngine;->mScrfdHandle:J
    const-wide/16 v2, 0x0
    cmp-long v4, v0, v2
    if-nez v4, :L_done
    invoke-virtual {p0, v0, v1}, Lcom/yourcompany/app/FaceWarpEngine;->destroyScrfdDetector(J)V
    const-wide/16 v0, 0x0
    iput-wide v0, p0, Lcom/yourcompany/app/FaceWarpEngine;->mScrfdHandle:J
:L_done
    return-void
.end method
