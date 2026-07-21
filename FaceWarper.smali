.class public Lcom/tencent/scrfdncnn/FaceWarper;
.super Ljava/lang/Object;

.method public static drawOverlay(Landroid/graphics/Canvas;II)V
    .locals 3
    .param p0, "canvas"    # Landroid/graphics/Canvas;
    .param p1, "width"    # I
    .param p2, "height"    # I

    if-eqz p0, :return
    if-lez p1, :return
    if-lez p2, :return

    new-instance v0, Landroid/graphics/Paint;
    invoke-direct {v0}, Landroid/graphics/Paint;-><init>()V

    const/high16 v1, 0x22ff0000
    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setColor(I)V
    invoke-virtual {p0, v0}, Landroid/graphics/Canvas;->drawColor(I)V

    :return
    return-void
.end method
