package Pickups
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class GhostSword extends Pickup
	{
		[Embed(source = "../../assets/graphics/GhostSwordPickup.png")] private var imgGhostSword:Class;
		private var sprGhostSword:Spritemap = new Spritemap(imgGhostSword, 24, 7);
		
		private var tag:int;
		private var doActions:Boolean = true;
		
		public function GhostSword(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprGhostSword, null, false);
			sprGhostSword.centerOO();
			setHitbox(20, 4, 10, 2);
			
			tag = _tag;
			
			special = true;
			text = "You got the Ghost Sword!~It swings like a Sword, but hits like the Spear.";
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
				Player.hasGhostSword = true;
				Game.setPersistence(tag, false);
			}
		}
		override public function render():void
		{
			sprGhostSword.frame = Game.worldFrame(sprGhostSword.frameCount);
			super.render();
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
		
	}

}