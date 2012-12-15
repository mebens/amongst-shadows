package worlds.areas
{
  import worlds.Area;
  
  public class Area1 extends Area
  {
    [Embed(source = "../../assets/areas/1.oel", mimeType = "application/octet-stream")]
    public static const DATA:Class;
    
    public function Area1(index:uint)
    {
      super(DATA, index);
    }
  }
}
