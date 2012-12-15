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
    public var health:int = 100;
    public var lightVal:uint;
    public var facing:int;
    
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
        facing = xAxis;
      }
      
      // set light value
      var color:uint = area.lighting.canvas.getPixel(x + width / 2, y + height / 2);
      lightVal = (FP.getRed(color) + FP.getGreen(color) + FP.getBlue(color)) / 3; // I'll use this method for now
      
      super.update();
    }
    
    public function die():void
    {
      FP.log("Dead. No big surprise.");
    }
    
    public function bulletHit():void
    {
      health -= 10;
      if (health <= 0) die();
      FP.log(health);
    }
    
    public function backstabAvailable(g:Guard):void
    {
      if (FP.sign(g.x - x) == facing && Input.pressed("backstab")) g.backstabbed();
    }
  }
}
