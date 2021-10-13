package Pickups
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import Scenery.Tile;
	import Scenery.Moonrock;
	/**
	 * ...
	 * @author Time
	 */
	public class Shield extends Pickup
	{
		[Embed(source = "../../assets/graphics/Shield.png")] private var imgShield:Class;
		private var sprShield:Spritemap = new Spritemap(imgShield, 7, 7);
		
		private var tag:int;
		private var doActions:Boolean = true;
		
		public function Shield(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprShield, null, false);
			sprShield.centerOO();
			setHitbox(8, 8, 4, 4);
			
			tag = _tag;
			
			special = true;
			text = "You got the shield!~It protects you when moving.";
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
				Player.hasShield = true;
				Moonrock.beam = true;
				Game.setPersistence(tag, false);
			}
		}
		
	}

}