package Pickups
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class DarkSuit extends Pickup
	{
		[Embed(source = "../../assets/graphics/DarkSuit.png")] private var imgDarkSuit:Class;
		private var sprDarkSuit:Image = new Image(imgDarkSuit);
		
		private var tag:int;
		private var doActions:Boolean = true;
		
		public function DarkSuit(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprDarkSuit, null, false);
			sprDarkSuit.centerOO();
			setHitbox(10,10,5,5);
			
			tag = _tag;
			
			special = true;
			text = "You got the Dark Suit!~It hurts what it hits, and it lets you swim in lava.";
		}
		
		override public function check():void
		{
			super.check();
			if (tag >= 0 && !Game.checkPersistence(tag))
			{
				doActions = false;
				FP.world.remove(this);
			}
		}
		
		override public function removed():void
		{
			if (doActions)
			{
				Player.hasDarkSuit = true;
				Game.setPersistence(tag, false);
			}
		}
		
	}

}