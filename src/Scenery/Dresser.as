package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Time
	 */
	public class Dresser extends Entity
	{
		[Embed(source = "../../assets/graphics/Dresser.png")] private var imgDresser:Class;
		private var sprDresser:Image = new Image(imgDresser);
		
		public function Dresser(_x:int, _y:int) 
		{
			super(_x, _y, sprDresser);
			sprDresser.y = -8;
			sprDresser.originY = -sprDresser.y;
			setHitbox(32, 16);
			type = "Solid";
			layer = -(y - originY + height * 4/5);
		}
		
	}

}