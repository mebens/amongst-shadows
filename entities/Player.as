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
    
    public static const ACCELERATION:Number = 1000;
    public static const JUMP_SPEED:Number = -150;
    public static const FLOAT_GRAVITY:Number = 2.5;
    
    public var image:Image = new Image(IMAGE);
    public var vel:Point = new Point;
    public var inAir:Boolean;
    
    public function Player(x:uint, y:uint)
    {
      super(x, y, image);
      type = "player";
      layer = 0;
      setHitbox(6, 10);
    }
    
    override public function update():void
    {
      var xAxis:int = 0;
      var platform:Entity = collide("solid", x, y + 1);
      inAir = platform == null;
      
      if (inAir)
      {
        var factor:Number = vel.y < 0 && !Input.check("jump") ? FLOAT_GRAVITY : 1;
        vel.y += Game.GRAVITY * factor * FP.elapsed;
      }
      else if (Input.pressed("jump"))
      {
        vel.y = JUMP_SPEED;
      }
            
      if (Input.check("left")) xAxis--;
      if (Input.check("right")) xAxis++;
            
      vel.x += ACCELERATION * xAxis * FP.elapsed;
      vel.x *= Game.FRICTION;
      moveBy(vel.x * FP.elapsed, vel.y * FP.elapsed, "solid");
      
      // not completely sure if this helps, but it doesn't hurt
      x = Math.round(x);
      y = Math.round(y);
      
      if (x < 0)
      {
        x = 0;
      }
      else if (x > area.width - width)
      {
        x = area.width - width;
      }
      
      if (xAxis != 0)
      {
        image.flipped = xAxis == -1;
        image.x = xAxis == -1 ? -2 : 0;
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
    
    /* 8-axis movement
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
    */
  }
}
