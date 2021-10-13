package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Time
	 */
	public class BrickWell extends Entity
	{
		[Embed(source = "../../assets/graphics/BrickWell.png")] private var imgBrickWell:Class;
		private var sprBrickWell:Image = new Image(imgBrickWell);
		
		public function BrickWell(_x:int, _y:int) 
		{
			super(_x, _y, sprBrickWell);
			sprBrickWell.y = -4;
			sprBrickWell.originY = 4;
			sprBrickWell.x = -1;
			sprBrickWell.originX = 1;
			setHitbox(16, 16);
			type = "Solid";
			layer = -(y - originY + height * 4/5);
		}
		
	}

}