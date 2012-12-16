package entities
{
  import flash.geom.Point;
  import net.flashpunk.*;
  
  public class PhysicalEntity extends AreaEntity
  {
    public var vel:Point = new Point;
    public var acceleration:Number = 900;
    public var friction:Number = 0.83;
    public var gravityMultiplier:Number = 1;
    public var inAir:Boolean;
    
    public function PhysicalEntity(x:int, y:int, graphic:Graphic = null)
    {
      super(x, y, graphic);
    }
    
    override public function update():void
    {
      // gravity
      inAir = collide("solid", x, y + 1) == null;
      if (inAir) vel.y += Game.GRAVITY * gravityMultiplier * FP.elapsed;
      
      // movement application
      vel.x *= friction;
      moveBy(vel.x * FP.elapsed, vel.y * FP.elapsed, "solid");
      
      // round position; not completely sure if this helps, but it doesn't hurt
      x = Math.round(x);
      y = Math.round(y);
      
      // clamp x position
      if (x < 0)
      {
        x = 0;
      }
      else if (x > area.width - width)
      {
        x = area.width - width;
      }
    }
    
    override public function moveCollideX(e:Entity):Boolean
    {
      vel.x = 0;
      return true;
    }
    
    override public function moveCollideY(e:Entity):Boolean
    {
      vel.y = 0;
      return true;
    }
    
    public function moveDirection(dir:int):void
    {
      vel.x += acceleration * dir * FP.elapsed;
    }
  }
}
