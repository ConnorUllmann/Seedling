package Scenery
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class Pole extends Entity
	{
		private var img:int = 0;
		
		public function Pole(_x:int, _y:int) 
		{
			super(_x + Tile.w / 2, _y + Tile.h / 2);
			setHitbox(16, 16, 8, 8);
			type = "Solid";
			layer = -(y - originY + height);
		}
		
		override public function render():void
		{
			Game.sprPole.frame = img;
			Game.sprPole.render(new Point(x, y), FP.camera);
		}
		
		override public function check():void
		{
			img = 0;
			var c:Entity = collide("Solid", x + 1, y);
			if (c && c is Pole)
			{
				img++;
			}
			c = collide("Solid", x - 1, y);
			if (c && c is Pole)
			{
				img += 2;
			}
			c = collide("Solid", x, y + 1);
			if (c && c is Pole)
			{
				img += 4;
			}
		}
		
	}

}