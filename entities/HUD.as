package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Text;
  
  public class HUD extends AreaEntity
  {
    public static const PADDING:uint = 3;
    public var health:Text;
    public var safe:Text;
    public var tween:Tween;
    
    public function HUD()
    {
      layer = -2;
      
      health = new Text("Health: 100", PADDING, 0, { width: FP.width - PADDING * 2, scrollX: 0, scrollY: 0 });
      health.y = FP.height - PADDING - health.textHeight;
      addGraphic(health);
      
      safe = new Text("Press X to secure package", PADDING, FP.height - 50, { width: FP.width - PADDING * 2, align: "center", scrollX: 0, scrollY: 0 });
      addGraphic(safe);
    }
    
    override public function update():void
    {
      health.text = "Health: " + String(area.player.health);
    }
    
    public function safeOn():void
    {
      if (tween && tween.active) tween.cancel();
      tween = FP.tween(safe, { alpha: 1 }, 0.25, { tweener: this });
    }
    
    public function safeOff():void
    {
      if (tween && tween.active) tween.cancel();
      tween = FP.tween(safe, { alpha: 0 }, 0.25, { tweener: this });      
    }
  }
}
