package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Spritemap;
  import net.flashpunk.utils.Input;
  
  public class Player extends PhysicalEntity
  {
    [Embed(source = "../assets/images/player.png")]
    public static const IMAGE:Class;
    
    public static const JUMP_SPEED:Number = -150;
    public static const FLOAT_GRAVITY:Number = 2;
    public static const BACKSTAB_TIME:Number = 0.6;
    
    public var map:Spritemap;
    public var canMove:Boolean = true;
    public var backstabbing:Boolean = false;
    public var health:int = 100;
    public var lightVal:uint;
    public var facing:int;
    public var backstabTimer:Number = 0;
    
    public static function fromXML(o:Object):Player
    {
      return new Player(o.@x, o.@y);
    }
    
    public function Player(x:uint, y:uint)
    {
      super(x, y);
      type = "player";
      layer = 0;
      graphic = map = new Spritemap(IMAGE, 7, 10, mapComplete);
      setHitbox(5, 10);
      
      map.add("stand", [0], 1);
      map.add("run", [1, 2, 3, 4], 12);
      map.add("backstab", [7, 8, 9, 7, 6, 5], 25, false);
      map.play("stand");
    }
    
    override public function update():void
    {
      // horizontal movement
      var xAxis:int = 0;
      
      if (canMove)
      {
        if (Input.check("left")) xAxis--;
        if (Input.check("right")) xAxis++;
        moveDirection(xAxis);
      }
      
      // jumping
      if (inAir)
      {
        gravityMultiplier = !inAir && Input.pressed("jump") ? FLOAT_GRAVITY : 1;
      }
      else if (Input.pressed("jump") && canMove)
      {
        vel.y = JUMP_SPEED;
      }
      
      // flip map
      if (xAxis != 0)
      {
        map.flipped = xAxis == -1;
        map.x = xAxis == -1 ? -2 : 0;
        facing = xAxis;
      }
      
      // play animation
      if (!backstabbing)
      {
        if (xAxis != 0)
        {
          map.play("run");
        }
        else
        {
          map.play("stand");
        }
      }
        
      // set light value
      var color:uint = area.lighting.canvas.getPixel(x + width / 2 - FP.camera.x, y + height / 2 - FP.camera.y);
      lightVal = (FP.getRed(color) + FP.getGreen(color) + FP.getBlue(color)) / 3; // I'll use this method for now
      FP.log(lightVal, FP.getRed(color), FP.getGreen(color), FP.getBlue(color));
      
      // backstab
      if (backstabTimer > 0)
      {
        backstabTimer -= FP.elapsed;
      }
      else if (Input.pressed("backstab"))
      {
        if (Guard.backstab != null) Guard.backstab.backstabbed();
        canMove = false;
        backstabbing = true;
        backstabTimer += BACKSTAB_TIME;
        map.play("backstab");
      }
      
      super.update();
    }
    
    public function die():void
    {
      area.sendMessage("player.die");
      canMove = false;
    }
    
    public function bulletHit():void
    {
      health = Math.max(health - 20, 0);
      if (health <= 0) die();
    }
    
    public function backstabAvailable(g:Guard):void
    {
      if (FP.sign(g.x - x) == facing && Input.pressed("backstab")) g.backstabbed();
    }
    
    public function mapComplete():void
    {
      if (backstabbing)
      {
        canMove = true;
        backstabbing = false;
      }
    }
  }
}
