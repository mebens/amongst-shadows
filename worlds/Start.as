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
      // the beginning \n is needed to get rid of a weird blurring effect
      main = new Text(
        "\nInfiltrate the base, and secure the package.\nHide in the shadows.\nYou can backstab enemies when behind them,\nor concealed by darkness.\n\nControls:\nArrows/WASD to move\nSpace to jump\nX to backstab\n\n\nPress space to begin",
        PADDING, 0, { width: FP.width - PADDING * 2, align: "center" }
      );
      
      main.y = FP.height / 2 - main.textHeight / 2;
      
      title = new Text("Amongst Shadows", PADDING, 0, { width: FP.width - PADDING * 2, size: 16, align: "center" });
      title.y = main.y - title.textHeight - PADDING;
      addGraphic(title);
      
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
