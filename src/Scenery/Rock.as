package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Time
	 */
	public class Rock extends Entity
	{
		
		public function Rock(_x:int, _y:int, _t:int=0, _w:int=16, _h:int=16) 
		{
			super(_x, _y, Game.rocks[_t]);
			setHitbox(_w, _h);
			type = "Solid";
			layer = -(y - originY + height*3/4);
		}
		
	}

}