package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Time
	 */
	public class Barstool extends Entity
	{
		[Embed(source = "../../assets/graphics/Barstool.png")] private var imgBarstool:Class;
		private var sprBarstool:Image = new Image(imgBarstool);
		
		public function Barstool(_x:int, _y:int) 
		{
			super(_x + Tile.w/4, _y + Tile.h/4, sprBarstool);
			setHitbox(8, 8);
			sprBarstool.y = -4;
			sprBarstool.originY = -sprBarstool.y;
			type = "Solid";
			layer = -(y - originY);
		}
		
	}

}