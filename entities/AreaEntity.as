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
    
    public function get area():Area
    {
      return world as Area;
    }
  }
}
