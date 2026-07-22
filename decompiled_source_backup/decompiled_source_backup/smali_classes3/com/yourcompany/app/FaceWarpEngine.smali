.class public Lcom/yourcompany/app/FaceWarpEngine;
.super Ljava/lang/Object;


# static fields
.field private static final TAG:Ljava/lang/String; = "FaceWarpEngine"


# instance fields
.field private mNativeHandle:J


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 10
    const-string v0, "facewarp"
    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 14
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 15
    const-wide/16 v0, 0x0
    iput-wide v0, p0, Lcom/yourcompany/app/FaceWarpEngine;->mNativeHandle:J

    return-void
.end method


# virtual methods
.method public native destroy()V
.end method

.method public native init(II)J
.end method

.method public native processFrame([B[B[B)I
.end method

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
