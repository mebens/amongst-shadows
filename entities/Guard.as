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
    
    public var image:Image = new Image(IMAGE);
    public var nodes:Vector.<Point> = new Vector.<Point>;
    
    public var awareness:uint = 0;
    public var alert:Boolean = false;
    public var alertTimer:Number = 0;
    public var facing:int = 1;
    
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
      setHitbox(7, 10);
      acceleration = 300;
      this.waitMin = waitMin;
      this.waitMax = waitMax;
      addNode(x, y);
      setWaitTimer();
    }
    
    override public function update():void
    {
      // movement
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
          var axis:int = FP.sign(p.x - x);
          moveDirection(axis);
          
          if (axis != 0)
          {
            image.flipped = axis == -1;
            image.x = axis == -1 ? -2 : 0;
            facing = axis;
          }
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
      
      // awareness/alert
      var dist:Number = playerRange();
      var lightVal:uint = area.player.lightVal;

      if (dist != -1 && lightVal > 70)
      {
        var lightRate:Number = lightVal < 90 ? 0.2 : (lightVal < 110 ? 0.7 : 1);
        awareness += 1000 * getDistRate(dist) * lightRate * FP.elapsed;
        
        if (awareness >= 100)
        {
          alert = true;
          alertTimer = ALERT_TIME;
        }
      }
      else if (alert)
      {
        if (alertTimer > 0)
        {
          alertTimer -= FP.elapsed;
        }
        else
        {
          alert = false;
          awareness = 0;
        }
      }
      else
      {
        awareness -= AWARE_DRAIN * FP.elapsed;
      }
      
      awareness = FP.clamp(awareness, 0, 100);
      FP.log(awareness, lightVal);
      super.update();
    }
    
    public function addNode(x:uint, y:uint):void
    {
      nodes.push(new Point(x, y));
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
    
    public function setWaitTimer():void
    {
      waitTimer = waitMin + (waitMax - waitMin) * FP.random;
    }
    
  }
}
