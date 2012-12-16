package worlds.areas
{
  import worlds.Area;
  
  public class Area2 extends Area
  {
    [Embed(source = "../../assets/areas/2.oel", mimeType = "application/octet-stream")]
    public static const DATA:Class;
    
    public function Area2(index:uint)
    {
      super(DATA, index);
    }
  }
}
