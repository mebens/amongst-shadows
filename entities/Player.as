package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.utils.Input;
  
  public class Player extends PhysicalEntity
  {
    [Embed(source = "../assets/images/player.png")]
    public static const IMAGE:Class;
    
    public static const JUMP_SPEED:Number = -150;
    public static const FLOAT_GRAVITY:Number = 2;
    
    public var image:Image = new Image(IMAGE);
    public var lightVal:uint;
    
    public static function fromXML(o:Object):Player
    {
      return new Player(o.@x, o.@y);
    }
    
    public function Player(x:uint, y:uint)
    {
      super(x, y, image);
      type = "player";
      layer = 0;
      setHitbox(6, 10);
    }
    
    override public function update():void
    {
      // horizontal movement
      var xAxis:int = 0;
      if (Input.check("left")) xAxis--;
      if (Input.check("right")) xAxis++;
      moveDirection(xAxis);
      
      // jumping
      if (inAir)
      {
        gravityMultiplier = !inAir && Input.pressed("jump") ? FLOAT_GRAVITY : 1;
      }
      else if (Input.pressed("jump"))
      {
        vel.y = JUMP_SPEED;
      }
      
      // flip image
      if (xAxis != 0)
      {
        image.flipped = xAxis == -1;
        image.x = xAxis == -1 ? -2 : 0;
      }
      
      // set light value
      var color:uint = area.lighting.canvas.getPixel(x + width / 2, y + height / 2);
      lightVal = (FP.getRed(color) + FP.getGreen(color) + FP.getBlue(color)) / 3; // I'll use this method for now
      
      // do physics
      super.update();
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
