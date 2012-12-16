package
{
  import flash.geom.Point;
  import net.flashpunk.*;
  import net.flashpunk.graphics.Image;
  
  public class Light
  {
    [Embed(source = "assets/images/light.png")]
    public static const IMAGE:Class;
    
    public static var defaultImage:Image = new Image(IMAGE);
    
    public var color:uint = 0xFFFFFF;
    public var scale:Number = 1;
    public var alpha:Number = 1;
    public var image:Image;
    public var dir:int = 1;
    
    private var _x:int = 0;
    private var _y:int = 0;
    private var _point:Point;
    
    public static function fromXML(o:Object):Light
    {
      return new Light(o.@x - 4.5, o.@y - 4.5, uint("0x" + o.@color), o.@scaleX, o.@scaleY);
    }
    
    public function Light(x:int, y:int, color:uint = 0xFFFFFF, scaleX:Number = 1, scaleY:Number = 1, alpha:Number = 1, image:Image = null)
    {
      _x = x;
      _y = y;
      _point = new Point(x, y);
      this.color = color;
      this.scale = scale;
      this.alpha = alpha;
      this.image = image || defaultImage;
      this.image.centerOrigin();
      fluctuate();
    }
    
    public function fluctuate():void
    {
      dir = dir == 1 ? -1 : 1;
      if (alpha <= 0.8) dir = 1;
      if (alpha >= 1) dir = -1;
      FP.tween(this, { alpha: alpha + 0.2 * FP.random * dir }, 0.05 + 0.1 * FP.random, fluctuate);
    }
    
    public function get x():int
    {
      return _x;
    }
    
    public function set x(value:int):void
    {
      _x = _point.x = value;
    }
    
    public function get y():int
    {
      return _y;
    }
    
    public function set y(value:int):void
    {
      _y = _point.y = value;
    }
    
    public function get point():Point
    {
      return _point;
    }
  }
}
