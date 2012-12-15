package entities
{
  import net.flashpunk.*;
  import net.flashpunk.graphics.Tilemap;
  
  public class Floor extends AreaEntity
  {
    public var map:Tilemap;
    
    public function Floor(width:uint, height:uint)
    {
      setHitbox(width, height);
      graphic = map = new Tilemap(Game.TILES, width, height, Game.TILE_SIZE, Game.TILE_SIZE);
      map.usePositions = true;
    }
    
    public function loadFromXML(data:XML):void
    {
      for each (var o:Object in data.floor.tile) map.setTile(o.@x, o.@y, o.@id);
      for each (o in data.floor.rect) map.setRect(o.@x, o.@y, o.@w, o.@h, o.@id);
    }
  }
}
