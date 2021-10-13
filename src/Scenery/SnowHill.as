package Scenery
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.masks.Pixelmask;
	/**
	 * ...
	 * @author Time
	 */
	public class SnowHill extends Entity
	{		
		public function SnowHill(_x:int, _y:int) 
		{
			super(_x, _y, Game.sprSnowHill);
			Game.sprSnowHill.y = -8;
			mask = new Pixelmask(Game.imgSnowHillMask, 0, 0);
			type = "Solid";
			layer = -(y - originY + height - 32);
			active = false;
		}
	}

}