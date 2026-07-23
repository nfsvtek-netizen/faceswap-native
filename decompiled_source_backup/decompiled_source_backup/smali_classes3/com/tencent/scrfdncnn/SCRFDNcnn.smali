.class public Lcom/tencent/scrfdncnn/SCRFDNcnn;
.super Ljava/lang/Object;
.source "SCRFDNcnn.java"


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 28
    const-string v0, "scrfdncnn"

    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    .line 29
    const-string v0, "facewarp"

    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 20
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public native closeCamera()Z
.end method

.method public native loadModel(Landroid/content/res/AssetManager;II)Z
.end method

.method public native openCamera(I)Z
.end method

.method public native setOutputWindow(Landroid/view/Surface;)Z
.end method

.method private native executeWarp(J[B[B[B)I
.end method

.method private native pushFrameBuffer([B)V
.end method

# ---- Public wrapper: exposes executeWarp to callers outside this class ----
# Signature: int runWarp(long nativeHandle, byte[] rgbaData, byte[] srcBuffer, byte[] dstBuffer)
.method public runWarp(J[B[B[B)I
    .locals 1
    .param p1, "nativeHandle"    # J
    .param p2, "rgbaData"       # [B
    .param p3, "srcBuffer"      # [B
    .param p4, "dstBuffer"      # [B

    invoke-direct {p0, p1, p2, p3, p4}, Lcom/tencent/scrfdncnn/SCRFDNcnn;->executeWarp(J[B[B[B)I

    move-result v0

    return v0
.end method
