package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Time
	 */
	public class ShieldStatue extends Entity
	{
		[Embed(source = "../../assets/graphics/ShieldStatue.png")] private var imgShieldStatue:Class;
		private var sprShieldStatue:Image = new Image(imgShieldStatue);
		
		public function ShieldStatue(_x:int, _y:int) 
		{
			super(_x + Tile.w/2, _y, sprShieldStatue);
			sprShieldStatue.y = -11;
			sprShieldStatue.originY = 11;
			setHitbox(32, 32);
			type = "Solid";
			layer = -(y - originY);
		}
		
	}

}