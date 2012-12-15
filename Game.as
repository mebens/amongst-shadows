package
{
  import net.flashpunk.*;
  import net.flashpunk.utils.Input;
  import net.flashpunk.utils.Key;
  import worlds.*;
  
  public class Game extends Engine
  {
    [Embed(source = "assets/images/tiles.png")]
    public static const TILES:Class;
    
    public static const TILE_SIZE:uint = 9;
    
    public function Game()
    {
      super(300, 200);
      FP.screen.scale = 2;
      FP.screen.color = 0xFFFFFF;
      FP.console.enable();
      
      Input.define("left", Key.LEFT, Key.A);
      Input.define("right", Key.RIGHT, Key.D);
      Input.define("up", Key.UP, Key.W);
      Input.define("down", Key.DOWN, Key.S);
    }
    
    override public function init():void
    {
      Area.init();
      Area.load(0);
    }
  }
}
