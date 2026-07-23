.class public Lcom/tencent/scrfdncnn/MainActivity;
.super Landroid/app/Activity;
.source "MainActivity.java"


# interfaces
.implements Landroid/view/SurfaceHolder$Callback;
.implements Landroid/hardware/Camera$PreviewCallback;


# static fields
.field public static final REQUEST_CAMERA:I = 0x64


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

    .line 39
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    .line 43
    new-instance v0, Lcom/tencent/scrfdncnn/SCRFDNcnn;

    invoke-direct {v0}, Lcom/tencent/scrfdncnn/SCRFDNcnn;-><init>()V

    iput-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdncnn:Lcom/tencent/scrfdncnn/SCRFDNcnn;

    .line 44
    const/4 v0, 0x0

    iput v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->facing:I

    .line 48
    iput v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->current_model:I

    .line 49
    iput v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->current_cpugpu:I

    .line 53
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    iput-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->modelExecutor:Ljava/util/concurrent/ExecutorService;

    .line 56
    const-wide/16 v0, 0x0L
    iput-wide v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->mNativeHandle:J

    .line 57
    const/4 v0, 0x0
    iput-boolean v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->mWarpActive:Z

    .line 58
    const/4 v0, 0x0
    iput-boolean v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdInitialized:Z

    .line 60
    new-instance v0, Lcom/yourcompany/app/FaceWarpEngine;
    invoke-direct {v0}, Lcom/yourcompany/app/FaceWarpEngine;-><init>()V
    iput-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;

    return-void
.end method

.method static synthetic access$000(Lcom/tencent/scrfdncnn/MainActivity;)I
    .locals 1
    .param p0, "x0"    # Lcom/tencent/scrfdncnn/MainActivity;

    .line 39
    iget v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->facing:I

    return v0
.end method

.method static synthetic access$002(Lcom/tencent/scrfdncnn/MainActivity;I)I
    .locals 0
    .param p0, "x0"    # Lcom/tencent/scrfdncnn/MainActivity;
    .param p1, "x1"    # I

    .line 39
    iput p1, p0, Lcom/tencent/scrfdncnn/MainActivity;->facing:I

    return p1
.end method

.method static synthetic access$100(Lcom/tencent/scrfdncnn/MainActivity;)Lcom/tencent/scrfdncnn/SCRFDNcnn;
    .locals 1
    .param p0, "x0"    # Lcom/tencent/scrfdncnn/MainActivity;

    .line 39
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdncnn:Lcom/tencent/scrfdncnn/SCRFDNcnn;

    return-object v0
.end method

.method static synthetic access$200(Lcom/tencent/scrfdncnn/MainActivity;)I
    .locals 1
    .param p0, "x0"    # Lcom/tencent/scrfdncnn/MainActivity;

    .line 39
    iget v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->current_model:I

    return v0
.end method

.method static synthetic access$202(Lcom/tencent/scrfdncnn/MainActivity;I)I
    .locals 0
    .param p0, "x0"    # Lcom/tencent/scrfdncnn/MainActivity;
    .param p1, "x1"    # I

    .line 39
    iput p1, p0, Lcom/tencent/scrfdncnn/MainActivity;->current_model:I

    return p1
.end method

.method static synthetic access$300(Lcom/tencent/scrfdncnn/MainActivity;)V
    .locals 0
    .param p0, "x0"    # Lcom/tencent/scrfdncnn/MainActivity;

    .line 39
    invoke-direct {p0}, Lcom/tencent/scrfdncnn/MainActivity;->reload()V

    return-void
.end method

.method static synthetic access$400(Lcom/tencent/scrfdncnn/MainActivity;)I
    .locals 1
    .param p0, "x0"    # Lcom/tencent/scrfdncnn/MainActivity;

    .line 39
    iget v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->current_cpugpu:I

    return v0
.end method

.method static synthetic access$402(Lcom/tencent/scrfdncnn/MainActivity;I)I
    .locals 0
    .param p0, "x0"    # Lcom/tencent/scrfdncnn/MainActivity;
    .param p1, "x1"    # I

    .line 39
    iput p1, p0, Lcom/tencent/scrfdncnn/MainActivity;->current_cpugpu:I

    return p1
.end method

.method static synthetic access$500(Lcom/tencent/scrfdncnn/MainActivity;)Landroid/widget/TextView;
    .locals 1
    .param p0, "x0"    # Lcom/tencent/scrfdncnn/MainActivity;

    .line 39
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->loadingView:Landroid/widget/TextView;

    return-object v0
.end method

.method private reload()V
    .locals 2

    .line 128
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->loadingView:Landroid/widget/TextView;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 130
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->modelExecutor:Ljava/util/concurrent/ExecutorService;

    new-instance v1, Lcom/tencent/scrfdncnn/MainActivity$4;

    invoke-direct {v1, p0}, Lcom/tencent/scrfdncnn/MainActivity$4;-><init>(Lcom/tencent/scrfdncnn/MainActivity;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 146
    return-void
.end method


# virtual methods
.method public onCreate(Landroid/os/Bundle;)V
    .locals 3
    .param p1, "savedInstanceState"    # Landroid/os/Bundle;

    .line 59
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 60
    const/high16 v0, 0x7f030000

    invoke-virtual {p0, v0}, Lcom/tencent/scrfdncnn/MainActivity;->setContentView(I)V

    .line 62
    invoke-virtual {p0}, Lcom/tencent/scrfdncnn/MainActivity;->getWindow()Landroid/view/Window;

    move-result-object v0

    const/16 v1, 0x80

    invoke-virtual {v0, v1}, Landroid/view/Window;->addFlags(I)V

    .line 64
    const v0, 0x7f020001

    invoke-virtual {p0, v0}, Lcom/tencent/scrfdncnn/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/view/SurfaceView;

    iput-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->cameraView:Landroid/view/SurfaceView;

    .line 65
    const v0, 0x7f020002

    invoke-virtual {p0, v0}, Lcom/tencent/scrfdncnn/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->loadingView:Landroid/widget/TextView;

    .line 67
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 69
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->cameraView:Landroid/view/SurfaceView;

    invoke-virtual {v0}, Landroid/view/SurfaceView;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v0

    const/4 v1, 0x1

    invoke-interface {v0, v1}, Landroid/view/SurfaceHolder;->setFormat(I)V

    .line 70
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->cameraView:Landroid/view/SurfaceView;

    invoke-virtual {v0}, Landroid/view/SurfaceView;->getHolder()Landroid/view/SurfaceHolder;

    move-result-object v0

    invoke-interface {v0, p0}, Landroid/view/SurfaceHolder;->addCallback(Landroid/view/SurfaceHolder$Callback;)V

    .line 72
    const/high16 v0, 0x7f020000

    invoke-virtual {p0, v0}, Lcom/tencent/scrfdncnn/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    .line 73
    .local v0, "buttonSwitchCamera":Landroid/widget/Button;
    new-instance v1, Lcom/tencent/scrfdncnn/MainActivity$1;

    invoke-direct {v1, p0}, Lcom/tencent/scrfdncnn/MainActivity$1;-><init>(Lcom/tencent/scrfdncnn/MainActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 87
    const v1, 0x7f020004

    invoke-virtual {p0, v1}, Lcom/tencent/scrfdncnn/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/Spinner;

    iput-object v1, p0, Lcom/tencent/scrfdncnn/MainActivity;->spinnerModel:Landroid/widget/Spinner;

    .line 88
    new-instance v2, Lcom/tencent/scrfdncnn/MainActivity$2;

    invoke-direct {v2, p0}, Lcom/tencent/scrfdncnn/MainActivity$2;-><init>(Lcom/tencent/scrfdncnn/MainActivity;)V

    invoke-virtual {v1, v2}, Landroid/widget/Spinner;->setOnItemSelectedListener(Landroid/widget/AdapterView$OnItemSelectedListener;)V

    .line 105
    const v1, 0x7f020003

    invoke-virtual {p0, v1}, Lcom/tencent/scrfdncnn/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/Spinner;

    iput-object v1, p0, Lcom/tencent/scrfdncnn/MainActivity;->spinnerCPUGPU:Landroid/widget/Spinner;

    .line 106
    new-instance v2, Lcom/tencent/scrfdncnn/MainActivity$3;

    invoke-direct {v2, p0}, Lcom/tencent/scrfdncnn/MainActivity$3;-><init>(Lcom/tencent/scrfdncnn/MainActivity;)V

    invoke-virtual {v1, v2}, Landroid/widget/Spinner;->setOnItemSelectedListener(Landroid/widget/AdapterView$OnItemSelectedListener;)V

    .line 123
    invoke-direct {p0}, Lcom/tencent/scrfdncnn/MainActivity;->reload()V

    .line 124
    return-void
.end method

.method public onDestroy()V
    .locals 2

    .line 188
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->modelExecutor:Ljava/util/concurrent/ExecutorService;

    invoke-interface {v0}, Ljava/util/concurrent/ExecutorService;->shutdownNow()Ljava/util/List;

    # ---- Teardown: destroy the new SCRFD Vulkan detector ----
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;
    if-eqz v0, :L_skip_scrfd_destroy
    invoke-virtual {v0}, Lcom/yourcompany/app/FaceWarpEngine;->cleanupScrfdDetector()V
:L_skip_scrfd_destroy

    .line 189
    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V

    .line 190
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;
    if-eqz v0, :L_end_destroy_engine
    invoke-virtual {v0}, Lcom/yourcompany/app/FaceWarpEngine;->destroy()V
:L_end_destroy_engine
    return-void
.end method

.method public onPause()V
    .locals 1

    .line 180
    invoke-super {p0}, Landroid/app/Activity;->onPause()V

    .line 182
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdncnn:Lcom/tencent/scrfdncnn/SCRFDNcnn;

    invoke-virtual {v0}, Lcom/tencent/scrfdncnn/SCRFDNcnn;->closeCamera()Z

    .line 183
    return-void
.end method

.method public onResume()V
    .locals 3

    .line 167
    invoke-super {p0}, Landroid/app/Activity;->onResume()V

    .line 169
    invoke-virtual {p0}, Lcom/tencent/scrfdncnn/MainActivity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "android.permission.CAMERA"

    invoke-static {v0, v1}, Landroid/support/v4/content/ContextCompat;->checkSelfPermission(Landroid/content/Context;Ljava/lang/String;)I

    move-result v0

    const/4 v2, -0x1

    if-ne v0, v2, :cond_0

    .line 171
    filled-new-array {v1}, [Ljava/lang/String;

    move-result-object v0

    const/16 v1, 0x64

    invoke-static {p0, v0, v1}, Landroid/support/v4/app/ActivityCompat;->requestPermissions(Landroid/app/Activity;[Ljava/lang/String;I)V

    .line 174
    :cond_0
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdncnn:Lcom/tencent/scrfdncnn/SCRFDNcnn;

    iget v1, p0, Lcom/tencent/scrfdncnn/MainActivity;->facing:I

    invoke-virtual {v0, v1}, Lcom/tencent/scrfdncnn/SCRFDNcnn;->openCamera(I)Z

    .line 175
    return-void
.end method

.method public surfaceChanged(Landroid/view/SurfaceHolder;III)V
    .locals 6
    .param p1, "holder"    # Landroid/view/SurfaceHolder;
    .param p2, "format"    # I
    .param p3, "width"    # I
    .param p4, "height"    # I

    .line 151
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdncnn:Lcom/tencent/scrfdncnn/SCRFDNcnn;

    invoke-interface {p1}, Landroid/view/SurfaceHolder;->getSurface()Landroid/view/Surface;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/tencent/scrfdncnn/SCRFDNcnn;->setOutputWindow(Landroid/view/Surface;)Z

    .line 153
    iput p3, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewWidth:I
    iput p4, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewHeight:I

    # ---- Wire: init FaceWarpEngine + createScrfdDetector + loadScrfdModel ----
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;
    if-eqz v0, :L_end_init_engine

    # init() returns native handle (old pipeline, still needed for warp)
    iget v1, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewWidth:I
    iget v2, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewHeight:I
    invoke-virtual {v0, v1, v2}, Lcom/yourcompany/app/FaceWarpEngine;->init(II)J
    move-result-wide v3
    invoke-virtual {v0, v3, v4}, Lcom/yourcompany/app/FaceWarpEngine;->setNativeHandle(J)V

    # ---- Create SCRFD detector (skip every 10th frame) ----
    iget-boolean v1, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdInitialized:Z
    if-nez v1, :L_already_init

    # createScrfdDetector(skipInterval=10) -> long handle
    # Registers: v0=engine, v1=skipInterval
    const/16 v1, 0xa
    invoke-virtual {v0, v1}, Lcom/yourcompany/app/FaceWarpEngine;->createScrfdDetector(I)J
    move-result-wide v1
    invoke-virtual {v0, v1, v2}, Lcom/yourcompany/app/FaceWarpEngine;->setScrfdHandle(J)V

    # ---- Load SCRFD model from assets ----
    # loadScrfdModel(long handle, AssetManager am, String param, String bin)
    # Need: instance + handle(long, 2 regs) + assetManager + paramPath + binPath = 6 regs
    # => invoke-virtual/range {v0 .. v5}
    #
    # v0 = faceWarpEngine (instance)
    # v1/v2 = scrfdHandle (long pair)
    # v3 = AssetManager
    # v4 = paramPath (String)
    # v5 = binPath (String)

    invoke-virtual {p0}, Lcom/tencent/scrfdncnn/MainActivity;->getAssets()Landroid/content/res/AssetManager;
    move-result-object v3

    iget-wide v1, p0, Lcom/yourcompany/app/FaceWarpEngine;->mScrfdHandle:J
    # v0 = engine (from earlier iget-object)
    # v1/v2 = scrfdHandle (long)
    # v3 = assetManager

    const-string v4, "scrfd_2.5g_bnkps_640x640.param"
    const-string v5, "scrfd_2.5g_bnkps_640x640.bin"

    invoke-virtual/range {v0 .. v5}, Lcom/yourcompany/app/FaceWarpEngine;->loadScrfdModel(JLandroid/content/res/AssetManager;Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    if-ltz v1, :L_already_init
    const/4 v1, 0x1
    iput-boolean v1, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdInitialized:Z

:L_already_init
:L_end_init_engine

    return-void
.end method

.method public surfaceCreated(Landroid/view/SurfaceHolder;)V
    .locals 0
    .param p1, "holder"    # Landroid/view/SurfaceHolder;

    .line 157
    return-void
.end method

.method public surfaceDestroyed(Landroid/view/SurfaceHolder;)V
    .locals 0
    .param p1, "holder"    # Landroid/view/SurfaceHolder;

    .line 162
    return-void
.end method

# ============================================================
# CAMERA PREVIEW CALLBACK HOOK — REWRITTEN
# Uses new detectFace() JNI instead of old SCRFDNcnn pipeline.
#
# Dalvik register layout for onPreviewFrame(byte[] data, Camera camera):
#   p0 = this           (Lcom/tencent/scrfdncnn/MainActivity;)
#   p1 = data           ([B  NV21 frame from camera hardware)
#   p2 = camera         (Landroid/hardware/Camera;)
# ============================================================

.method public onPreviewFrame([BLandroid/hardware/Camera;)V
    .locals 10
    .param p1, "data"    # [B
    .param p2, "camera"  # Landroid/hardware/Camera;

    .line 200

    # ------------------------------------------------------------------
    # Guard 1: warp pipeline not yet activated
    # ------------------------------------------------------------------
    iget-boolean v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->mWarpActive:Z
    if-nez v0, :end_method

    # ------------------------------------------------------------------
    # Guard 2: FaceWarpEngine instance must be valid
    # ------------------------------------------------------------------
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;
    if-eqz v0, :end_method

    # ------------------------------------------------------------------
    # Guard 3: native handle must be non-zero (positive)
    # ------------------------------------------------------------------
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;
    invoke-virtual {v0}, Lcom/yourcompany/app/FaceWarpEngine;->getNativeHandle()J
    move-result-wide v0
    const-wide/16 v2, 0x0L
    cmp-long v4, v0, v2
    if-nez v4, :L_handle_ok
    goto :end_method

:L_handle_ok
    # ------------------------------------------------------------------
    # Guard 4: SCRFD detector must be initialized
    # ------------------------------------------------------------------
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;
    invoke-virtual {v0}, Lcom/yourcompany/app/FaceWarpEngine;->getScrfdHandle()J
    move-result-wide v0
    const-wide/16 v2, 0x0L
    cmp-long v4, v0, v2
    if-nez v4, :L_scrfd_ok
    goto :end_method

:L_scrfd_ok
    # ------------------------------------------------------------------
    # Get camera dimensions from parameters
    # ------------------------------------------------------------------
    invoke-virtual {p2}, Landroid/hardware/Camera;->getParameters()Landroid/hardware/Camera$Parameters;
    move-result-object v0
    invoke-virtual {v0}, Landroid/hardware/Camera$Parameters;->getPreviewSize()Landroid/hardware/Camera$Size;
    move-result-object v0

    iget v1, v0, Landroid/hardware/Camera$Size;->width:I
    iput v1, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewWidth:I
    iget v0, v0, Landroid/hardware/Camera$Size;->height:I
    iput v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewHeight:I

    # ------------------------------------------------------------------
    # STEP 1: Convert NV21 to RGBA using native processFrame
    #
    # processFrame(byte[] nv21Data, byte[] rgbaData, byte[] outputBuffer)
    # invoke-virtual/range {v0, v1, v2, v3} where:
    #   v0 = faceWarpEngine (instance)
    #   v1 = nv21Data
    #   v2 = rgbaData
    #   v3 = outputBuffer (warpOutBuffer)
    #
    # v0 = p0 = this (already available)
    # We need v0 = faceWarpEngine. Use v5 for that.
    # ------------------------------------------------------------------

    iget v4, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewWidth:I
    iget v5, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewHeight:I
    mul-int v7, v4, v5
    mul-int/lit8 v9, v7, 0x4

    # Allocate RGBA buffer if needed
    iget-object v6, p0, Lcom/tencent/scrfdncnn/MainActivity;->rgbaBuffer:[B
    if-eqz v6, :L_alloc_rgba
    array-length v0, v6
    if-ge v0, v9, :L_run_convert

:L_alloc_rgba
    new-array v6, v9, [B
    iput-object v6, p0, Lcom/tencent/scrfdncnn/MainActivity;->rgbaBuffer:[B

:L_run_convert
    # Allocate warpOutBuffer if needed
    iget-object v8, p0, Lcom/tencent/scrfdncnn/MainActivity;->warpOutBuffer:[B
    if-eqz v8, :L_alloc_warp_out
    array-length v0, v8
    if-ge v0, v9, :L_do_convert

:L_alloc_warp_out
    new-array v8, v9, [B
    iput-object v8, p0, Lcom/tencent/scrfdncnn/MainActivity;->warpOutBuffer:[B

:L_do_convert
    # v5 = faceWarpEngine instance
    iget-object v5, p0, Lcom/tencent/scrfdncnn/MainActivity;->faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;
    # v6 = rgbaData (already set above)
    # v8 = warpOutBuffer
    # Need: invoke-virtual/range {v5, p1, v6, v8}
    # These are NOT contiguous. Map to contiguous range.
    #
    # Use v0-v3 as temporary contiguous mapping:
    #   v0 = v5 (faceWarpEngine)
    #   v1 = p1 (nv21Data)
    #   v2 = v6 (rgbaData)
    #   v3 = v8 (warpOutBuffer)
    move-object v0, v5
    move-object v1, p1
    move-object v2, v6
    move-object v3, v8

    invoke-virtual/range {v0 .. v3}, Lcom/yourcompany/app/FaceWarpEngine;->processFrame([B[B[B)I

    move-result v0

    # ------------------------------------------------------------------
    # STEP 2: Run detectFace(scrfdHandle, rgbaData, width, height) -> int
    #
    # Java sig: native int detectFace(long handle, byte[] rgbaData, int w, int h)
    #
    # Dalvik register layout:
    #   p0 = this
    #   p1 = nv21 data (original, now unused)
    #   p2 = camera (unused)
    #   v0..v9 = locals
    #
    # invoke-virtual/range requires contiguous registers.
    # We need: instance + long(2 regs) + byte[] + int + int = 6 regs
    #
    # Target register map:
    #   v0 = instance (faceWarpEngine)
    #   v1/v2 = scrfdHandle (long pair)
    #   v3 = rgbaData ([B])
    #   v4 = width (I)
    #   v5 = height (I)
    # ------------------------------------------------------------------

    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;
    invoke-virtual {v0}, Lcom/yourcompany/app/FaceWarpEngine;->getScrfdHandle()J
    move-result-wide v1

    # v0 = faceWarpEngine instance
    # v1/v2 = scrfdHandle (long pair, wide consumes v1 and v2)
    # v3 = rgbaData
    move-object v3, v6
    # v4 = width
    iget v4, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewWidth:I
    # v5 = height
    iget v5, p0, Lcom/tencent/scrfdncnn/MainActivity;->previewHeight:I

    invoke-virtual/range {v0 .. v5}, Lcom/yourcompany/app/FaceWarpEngine;->detectFace(J[BII)I

    move-result v0

    # ------------------------------------------------------------------
    # If detectFace returned >= 0 (face detected), run warp then push
    # ------------------------------------------------------------------
    if-ltz v0, :end_method

    # v0 = detectFace result (>= 0 means face found)
    # After detectFace, register state is clobbered — reload what we need:
    #   v5 = faceWarpEngine
    #   v6 = rgbaBuffer
    #   v8 = warpOutBuffer

    iget-object v5, p0, Lcom/tencent/scrfdncnn/MainActivity;->faceWarpEngine:Lcom/yourcompany/app/FaceWarpEngine;

    # ---- STEP 3: Call executeWarp(nativeHandle, rgbaData, rgbaBuffer, warpOutBuffer) ----
    # executeWarp signature: int executeWarp(long nativeHandle, byte[] rgbaData,
    #                                         byte[] srcBuffer, byte[] dstBuffer)
    # We need contiguous regs for invoke-virtual/range:
    #   v0 = scrfdncnn instance
    #   v1/v2 = mNativeHandle (long pair)
    #   v3 = rgbaBuffer (source face data)
    #   v4 = warpOutBuffer (destination)
    # Total = 5 contiguous registers: v0..v4

    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdncnn:Lcom/tencent/scrfdncnn/SCRFDNcnn;

    # Load the native handle from FaceWarpEngine (used as warp native handle)
    invoke-virtual {v5}, Lcom/yourcompany/app/FaceWarpEngine;->getNativeHandle()J
    move-result-wide v1

    # v3 = rgbaBuffer (source face region)
    move-object v3, v6

    # v4 = warpOutBuffer (destination)
    move-object v4, v8

    invoke-virtual/range {v0 .. v4}, Lcom/tencent/scrfdncnn/SCRFDNcnn;->executeWarp(J[B[B[B)I

    # ------------------------------------------------------------------
    # STEP 4: Push the warped frame buffer to display
    # ------------------------------------------------------------------
    iget-object v1, p0, Lcom/tencent/scrfdncnn/MainActivity;->warpOutBuffer:[B
    if-eqz v1, :end_method

    .line 210
    iget-object v2, p0, Lcom/tencent/scrfdncnn/MainActivity;->scrfdncnn:Lcom/tencent/scrfdncnn/SCRFDNcnn;
    iget-object v3, p0, Lcom/tencent/scrfdncnn/MainActivity;->warpOutBuffer:[B
    invoke-virtual {v2, v3}, Lcom/tencent/scrfdncnn/SCRFDNcnn;->pushFrameBuffer([B)V

    :end_method
    return-void
.end method
