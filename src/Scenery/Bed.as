package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Time
	 */
	public class Bed extends Entity
	{
		[Embed(source = "../../assets/graphics/Bed.png")] private var imgBed:Class;
		private var sprBed:Image = new Image(imgBed);
		
		public function Bed(_x:int, _y:int) 
		{
			super(_x, _y, sprBed);
			setHitbox(16, 32);
			type = "Solid";
			layer = -(y - originY + height * 4/5);
		}
		
	}

}