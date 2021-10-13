package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class MoonrockPile extends Entity
	{
		[Embed(source = "../../assets/graphics/MoonrockPile.png")] private var imgMoonrockPile:Class;
		private var sprMoonrockPile:Image = new Image(imgMoonrockPile);
		
		private var tag:int;
		
		public function MoonrockPile(_x:int, _y:int, _tag:int=0) 
		{
			super(_x, _y, sprMoonrockPile);
			setHitbox(sprMoonrockPile.width, sprMoonrockPile.height);
			type = "Solid";
			layer = -(y - originY + height * 4 / 5);
			tag = 0;
		}
		
		override public function check():void
		{
			super.check();
			if (tag >= 0 && Game.checkPersistence(tag)) //false = there, true = not there
			{
				FP.world.remove(this);
			}
		}
		
	}

}