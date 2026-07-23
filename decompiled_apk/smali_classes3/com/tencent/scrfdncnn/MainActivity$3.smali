.class Lcom/tencent/scrfdncnn/MainActivity$3;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Landroid/widget/AdapterView$OnItemSelectedListener;


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

    .line 106
    iput-object p1, p0, Lcom/tencent/scrfdncnn/MainActivity$3;->this$0:Lcom/tencent/scrfdncnn/MainActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onItemSelected(Landroid/widget/AdapterView;Landroid/view/View;IJ)V
    .locals 1
    .param p2, "arg1"    # Landroid/view/View;
    .param p3, "position"    # I
    .param p4, "id"    # J
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/widget/AdapterView<",
            "*>;",
            "Landroid/view/View;",
            "IJ)V"
        }
    .end annotation

    .line 110
    .local p1, "arg0":Landroid/widget/AdapterView;, "Landroid/widget/AdapterView<*>;"
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity$3;->this$0:Lcom/tencent/scrfdncnn/MainActivity;

    invoke-static {v0}, Lcom/tencent/scrfdncnn/MainActivity;->access$400(Lcom/tencent/scrfdncnn/MainActivity;)I

    move-result v0

    if-eq p3, v0, :cond_0

    .line 112
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity$3;->this$0:Lcom/tencent/scrfdncnn/MainActivity;

    invoke-static {v0, p3}, Lcom/tencent/scrfdncnn/MainActivity;->access$402(Lcom/tencent/scrfdncnn/MainActivity;I)I

    .line 113
    iget-object v0, p0, Lcom/tencent/scrfdncnn/MainActivity$3;->this$0:Lcom/tencent/scrfdncnn/MainActivity;

    invoke-static {v0}, Lcom/tencent/scrfdncnn/MainActivity;->access$300(Lcom/tencent/scrfdncnn/MainActivity;)V

    .line 115
    :cond_0
    return-void
.end method

.method public onNothingSelected(Landroid/widget/AdapterView;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/widget/AdapterView<",
            "*>;)V"
        }
    .end annotation

    .line 120
    .local p1, "arg0":Landroid/widget/AdapterView;, "Landroid/widget/AdapterView<*>;"
    return-void
.end method
