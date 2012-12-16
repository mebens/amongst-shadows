package
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Text;
  import net.flashpunk.utils.Input;
  import net.flashpunk.utils.Key;
  import worlds.*;
  
  public class Game extends Engine
  {
    [Embed(source = "assets/images/tiles.png")]
    public static const TILES:Class;
    
    [Embed(source = "assets/sfx/background.mp3")]
    public static const BG_SFX:Class;
    
    [Embed(source = "assets/sfx/footstep.mp3")]
    public static const FOOTSTEP_1:Class;
    
    [Embed(source = "assets/sfx/footstep-2.mp3")]
    public static const FOOTSTEP_2:Class;
    
    [Embed(source = "assets/sfx/footstep-3.mp3")]
    public static const FOOTSTEP_3:Class;
    
    [Embed(source = "assets/sfx/land.mp3")]
    public static const LAND_1:Class;
    
    [Embed(source = "assets/sfx/land-2.mp3")]
    public static const LAND_2:Class;
    
    public static const TILE_SIZE:uint = 9;
    public static const GRAVITY:Number = 600;
    public static var bgSfx:Sfx = new Sfx(BG_SFX);
        
    public function Game()
    {
      super(300, 200);
      FP.screen.scale = 2;
      FP.screen.color = 0x000000;
      FP.console.enable();
      Text.size = 8;
      bgSfx.loop(0.2);
      
      Input.define("left", Key.LEFT, Key.A);
      Input.define("right", Key.RIGHT, Key.D);
      Input.define("jump", Key.SPACE, Key.UP, Key.W);
      Input.define("backstab", Key.X);
      Input.define("continue", Key.X, Key.SPACE);
    }
    
    override public function init():void
    {
      Area.init();
      FP.world = new Start;
    }
  }
}
