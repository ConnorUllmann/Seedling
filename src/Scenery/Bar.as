package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Time
	 */
	public class Bar extends Entity
	{
		[Embed(source = "../../assets/graphics/Bar.png")] private var imgBar:Class;
		private var sprBar:Image = new Image(imgBar);
		
		public function Bar(_x:int, _y:int) 
		{
			super(_x, _y, sprBar);
			setHitbox(64, 16);
			sprBar.y = -4;
			sprBar.originY = -sprBar.y;
			type = "Solid";
			layer = -(y - originY + height * 4/5);
		}
		
	}

}