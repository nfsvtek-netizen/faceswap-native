.class Lcom/tencent/scrfdncnn/MainActivity$4$1;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/tencent/scrfdncnn/MainActivity$4;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lcom/tencent/scrfdncnn/MainActivity$4;

.field final synthetic val$ret_init:Z


# direct methods
.method constructor <init>(Lcom/tencent/scrfdncnn/MainActivity$4;Z)V
    .locals 0
    .param p1, "this$1"    # Lcom/tencent/scrfdncnn/MainActivity$4;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 134
    iput-object p1, p0, Lcom/tencent/scrfdncnn/MainActivity$4$1;->this$1:Lcom/tencent/scrfdncnn/MainActivity$4;

    iput-boolean p2, p0, Lcom/tencent/scrfdncnn/MainActivity$4$1;->val$ret_init:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .line 137
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity$4$1;->this$1:Lcom/tencent/scrfdncnn/MainActivity$4;

    iget-object v0, v0, Lcom/tencent/scrfdncnn/MainActivity$4;->this$0:Lcom/tencent/scrfdncnn/MainActivity;

    invoke-static {v0}, Lcom/tencent/scrfdncnn/MainActivity;->access$500(Lcom/tencent/scrfdncnn/MainActivity;)Landroid/widget/TextView;

    move-result-object v0

    iget-boolean v1, p0, Lcom/tencent/scrfdncnn/MainActivity$4$1;->val$ret_init:Z

    if-eqz v1, :cond_0

    const/16 v1, 0x8

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    :goto_0
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 138
    iget-boolean v0, p0, Lcom/tencent/scrfdncnn/MainActivity$4$1;->val$ret_init:Z

    if-nez v0, :cond_1

    .line 140
    const-string v0, "MainActivity"

    const-string v1, "scrfdncnn loadModel failed"

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 142
    :cond_1
    return-void
.end method
