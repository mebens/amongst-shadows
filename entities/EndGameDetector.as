package entities
{
  import net.flashpunk.*;
  import worlds.GameEnd;
  
  public class EndGameDetector extends Detector
  {
    public var collected:Boolean = false;
    
    public static function fromXML(o:Object):EndGameDetector
    {
      return new EndGameDetector(o.@x, o.@y, o.@width, o.@height);
    }
    
    public function EndGameDetector(x:int, y:int, width:uint, height:uint)
    {
      super(x, y, width, height, beginCollide);
    }
    
    override public function added():void
    {
      area.addListener("safe.complete", function():void { collected = true; });
    }
    
    public function beginCollide():void
    {
      if (collected) area.fade.fadeOut(0.5, function():void { FP.world = new GameEnd; });
    }
  }
}
