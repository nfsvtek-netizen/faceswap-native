.class Lcom/tencent/scrfdncnn/MainActivity$1;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/tencent/scrfdncnn/MainActivity;->onCreate(Landroid/os/Bundle;)V
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

    .line 73
    iput-object p1, p0, Lcom/tencent/scrfdncnn/MainActivity$1;->this$0:Lcom/tencent/scrfdncnn/MainActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 2
    .param p1, "arg0"    # Landroid/view/View;

    .line 77
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity$1;->this$0:Lcom/tencent/scrfdncnn/MainActivity;

    invoke-static {v0}, Lcom/tencent/scrfdncnn/MainActivity;->access$000(Lcom/tencent/scrfdncnn/MainActivity;)I

    move-result v0

    rsub-int/lit8 v0, v0, 0x1

    .line 79
    .local v0, "new_facing":I
    iget-object v1, p0, Lcom/tencent/scrfdncnn/MainActivity$1;->this$0:Lcom/tencent/scrfdncnn/MainActivity;

    invoke-static {v1}, Lcom/tencent/scrfdncnn/MainActivity;->access$100(Lcom/tencent/scrfdncnn/MainActivity;)Lcom/tencent/scrfdncnn/SCRFDNcnn;

    move-result-object v1

    invoke-virtual {v1}, Lcom/tencent/scrfdncnn/SCRFDNcnn;->closeCamera()Z

    .line 81
    iget-object v1, p0, Lcom/tencent/scrfdncnn/MainActivity$1;->this$0:Lcom/tencent/scrfdncnn/MainActivity;

    invoke-static {v1}, Lcom/tencent/scrfdncnn/MainActivity;->access$100(Lcom/tencent/scrfdncnn/MainActivity;)Lcom/tencent/scrfdncnn/SCRFDNcnn;

    move-result-object v1

    invoke-virtual {v1, v0}, Lcom/tencent/scrfdncnn/SCRFDNcnn;->openCamera(I)Z

    .line 83
    iget-object v1, p0, Lcom/tencent/scrfdncnn/MainActivity$1;->this$0:Lcom/tencent/scrfdncnn/MainActivity;

    invoke-static {v1, v0}, Lcom/tencent/scrfdncnn/MainActivity;->access$002(Lcom/tencent/scrfdncnn/MainActivity;I)I

    .line 84
    return-void
.end method
