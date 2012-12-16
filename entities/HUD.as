package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Text;
  
  public class HUD extends AreaEntity
  {
    public static const PADDING:uint = 3;
    public var health:Text;
    
    public function HUD()
    {
      layer = -2;
      health = new Text("Health: 100", PADDING, 0, { width: FP.width - PADDING * 2, scrollX: 0, scrollY: 0 });
      health.y = FP.height - PADDING - health.textHeight;
      addGraphic(health);
    }
    
    override public function update():void
    {
      health.text = "Health: " + String(area.player.health);
    }
  }
}
