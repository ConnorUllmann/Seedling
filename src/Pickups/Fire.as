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
	public class Fire extends Pickup
	{
		[Embed(source = "../../assets/graphics/FirePickup.png")] private var imgFire:Class;
		private var sprFire:Spritemap = new Spritemap(imgFire, 16, 16);
		
		private var tag:int;
		private var doActions:Boolean = true;
		
		public function Fire(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprFire, null, false);
			sprFire.centerOO();
			sprFire.alpha = 0;
			setHitbox(8, 8, 4, 4);
			
			tag = _tag;
			
			special = true;
			text = "You got Fire!~It pushes but does not hurt.";
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
				Player.hasFire = true;
				Game.setPersistence(tag, false);
			}
		}
		override public function update():void
		{
			super.update();
			sprFire.alpha = Math.min(sprFire.alpha + 0.05, 1);
		}
		override public function render():void
		{
			sprFire.frame = Game.worldFrame(sprFire.frameCount);
			super.render();
		}
		
	}

}