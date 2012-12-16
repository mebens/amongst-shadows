package entities
{
  import net.flashpunk.*;
  import worlds.Area;
  
  public class AreaEntity extends Entity
  {
    public function AreaEntity(x:int = 0, y:int = 0, graphic:Graphic = null)
    {
      super(x, y, graphic);
    }
    
    public function getVariation(amount:Number, variation:Number):Number
    {
      return amount - variation + variation * 2 * FP.random;
    }
    
    public function get area():Area
    {
      return world as Area;
    }
    
    public function get sfxVolume():Number
    {
      return FP.scale(FP.distance(area.player.x, area.player.y, x, y) / 150, 0, 1, 1, 0);
    }
  }
}
