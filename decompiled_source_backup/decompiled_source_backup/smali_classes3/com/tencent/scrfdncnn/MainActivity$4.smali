.class Lcom/tencent/scrfdncnn/MainActivity$4;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/tencent/scrfdncnn/MainActivity;->reload()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/tencent/scrfdncnn/MainActivity;


# direct methods
.method constructor <init>(Lcom/tencent/scrfdncnn/MainActivity;)V
    .locals 0
    .param p1, "this$0"    # Lcom/tencent/scrfdncnn/MainActivity;

    .line 130
    iput-object p1, p0, Lcom/tencent/scrfdncnn/MainActivity$4;->this$0:Lcom/tencent/scrfdncnn/MainActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .line 133
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity$4;->this$0:Lcom/tencent/scrfdncnn/MainActivity;

    invoke-static {v0}, Lcom/tencent/scrfdncnn/MainActivity;->access$100(Lcom/tencent/scrfdncnn/MainActivity;)Lcom/tencent/scrfdncnn/SCRFDNcnn;

    move-result-object v0

    iget-object v1, p0, Lcom/tencent/scrfdncnn/MainActivity$4;->this$0:Lcom/tencent/scrfdncnn/MainActivity;

    invoke-virtual {v1}, Lcom/tencent/scrfdncnn/MainActivity;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v1

    iget-object v2, p0, Lcom/tencent/scrfdncnn/MainActivity$4;->this$0:Lcom/tencent/scrfdncnn/MainActivity;

    invoke-static {v2}, Lcom/tencent/scrfdncnn/MainActivity;->access$200(Lcom/tencent/scrfdncnn/MainActivity;)I

    move-result v2

    iget-object v3, p0, Lcom/tencent/scrfdncnn/MainActivity$4;->this$0:Lcom/tencent/scrfdncnn/MainActivity;

    invoke-static {v3}, Lcom/tencent/scrfdncnn/MainActivity;->access$400(Lcom/tencent/scrfdncnn/MainActivity;)I

    move-result v3

    invoke-virtual {v0, v1, v2, v3}, Lcom/tencent/scrfdncnn/SCRFDNcnn;->loadModel(Landroid/content/res/AssetManager;II)Z

    move-result v0

    .line 134
    .local v0, "ret_init":Z
    iget-object v1, p0, Lcom/tencent/scrfdncnn/MainActivity$4;->this$0:Lcom/tencent/scrfdncnn/MainActivity;

    new-instance v2, Lcom/tencent/scrfdncnn/MainActivity$4$1;

    invoke-direct {v2, p0, v0}, Lcom/tencent/scrfdncnn/MainActivity$4$1;-><init>(Lcom/tencent/scrfdncnn/MainActivity$4;Z)V

    invoke-virtual {v1, v2}, Lcom/tencent/scrfdncnn/MainActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 144
    return-void
.end method
