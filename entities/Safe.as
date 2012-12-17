package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Spritemap;
  import net.flashpunk.utils.Input;
  
  public class Safe extends AreaEntity
  {
    [Embed(source = "../assets/images/safe.png")]
    public static const IMAGE:Class;
    
    [Embed(source = "../assets/sfx/safe-open.mp3")]
    public static const OPEN:Class;
    
    [Embed(source = "../assets/sfx/safe-open-beep.mp3")]
    public static const OPEN_BEEP:Class;
    
    public static const DETECT_PADDING:Number = 10;
    
    public var map:Spritemap;
    public var detector:Detector;
    public var openSfx:Sfx = new Sfx(OPEN);
    public var openBeepSfx:Sfx = new Sfx(OPEN_BEEP);
    public var over:Boolean = false;
    
    public static function fromXML(o:Object):Safe
    {
      return new Safe(o.@x, o.@y);
    }
    
    public function Safe(x:uint, y:uint)
    {
      super(x, y);
      layer = 4;
      setHitbox(10, 11);
      graphic = map = new Spritemap(IMAGE, width, height, openComplete);
      detector = new Detector(x - DETECT_PADDING, y, width + DETECT_PADDING * 2, height, begin, end);
      
      map.x = DETECT_PADDING;
      map.add("open", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 3, 4, 5, 6, 7, 7, 7, 7, 7, 8], 20, false);
      map.setFrame(0);
    }
    
    override public function added():void
    {
      area.add(detector);
    }
    
    override public function update():void
    {
      if (over && Input.pressed("continue"))
      {
        map.play("open");
        
        FP.alarm(0.5, function():void {
          openBeepSfx.play(sfxVolume);
          FP.alarm(0.3, function():void { openSfx.play(sfxVolume); });
        });
      }
    }
    
    public function begin():void
    {
      area.hud.safeOn();
      over = true;
    }
    
    public function end():void
    {
      area.hud.safeOff();
      over = false;
    }
    
    public function openComplete():void
    {
      area.sendMessage("safe.complete");
    }
  }
}
