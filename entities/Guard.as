package entities
{
  import flash.geom.Point;
  import net.flashpunk.*;
  import net.flashpunk.graphics.Image;
  
  public class Guard extends PhysicalEntity
  {
    [Embed(source = "../assets/images/guard.png")]
    public static const IMAGE:Class;
    
    public static const VISION_RANGE:uint = 250;
    public static const FOV:uint = 90;
    public static const AWARE_DRAIN:Number = 10;
    public static const ALERT_TIME:Number = 30;
    public static const FIRE_RATE:Number = 0.1;
    
    public static const NORMAL_ACCEL:Number = 300;
    public static const ALERT_ACCEL:Number = 700;
    public static const JUMP_SPEED:Number = -120;
    
    public static var lastKnownX:uint;
    public static var backstab:Guard;
    
    public var image:Image = new Image(IMAGE);
    public var nodes:Vector.<Point> = new Vector.<Point>;
    
    public var awareness:uint = 0;
    public var alert:Boolean = false;
    public var inView:Boolean = false;
    public var alertTimer:Number = 0;
    public var gunTimer:Number = 0;
    public var facing:int = 1;
    
    public var movingTo:uint;
    public var movingCallback:Function;
    
    public var health:uint = 3;
    public var current:uint = 0;
    public var moving:Boolean = false;
    public var waitTimer:Number = 0;
    public var waitMin:Number;
    public var waitMax:Number;
    
    public static function fromXML(o:Object):Guard
    {
      var g:Guard = new Guard(o.@x, o.@y, o.@waitMin, o.@waitMax);
      for each (var n:Object in o.node) g.addNode(n.@x, n.@y);
      return g;
    }
    
    public function Guard(x:uint, y:uint, waitMin:Number, waitMax:Number)
    {
      super(x, y, image);
      type = "enemy";
      layer = 1;
      acceleration = NORMAL_ACCEL;
      this.waitMin = waitMin;
      this.waitMax = waitMax;
      setHitbox(7, 10);
      addNode(x, y);
      setWaitTimer();
    }
    
    override public function update():void
    {
      handleMovement();
      handleAwareness();
      handleReaction();
      checkBackstab();
      super.update();
    }
    
    public function handleMovement():void
    {
      if (alert) return;
      
      if (moving)
      {
        var p:Point = nodes[current];
        
        if (x == p.x)
        {
          moving = false;
          setWaitTimer();
        }
        else
        {
          moveDirection(FP.sign(p.x - x));
        }
      }
      else if (waitTimer > 0)
      {
        waitTimer -= FP.elapsed;
      }
      else
      {
        current = (current + 1) % nodes.length;
        moving = true;
      }
    }
    
    public function handleAwareness():void
    {
      var dist:Number = playerRange();
      var lightVal:uint = area.player.lightVal;
      
      if (dist != -1 && lightVal > 70)
      {
        var lightRate:Number = lightVal < 90 ? 0.2 : (lightVal < 110 ? 0.7 : 1);
        awareness += 1000 * getDistRate(dist) * lightRate * FP.elapsed;
        inView = true;
        lastKnownX = area.player.x;
        
        if (awareness >= 100)
        {
          alertTimer = ALERT_TIME;
          
          if (!alert)
          {
            alert = true;
            acceleration = ALERT_ACCEL;
          }
        }
      }
      else
      {
        inView = false;
        
        if (alert)
        {
          if (alertTimer > 0)
          {
            alertTimer -= FP.elapsed;
          }
          else
          {
            alert = false;
            awareness = 0;
            acceleration = NORMAL_ACCEL;
          }
        }
        else
        {
          awareness -= AWARE_DRAIN * FP.elapsed;
        }
      }
      
      awareness = FP.clamp(awareness, 0, 100);
    }
    
    public function handleReaction():void
    {
      if (alert)
      {
        if (inView)
        {
          moveDirection(FP.sign(area.player.x - x));
          
          if (Math.abs(area.player.y - y) < 20 && gunTimer <= 0)
          {
            area.add(new Bullet(x + 2 * facing, y + 5, facing));
            gunTimer += FIRE_RATE;
          }
        }
        else
        {
          moveDirection(FP.sign(lastKnownX - x));
        }
      }
      
      if (gunTimer > 0) gunTimer -= FP.elapsed;
    }
    
    public function checkBackstab():void
    {
      var p:Player = area.player;
      
      if (backstab == null || backstab == this)
      {
        var b:Boolean = !inView && FP.sign(x - p.x) == p.facing && FP.distance(x, y, p.x, p.y) < 10;
        
        if (backstab == this && !b)
        {
          backstab = null;
        }
        else if (b)
        {
          backstab = this;
        }
      }
    }
    
    override public function moveCollideX(e:Entity):Boolean
    {
      vel.x = 0;
      vel.y = JUMP_SPEED; // try to jump over this obstacle
      return true;
    }
    
    override public function moveDirection(dir:int, callback:Function = null):void
    {
      super.moveDirection(dir);
      
      if (dir != 0)
      {
        image.flipped = dir == -1;
        image.x = dir == -1 ? -2 : 0;
        facing = dir;
      }
    }
    
    public function moveTo(x:uint, callback:Function = null):void
    {
      movingTo = x;
      movingCallback = callback;
    }
    
    public function die():void
    {
      area.remove(this);
    }
    
    public function backstabbed():void
    {
      die();
      backstab = null;
    }
    
    public function bulletHit():void
    {
      if (--health == 0) die();
    }
    
    public function playerRange():Number
    {
      var player:Player = area.player;
      var distance:Number = FP.distance(x, y, player.x, player.y);
      if (distance > VISION_RANGE) return -1;
      
      var angle:Number = FP.angle(x, y, player.x, player.y);
      var lookingAngle:Number = facing == 1 ? 0 : 180;
      var withinFOV:Boolean = angle > lookingAngle - (FOV / 2) && angle < lookingAngle + (FOV / 2);
      
      if (!withinFOV) return -1;
      if (!area.collideLine("solid", x, y, player.x, player.y)) return distance;
      return -1;
    }
    
    public function getDistRate(dist:Number):Number
    {
      if (dist > 180)
      {
        return 0.05;
      }
      else if (dist > 120)
      {
        return 0.2;
      }
      else if (dist > 80)
      {
        return 0.5;
      }
      else
      {
        return 1;
      }
    }
    
    public function addNode(x:uint, y:uint):void
    {
      nodes.push(new Point(x, y));
    }
    
    public function setWaitTimer():void
    {
      waitTimer = waitMin + (waitMax - waitMin) * FP.random;
    }
  }
}
