package worlds.areas
{
  import worlds.Area;
  
  public class Area3 extends Area
  {
    [Embed(source = "../../assets/areas/3.oel", mimeType = "application/octet-stream")]
    public static const DATA:Class;
    
    public function Area3(index:uint)
    {
      super(DATA, index);
    }
  }
}
