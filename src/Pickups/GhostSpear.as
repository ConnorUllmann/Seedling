package Pickups
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	import Scenery.Moonrock;
	/**
	 * ...
	 * @author Time
	 */
	public class GhostSpear extends Pickup
	{
		[Embed(source = "../../assets/graphics/GhostSpear.png")] private var imgSpear:Class;
		private var sprSpear:Spritemap = new Spritemap(imgSpear, 20, 7);
		
		private var tag:int;
		private var doActions:Boolean = true;
		
		public function GhostSpear(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprSpear, null, false);
			sprSpear.centerOO();
			setHitbox(12, 4, 6, 2);
			
			tag = _tag;
			
			special = true;
			text = "You got the Ghost Spear!~It hits harder and through walls.";
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
				Player.hasSpear = true;
				Game.setPersistence(tag, false);
			}
		}
		override public function render():void
		{
			sprSpear.frame = Game.worldFrame(sprSpear.frameCount);
			super.render();
		}
		
	}

}