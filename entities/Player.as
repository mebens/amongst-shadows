package entities
{
  import flash.geom.Point;
  import net.flashpunk.*;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.utils.Input;
  
  public class Player extends AreaEntity
  {
    [Embed(source = "../assets/images/player.png")]
    public static const IMAGE:Class;
    
    public static const ACCELERATION:Number = 1200;
    public static const FRICTION:Number = 0.82;
    
    public var image:Image = new Image(IMAGE);
    public var vel:Point = new Point;
    
    public function Player(x:uint, y:uint)
    {
      super(x, y, image);
      setHitbox(image.width, image.height);
    }
    
    override public function update():void
    {
      var angle:Number = getDirection();
      
      if (angle != -1)
      {
        vel.x += ACCELERATION * Math.cos(angle) * FP.elapsed;
        vel.y += ACCELERATION * Math.sin(angle) * FP.elapsed;
      }
      
      vel.x *= FRICTION;
      vel.y *= FRICTION;
      moveBy(vel.x * FP.elapsed, vel.y * FP.elapsed, "solid");
      
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
    
    public function getDirection():Number
    {
      var xAxis:int = 0;
      var yAxis:int = 0;
      
      if (Input.check("left")) xAxis--;
      if (Input.check("right")) xAxis++;
      if (Input.check("up")) yAxis--;
      if (Input.check("down")) yAxis++;
      
      var xAngle:Number = xAxis == 1 ? 0 : (xAxis == -1 ? Math.PI : -1);
      var yAngle:Number = yAxis == 1 ? Math.PI / 2 : (yAxis == -1 ? Math.PI * 1.5 : -1);
      
      if (xAngle != -1 && yAngle != -1)
      {
        if (xAxis == 1 && yAxis == -1) return yAngle + Math.PI / 4;
        return (xAngle + yAngle) / 2;
      }
      else
      {
        if (xAngle != -1) return xAngle;
        return yAngle;
      }
    }
  }
}
