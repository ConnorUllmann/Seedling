package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Time
	 */
	public class BrickPole extends Entity
	{
		[Embed(source = "../../assets/graphics/BrickPole.png")] private var imgBrickPole:Class;
		private var sprBrickPole:Image = new Image(imgBrickPole);
		
		public function BrickPole(_x:int, _y:int) 
		{
			super(_x, _y, sprBrickPole);
			sprBrickPole.y = -4;
			sprBrickPole.originY = 4;
			setHitbox(16, 16);
			type = "Solid";
			layer = -(y - originY + height * 4/5);
		}
		
	}

}