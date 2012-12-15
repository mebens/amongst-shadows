package entities
{
  import flash.display.BitmapData;
  import flash.display.BlendMode;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import net.flashpunk.*;
  import net.flashpunk.graphics.Image;
  
  public class Lighting extends AreaEntity
  {
    public var canvas:BitmapData;
    public var size:Rectangle;
    public var lights:Vector.<Light> = new Vector.<Light>;
    
    public function Lighting()
    {
      layer = -1;
      canvas = new BitmapData(FP.width, FP.height, false, 0x000000);
      size = new Rectangle(0, 0, FP.width, FP.height);
    }
    
    public function add(l:Light):void
    {
      lights.push(l);
    }
    
    public function remove(l:Light):void
    {
      for (var i:uint = 0; i < lights.length; i++)
      {
        if (lights[i] == l) lights.splice(i, 1);
      }
    }
    
    override public function render():void
    {
      super.render();
      canvas.fillRect(size, 0x000000);
      
      for (var i:uint; i < lights.length; i++)
      {
        var img:Image = lights[i].image;
        img.scale = lights[i].scale;
        img.alpha = lights[i].alpha;
        img.color = lights[i].color;
        img.render(canvas, lights[i].point, FP.camera);
      }
      
      var canvasImg:Image = new Image(canvas);
      canvasImg.blend = BlendMode.MULTIPLY;
      canvasImg.render(FP.buffer, FP.camera, FP.camera);
    }
  }
}
