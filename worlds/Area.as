package worlds
{
  import flash.utils.Dictionary;
  import net.flashpunk.*;
  import entities.*;
  import worlds.areas.*;
  
  public class Area extends World
  {
    public static const LIST:Array = [];
    public static var current:Area;
    
    public var index:uint;
    public var width:uint;
    public var height:uint;
    public var listeners:Dictionary = new Dictionary;
    
    public var lighting:Lighting;
    public var player:Player;
    public var floor:Floor;
    public var walls:Walls;
    
    public static function init():void
    {
      LIST.push(Area1);
    }
    
    public static function load(index:uint):void
    {
      if (!LIST[index]) throw new Error("An area by the index of " + index + " doesn't exist.");
      FP.world = current = new LIST[index](index);
    }
    
    public function Area(data:Class, index:uint)
    {
      var xml:XML = FP.getXML(data);
      width = xml.width;
      height = xml.height;
      
      add(lighting = new Lighting);
      add(player = Player.fromXML(xml.objects.player));
      add(floor = new Floor(width, height));
      add(walls = new Walls(width, height));
      walls.loadFromXML(xml);
      floor.loadFromXML(xml);
      loadObjects(xml);
    }
    
    override public function update():void
    {
      super.update();
      FP.camera.x = player.x - FP.width / 2;
      FP.camera.y = player.y - FP.height / 2;
      FP.clampInRect(FP.camera, 0, 0, Math.max(width - FP.width, 0), Math.max(height - FP.height, 0));
    }
    
    public function addListener(message:String, callback:Function):void
    {
      for each (var msg:String in message.split(","))
      {
        if (!listeners[msg]) listeners[msg] = new Dictionary;
        listeners[msg][callback] = true;
      }
    }
    
    public function removeListener(message:String, callback:Function):void
    {
      if (!listeners[message]) throw new Error("The message '" + message + "' doesn't exist.");
      delete listeners[message][callback];
    }
    
    public function sendMessage(message:String):void
    {
      if (!listeners[message]) return;
      for (var f:Object in listeners[message]) f();
    }
    
    public function loadObjects(data:XML):void
    {
      for each (var o:Object in data.objects.light) lighting.add(Light.fromXML(o));
      for each (o in data.objects.guard) add(Guard.fromXML(o));
    }
  }
}
