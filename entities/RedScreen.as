package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Image;
  
  public class RedScreen extends AreaEntity
  {
    public var image:Image;
    public var tween:Tween;
    
    public function RedScreen()
    {
      layer = -3;
      graphic = image = Image.createRect(FP.width, FP.height, 0xFF0000);
      image.scrollX = image.scrollY = 0;
      image.alpha = 0;
    }
    
    public function flash():void
    {
      if (tween && tween.active) tween.cancel();
      tween = FP.tween(image, { alpha: 0.25 }, 0.1, { complete: function():void {
        tween = FP.tween(image, { alpha: 0 }, 0.1);
      } });
    }
  }
}
