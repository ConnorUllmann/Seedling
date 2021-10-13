package Scenery
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Time
	 */
	public class DungeonSpire extends Entity
	{
		[Embed(source = "../../assets/graphics/DungeonSpire.png")] private var imgDungeonSpire:Class;
		private var sprDungeonSpire:Image = new Image(imgDungeonSpire);
		
		public function DungeonSpire(_x:int, _y:int) 
		{
			super(_x, _y, sprDungeonSpire);
			sprDungeonSpire.y = -8;
			sprDungeonSpire.originY = 8;
			setHitbox(16, 16);
			type = "Solid";
			layer = -(y - originY + height * 2 / 3);
		}
		
	}

}