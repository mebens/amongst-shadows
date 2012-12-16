package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Image;
  
  public class Door extends AreaEntity
  {
    [Embed(source = "../assets/images/door.png")]
    public static const IMAGE:Class;
    
    public var image:Image = new Image(IMAGE);
    public var baseY:uint;
    public var tween:Tween;
    public var detector:Detector;
    
    public static function fromXML(o:Object):Door
    {
      return new Door(o.@x, o.@y);
    }
    
    public function Door(x:uint, y:uint)
    {
      super(x, baseY = y, image);
      type = "solid";
      setHitbox(image.width, image.height);
      detector = new Detector(x - width * 2, y, width * 4, height, open, close);
    }
    
    override public function added():void
    {
      area.add(detector);
    }
    
    public function open():void
    {
      if (tween && tween.active) tween.cancel();
      tween = FP.tween(this, { y: baseY - height }, 0.2, { tweener: this });
    }
    
    public function close():void
    {
      if (tween && tween.active) tween.cancel();
      tween = FP.tween(this, { y: baseY }, 0.2, { tweener: this });
    }
  }
}
