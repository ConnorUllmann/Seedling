package Pickups
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class DarkShield extends Pickup
	{
		[Embed(source = "../../assets/graphics/DarkShield.png")] private var imgDarkShield:Class;
		private var sprDarkShield:Image = new Image(imgDarkShield);
		
		private var tag:int;
		private var doActions:Boolean = true;
		
		public function DarkShield(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprDarkShield, null, false);
			sprDarkShield.centerOO();
			setHitbox(9,9,5,5);
			
			tag = _tag;
			
			special = true;
			text = "You got the Dark Shield!~It hurts what it touches.";
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
				Player.hasDarkShield = true;
				Game.setPersistence(tag, false);
			}
		}
		
	}

}