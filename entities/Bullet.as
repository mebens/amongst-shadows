package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Image;
  
  public class Bullet extends AreaEntity
  {
    [Embed(source = "../assets/images/bullet.png")]
    public static const IMAGE:Class;
    
    public static const SPEED:Number = 600;
    public static const SPEED_VARIATION:Number = 100;
    public static const PRECISION:uint = 10;
    
    public var image:Image = new Image(IMAGE);
    public var direction:int;
    public var speed:Number;
    public var types:Array;
    
    public function Bullet(x:uint, y:uint, dir:int, spread:Number = 2, enemy:Boolean = true)
    {
      super(x, getVariation(y, spread), image);
      type = "bullet";
      layer = 3;
      setHitbox(image.width, image.height, image.width / 2, image.height / 2);
      image.centerOrigin();
      direction = dir;
      image.flipped = dir == -1;
      speed = getVariation(SPEED, SPEED_VARIATION);
      types = ["solid", enemy ? "player" : "enemy"];
    }
    
    override public function update():void
    {
      if (x < -width || x > area.width) die();
      var amount:Number = SPEED * direction * FP.elapsed;
      
      while (amount > PRECISION)
      {
        x += PRECISION;
        amount -= PRECISION;
        if (checkCollision()) return;
      }
      
      x += amount;
      checkCollision();
    }
    
    public function checkCollision():Boolean
    {
      var collision:Entity = collideTypes(types, x, y);
      
      if (collision)
      {
        if (collision.type == "player")
        {
          Player(collision).bulletHit();
        }
        else if (collision.type == "enemy")
        {
          Guard(collision).bulletHit();
        }
        
        die();
        return true;
      }
      
      return false;
    }
    
    public function die():void
    {
      area.remove(this);
    }
    
    public function getVariation(amount:Number, variation:Number):Number
    {
      return amount - variation + variation * 2 * FP.random;
    }
  }
}
