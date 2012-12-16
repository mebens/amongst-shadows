package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Spritemap;
  import net.flashpunk.utils.Input;
  
  public class Player extends PhysicalEntity
  {
    [Embed(source = "../assets/images/player.png")]
    public static const IMAGE:Class;
    
    [Embed(source = "../assets/sfx/backstab.mp3")]
    public static const BACKSTAB:Class;
    
    [Embed(source = "../assets/sfx/player-hit.mp3")]
    public static const HIT_1:Class;

    [Embed(source = "../assets/sfx/player-hit-2.mp3")]
    public static const HIT_2:Class;
    
    public static const JUMP_SPEED:Number = -150;
    public static const FLOAT_GRAVITY:Number = 2;
    public static const BACKSTAB_TIME:Number = 0.6;
    public static const RUN_FPS:Number = 12;
    
    public var map:Spritemap;
    public var canMove:Boolean = true;
    public var backstabbing:Boolean = false;
    public var health:int = 100;
    public var lightVal:uint;
    public var facing:int;
    public var backstabTimer:Number = 0;
    public var runTimer:Number = 1 / RUN_FPS * 2;
    
    public var backstabSfx:Sfx = new Sfx(BACKSTAB);
    public var hitSfx1:Sfx = new Sfx(HIT_1);
    public var hitSfx2:Sfx = new Sfx(HIT_2);
    public var footstepSfx1:Sfx = new Sfx(Game.FOOTSTEP_1);
    public var footstepSfx2:Sfx = new Sfx(Game.FOOTSTEP_2);
    public var footstepSfx3:Sfx = new Sfx(Game.FOOTSTEP_3);
    public var landSfx1:Sfx = new Sfx(Game.LAND_1);
    public var landSfx2:Sfx = new Sfx(Game.LAND_2);
    
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
      map.add("run", [1, 2, 3, 4], RUN_FPS);
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
          
          if (runTimer <= 0)
          {
            var sfx:Sfx = FP.choose(footstepSfx1, footstepSfx2, footstepSfx3);
            sfx.play();
            runTimer = 1 / RUN_FPS * 2;
          }
          else
          {
            runTimer -= FP.elapsed;
          }
        }
        else
        {
          map.play("stand");
        }
      }
        
      // set light value
      var color:uint = area.lighting.canvas.getPixel(x + width / 2 - FP.camera.x, y + height / 2 - FP.camera.y);
      lightVal = (FP.getRed(color) + FP.getGreen(color) + FP.getBlue(color)) / 3; // I'll use this method for now
      
      // backstab
      if (backstabTimer > 0)
      {
        backstabTimer -= FP.elapsed;
      }
      else if (Input.pressed("backstab"))
      {
        if (Guard.backstab != null)
        {
          Guard.backstab.backstabbed();
          backstabSfx.play();
        }
        
        canMove = false;
        backstabbing = true;
        backstabTimer += BACKSTAB_TIME;
        map.play("backstab");
      }
      
      super.update();
    }
    
    override public function moveCollideY(e:Entity):Boolean
    {
      if (vel.y > 0)
      {
        var sfx:Sfx = FP.choose(landSfx1, landSfx2);
        sfx.play();
      }
      
      return super.moveCollideY(e);
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
      
      var sfx:Sfx = FP.choose(hitSfx1, hitSfx2);
      sfx.play();
      area.redScreen.flash();
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
