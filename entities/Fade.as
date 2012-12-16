package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Image;
  
  public class Fade extends AreaEntity
  {
    public var image:Image;
    
    public function Fade(out:Boolean = false)
    {
      layer = -3;
      graphic = image = Image.createRect(FP.width, FP.height, 0x000000);
      image.scrollX = image.scrollY = 0;
      image.alpha = out ? 0 : 1;
    }
    
    public function fadeOut(duration:Number = 0.25, complete:Function = null):void
    {
      FP.tween(image, { alpha: 1 }, duration, { tweener: this, complete: complete });
    }
    
    public function fadeIn(duration:Number = 0.25, complete:Function = null):void
    {
      FP.tween(image, { alpha: 0 }, duration, { tweener: this, complete: complete });
    }
  }
}
