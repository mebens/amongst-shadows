package worlds
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Text;
  import net.flashpunk.utils.Input;
  import entities.Fade;
  
  public class Start extends World
  {
    public static const PADDING:Number = 10;
    public var fade:Fade;
    public var title:Text;
    public var main:Text;
    
    public function Start()
    {
      title = new Text("Lurker", PADDING, PADDING + 10, { width: FP.width - PADDING * 2, size: 16, align: "center" });
      addGraphic(title);
      
      main = new Text(
        "Infiltrate the base, and secure the package.\nHide in the shadows, backstab enemies when they can't see you.\n\nControls:\nArrows/WASD to move\nSpace to jump\nX to backstab\n\n\nPress space to begin",
        PADDING, title.y + title.textHeight + 20, { width: FP.width - PADDING * 2, align: "center" }
      );
      
      addGraphic(main);
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
