package worlds
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Text;
  import net.flashpunk.utils.Input;
  import entities.Fade;
  
  public class GameEnd extends World
  {
    public static const PADDING:Number = 10;
    public var text:Text;
    public var fade:Fade;
    
    public function GameEnd()
    {
      text = new Text("On behalf of us all, I thank you.\nThis is another stepping stone to the end.\nWe are close, very close...\n\n\nPress space to restart.",
        PADDING, 0, { width: FP.width - PADDING * 2, align: "center" }
      );
      
      text.y = FP.height / 2 - text.textHeight / 2;
      addGraphic(text);
      add(fade = new Fade);
      fade.fadeIn(1);
    }
    
    override public function update():void
    {
      super.update();
      
      if (Input.pressed("continue"))
      {
        fade.fadeOut(0.5, function():void { Area.load(0); });
      }
    }
  }
}
