package entities
{
  import net.flashpunk.*;
  
  public class Detector extends AreaEntity
  {
    public var types:Array = ["player", "enemy"];
    public var colliding:Boolean = false;
    public var begin:Function;
    public var end:Function;
    
    public function Detector(x:int, y:int, width:uint, height:uint, begin:Function = null, end:Function = null)
    {
      super(x, y);
      setHitbox(width, height);
      type = "detector";
      this.begin = begin;
      this.end = end;
    }
    
    override public function update():void
    {
      var collision:Entity = collideTypes(types, x, y);
      if (!colliding && collision != null && begin != null) begin();
      if (colliding && collision == null && end != null) end();
      colliding = collision != null;
    }
  }
}
