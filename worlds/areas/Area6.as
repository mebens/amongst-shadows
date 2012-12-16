package worlds.areas
{
  import worlds.Area;
  
  public class Area6 extends Area
  {
    [Embed(source = "../../assets/areas/6.oel", mimeType = "application/octet-stream")]
    public static const DATA:Class;
    
    public function Area6(index:uint)
    {
      super(DATA, index);
    }
  }
}
