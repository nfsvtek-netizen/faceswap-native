.class public Lcom/tencent/scrfdncnn/MainActivity;
.super Landroid/app/Activity;
.source "MainActivity.java"

# interfaces
.implements Landroid/view/SurfaceHolder$Callback;
.implements Landroid/hardware/Camera$PreviewCallback;

# static fields
.field public static final REQUEST_CAMERA:I = 0x64

# direct methods
.method static constructor <clinit>()V
    .locals 1
    const-string v0, "omp"
    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V
    const-string v0, "scrfdncnn"
    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V
    const-string v0, "facewarp"
    invoke-static {v0}, Ljava/lang/System;->loadLibrary(Ljava/lang/String;)V
    return-void
.end method

# instance fields
.field private cameraView:Landroid/view/SurfaceView;
.field private current_cpugpu:I
.field private current_model:I
.field private facing:I
.field private loadingView:Landroid/widget/TextView;
.field private final modelExecutor:Ljava/util/concurrent/ExecutorService;
.field private mNativeHandle:J
.field private mWarpActive:Z
.field private scrfdncnn:Lcom/tencent/scrfdncnn/SCRFDNcnn;
.field private spinnerCPUGPU:Landroid/widget/Spinner;
.field private spinnerModel:Landroid/widget/Spinner;
.field private warpOutBuffer:[B
.field private faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;
.field private previewWidth:I
.field private previewHeight:I
.field private rgbaBuffer:[B
.field private scrfdInitialized:Z

# direct methods
.method public constructor <init>()V
    .locals 3
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V
    new-instance v0, Lcom/tencent/scrfdncnn/SCRFDNcnn;
    invoke-direct {v0}, Lcom/tencent/scrfdncnn/SCRFDNcnn;-><init>()V
    iput-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdncnn:Lcom/tencent/scrfdncnn/SCRFDNcnn;
    const/4 v0, 0x0
    iput v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->facing:I
    iput v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->current_model:I
    iput v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->current_cpugpu:I
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;
    move-result-object v0
    iput-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->modelExecutor:Ljava/util/concurrent/ExecutorService;
    const-wide/16 v0, 0x0
    iput-wide v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->mNativeHandle:J
    const/4 v0, 0x0
    iput-boolean v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->mWarpActive:Z
    iput-boolean v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdInitialized:Z
    new-instance v0, Lcom/yourcompany/app/FaceWarpEngine;
    invoke-direct {v0}, Lcom/yourcompany/app/FaceWarpEngine;-><init>()V
    iput-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;
    return-void
.end method

.method static synthetic access$000(Lcom/tencent/scrfdncnn/MainActivity;)I
    .locals 1
    iget v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->facing:I
    return v0
.end method

.method static synthetic access$002(Lcom/tencent/scrfdncnn/MainActivity;I)I
    .locals 0
    iput p1, p0, Lcom/tencent/scrfdncnn/MainActivity;->facing:I
    return p1
.end method

.method static synthetic access$100(Lcom/tencent/scrfdncnn/MainActivity;)Lcom/tencent/scrfdncnn/SCRFDNcnn;
    .locals 1
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdncnn:Lcom/tencent/scrfdncnn/SCRFDNcnn;
    return-object v0
.end method

.method static synthetic access$200(Lcom/tencent/scrfdncnn/MainActivity;)I
    .locals 1
    iget v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->current_model:I
    return v0
.end method

.method static synthetic access$202(Lcom/tencent/scrfdncnn/MainActivity;I)I
    .locals 0
    iput p1, p0, Lcom/tencent/scrfdncnn/MainActivity;->current_model:I
    return p1
.end method

.method static synthetic access$300(Lcom/tencent/scrfdncnn/MainActivity;)V
    .locals 0
    invoke-direct {p0}, Lcom/tencent/scrfdncnn/MainActivity;->reload()V
    return-void
.end method

.method static synthetic access$400(Lcom/tencent/scrfdncnn/MainActivity;)I
    .locals 1
    iget v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->current_cpugpu:I
    return v0
.end method

.method static synthetic access$402(Lcom/tencent/scrfdncnn/MainActivity;I)I
    .locals 0
    iput p1, p0, Lcom/tencent/scrfdncnn/MainActivity;->current_cpugpu:I
    return p1
.end method

.method static synthetic access$500(Lcom/tencent/scrfdncnn/MainActivity;)Landroid/widget/TextView;
    .locals 1
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->loadingView:Landroid/widget/TextView;
    return-object v0
.end method

.method private reload()V
    .locals 2
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->loadingView:Landroid/widget/TextView;
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->modelExecutor:Ljava/util/concurrent/ExecutorService;
    new-instance v1, Lcom/tencent/scrfdncnn/MainActivity$4;
    invoke-direct {v1, p0}, Lcom/tencent/scrfdncnn/MainActivity$4;-><init>(Lcom/tencent/scrfdncnn/MainActivity;)V
    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V
    return-void
.end method

# virtual methods
.method public onCreate(Landroid/os/Bundle;)V
    .locals 3
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
    const/high16 v0, 0x7f030000
    invoke-virtual {p0, v0}, Lcom/tencent/scrfdncnn/MainActivity;->setContentView(I)V
    invoke-virtual {p0}, Lcom/tencent/scrfdncnn/MainActivity;->getWindow()Landroid/view/Window;
    move-result-object v0
    const/16 v1, 0x80
    invoke-virtual {v0, v1}, Landroid/view/Window;->addFlags(I)V
    const v0, 0x7f020001
    invoke-virtual {p0, v0}, Lcom/tencent/scrfdncnn/MainActivity;->findViewById(I)Landroid/view/View;
    move-result-object v0
    check-cast v0, Landroid/view/SurfaceView;
    iput-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->cameraView:Landroid/view/SurfaceView;
    const v0, 0x7f020002
    invoke-virtual {p0, v0}, Lcom/tencent/scrfdncnn/MainActivity;->findViewById(I)Landroid/view/View;
    move-result-object v0
    check-cast v0, Landroid/widget/TextView;
    iput-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->loadingView:Landroid/widget/TextView;
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->cameraView:Landroid/view/SurfaceView;
    invoke-virtual {v0}, Landroid/view/SurfaceView;->getHolder()Landroid/view/SurfaceHolder;
    move-result-object v0
    const/4 v1, 0x1
    invoke-interface {v0, v1}, Landroid/view/SurfaceHolder;->setFormat(I)V
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->cameraView:Landroid/view/SurfaceView;
    invoke-virtual {v0}, Landroid/view/SurfaceView;->getHolder()Landroid/view/SurfaceHolder;
    move-result-object v0
    invoke-interface {v0, p0}, Landroid/view/SurfaceHolder;->addCallback(Landroid/view/SurfaceHolder$Callback;)V
    const/high16 v0, 0x7f020000
    invoke-virtual {p0, v0}, Lcom/tencent/scrfdncnn/MainActivity;->findViewById(I)Landroid/view/View;
    move-result-object v0
    check-cast v0, Landroid/widget/Button;
    new-instance v1, Lcom/tencent/scrfdncnn/MainActivity$1;
    invoke-direct {v1, p0}, Lcom/tencent/scrfdncnn/MainActivity$1;-><init>(Lcom/tencent/scrfdncnn/MainActivity;)V
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    const v1, 0x7f020004
    invoke-virtual {p0, v1}, Lcom/tencent/scrfdncnn/MainActivity;->findViewById(I)Landroid/view/View;
    move-result-object v1
    check-cast v1, Landroid/widget/Spinner;
    iput-object v1, p0, Lcom/tencent/scrfdncnn/MainActivity;->spinnerModel:Landroid/widget/Spinner;
    new-instance v2, Lcom/tencent/scrfdncnn/MainActivity$2;
    invoke-direct {v2, p0}, Lcom/tencent/scrfdncnn/MainActivity$2;-><init>(Lcom/tencent/scrfdncnn/MainActivity;)V
    invoke-virtual {v1, v2}, Landroid/widget/Spinner;->setOnItemSelectedListener(Landroid/widget/AdapterView$OnItemSelectedListener;)V
    const v1, 0x7f020003
    invoke-virtual {p0, v1}, Lcom/tencent/scrfdncnn/MainActivity;->findViewById(I)Landroid/view/View;
    move-result-object v1
    check-cast v1, Landroid/widget/Spinner;
    iput-object v1, p0, Lcom/tencent/scrfdncnn/MainActivity;->spinnerCPUGPU:Landroid/widget/Spinner;
    new-instance v2, Lcom/tencent/scrfdncnn/MainActivity$3;
    invoke-direct {v2, p0}, Lcom/tencent/scrfdncnn/MainActivity$3;-><init>(Lcom/tencent/scrfdncnn/MainActivity;)V
    invoke-virtual {v1, v2}, Landroid/widget/Spinner;->setOnItemSelectedListener(Landroid/widget/AdapterView$OnItemSelectedListener;)V
    invoke-direct {p0}, Lcom/tencent/scrfdncnn/MainActivity;->reload()V
    return-void
.end method

.method public onDestroy()V
    .locals 2
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->modelExecutor:Ljava/util/concurrent/ExecutorService;
    invoke-interface {v0}, Ljava/util/concurrent/ExecutorService;->shutdownNow()Ljava/util/List;
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;
    if-eqz v0, :L_skip_scrfd_destroy
    invoke-virtual {v0}, Lcom/yourcompany/app/FaceWarpEngine;->cleanupScrfdDetector()V
:L_skip_scrfd_destroy
    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;
    if-eqz v0, :L_end_destroy_engine
    invoke-virtual {v0}, Lcom/yourcompany/app/FaceWarpEngine;->destroy()V
:L_end_destroy_engine
    return-void
.end method

.method public onPause()V
    .locals 1
    invoke-super {p0}, Landroid/app/Activity;->onPause()V
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdncnn:Lcom/tencent/scrfdncnn/SCRFDNcnn;
    invoke-virtual {v0}, Lcom/tencent/scrfdncnn/SCRFDNcnn;->closeCamera()Z
    return-void
.end method

.method public onResume()V
    .locals 3
    invoke-super {p0}, Landroid/app/Activity;->onResume()V
    invoke-virtual {p0}, Lcom/tencent/scrfdncnn/MainActivity;->getApplicationContext()Landroid/content/Context;
    move-result-object v0
    const-string v1, "android.permission.CAMERA"
    invoke-static {v0, v1}, Landroid/support/v4/content/ContextCompat;->checkSelfPermission(Landroid/content/Context;Ljava/lang/String;)I
    move-result v0
    const/4 v2, -0x1
    if-ne v0, v2, :cond_0
    filled-new-array {v1}, [Ljava/lang/String;
    move-result-object v0
    const/16 v1, 0x64
    invoke-static {p0, v0, v1}, Landroid/support/v4/app/ActivityCompat;->requestPermissions(Landroid/app/Activity;[Ljava/lang/String;I)V
:cond_0
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdncnn:Lcom/tencent/scrfdncnn/SCRFDNcnn;
    iget v1, p0, Lcom/tencent/scrfdncnn/MainActivity;->facing:I
    invoke-virtual {v0, v1}, Lcom/tencent/scrfdncnn/SCRFDNcnn;->openCamera(I)Z
    return-void
.end method

.method public surfaceChanged(Landroid/view/SurfaceHolder;III)V
    .locals 8
    .param p1, "holder"    # Landroid/view/SurfaceHolder;
    .param p2, "format"    # I
    .param p3, "width"    # I
    .param p4, "height"    # I

    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdncnn:Lcom/tencent/scrfdncnn/SCRFDNcnn;
    invoke-interface {p1}, Landroid/view/SurfaceHolder;->getSurface()Landroid/view/Surface;
    move-result-object v1
    invoke-virtual {v0, v1}, Lcom/tencent/scrfdncnn/SCRFDNcnn;->setOutputWindow(Landroid/view/Surface;)Z

    iput p3, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewWidth:I
    iput p4, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewHeight:I

    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;
    if-eqz v0, :L_end_init_engine

    iget v1, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewWidth:I
    iget v2, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewHeight:I
    invoke-virtual {v0, v1, v2}, Lcom/yourcompany/app/FaceWarpEngine;->init(II)J
    move-result-wide v3
    invoke-virtual {v0, v3, v4}, Lcom/yourcompany/app/FaceWarpEngine;->setNativeHandle(J)V

    iget-boolean v1, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdInitialized:Z
    if-nez v1, :L_already_init

    const/16 v1, 0xa
    invoke-virtual {v0, v1}, Lcom/yourcompany/app/FaceWarpEngine;->createScrfdDetector(I)J
    move-result-wide v1
    invoke-virtual {v0, v1, v2}, Lcom/yourcompany/app/FaceWarpEngine;->setScrfdHandle(J)V

    # v0 = engine, v1/v2 = handle
    invoke-virtual {p0}, Lcom/tencent/scrfdncnn/MainActivity;->getAssets()Landroid/content/res/AssetManager;
    move-result-object v3
    const-string v4, "scrfd_500m-opt2.param"
    const-string v5, "scrfd_500m-opt2.bin"
    invoke-virtual/range {v0 .. v5}, Lcom/yourcompany/app/FaceWarpEngine;->loadScrfdModel(JLandroid/content/res/AssetManager;Ljava/lang/String;Ljava/lang/String;)I
    const/4 v0, 0x1
    iput-boolean v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdInitialized:Z

:L_already_init
:L_end_init_engine
    const/4 v0, 0x1
    iput-boolean v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->mWarpActive:Z
    return-void
.end method

.method public surfaceCreated(Landroid/view/SurfaceHolder;)V
    .locals 0
    return-void
.end method

.method public surfaceDestroyed(Landroid/view/SurfaceHolder;)V
    .locals 0
    return-void
.end method

.method public onPreviewFrame([BLandroid/hardware/Camera;)V
    .locals 12
    .param p1, "data"    # [B
    .param p2, "camera"  # Landroid/hardware/Camera;

    iget-boolean v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->mWarpActive:Z
    if-nez v0, :end_method

    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;
    if-nez v0, :end_method

    invoke-virtual {v0}, Lcom/yourcompany/app/FaceWarpEngine;->getNativeHandle()J
    move-result-wide v1
    const-wide/16 v3, 0x0
    cmp-long v0, v1, v3
    if-nez v0, :end_method

    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;
    invoke-virtual {v0}, Lcom/yourcompany/app/FaceWarpEngine;->getScrfdHandle()J
    move-result-wide v1
    cmp-long v0, v1, v3
    if-nez v0, :end_method

    invoke-virtual {p2}, Landroid/hardware/Camera;->getParameters()Landroid/hardware/Camera$Parameters;
    move-result-object v0
    invoke-virtual {v0}, Landroid/hardware/Camera$Parameters;->getPreviewSize()Landroid/hardware/Camera$Size;
    move-result-object v0
    iget v1, v0, Landroid/hardware/Camera$Size;->width:I
    iput v1, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewWidth:I
    iget v0, v0, Landroid/hardware/Camera$Size;->height:I
    iput v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewHeight:I

    mul-int v2, v1, v0
    mul-int/lit8 v3, v2, 0x4
    iget-object v4, p0, Lcom/tencent/scrfdncnn/MainActivity;->rgbaBuffer:[B
    if-eqz v4, :L_check_rgba
    array-length v5, v4
    if-ge v5, v3, :L_run_convert
:L_check_rgba
    new-array v4, v3, [B
    iput-object v4, p0, Lcom/tencent/scrfdncnn/MainActivity;->rgbaBuffer:[B
:L_run_convert
    iget-object v5, p0, Lcom/tencent/scrfdncnn/MainActivity;->warpOutBuffer:[B
    if-eqz v5, :L_check_warp
    array-length v6, v5
    if-ge v6, v3, :L_do_convert
:L_check_warp
    new-array v5, v3, [B
    iput-object v5, p0, Lcom/tencent/scrfdncnn/MainActivity;->warpOutBuffer:[B
:L_do_convert
    iget-object v6, p0, Lcom/tencent/scrfdncnn/MainActivity;->faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;
    move-object v0, v6
    move-object v1, p1
    move-object v2, v4
    move-object v3, v5
    invoke-virtual/range {v0 .. v3}, Lcom/yourcompany/app/FaceWarpEngine;->processFrame([B[B[B)I

    invoke-virtual {v6}, Lcom/yourcompany/app/FaceWarpEngine;->getScrfdHandle()J
    move-result-wide v1
    move-object v0, v6
    move-object v3, v4
    iget v4, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewWidth:I
    iget v5, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewHeight:I
    invoke-virtual/range {v0 .. v5}, Lcom/yourcompany/app/FaceWarpEngine;->detectFace(J[BII)I
    move-result v0

    if-ltz v0, :L_skip_warp
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdncnn:Lcom/tencent/scrfdncnn/SCRFDNcnn;
    invoke-virtual {v6}, Lcom/yourcompany/app/FaceWarpEngine;->getNativeHandle()J
    move-result-wide v1
    iget-object v3, p0, Lcom/tencent/scrfdncnn/MainActivity;->rgbaBuffer:[B
    iget-object v4, p0, Lcom/tencent/scrfdncnn/MainActivity;->rgbaBuffer:[B
    iget-object v5, p0, Lcom/tencent/scrfdncnn/MainActivity;->warpOutBuffer:[B
    invoke-virtual/range {v0 .. v5}, Lcom/tencent/scrfdncnn/SCRFDNcnn;->executeWarp(J[B[B[B)I
    iget-object v1, p0, Lcom/tencent/scrfdncnn/MainActivity;->warpOutBuffer:[B
    invoke-virtual {v0, v1}, Lcom/tencent/scrfdncnn/SCRFDNcnn;->pushFrameBuffer([B)V
:L_skip_warp
:end_method
    return-void
.end method
