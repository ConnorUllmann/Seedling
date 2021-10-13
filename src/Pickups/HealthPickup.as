package Pickups 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class HealthPickup extends Pickup
	{
		[Embed(source = "../../assets/graphics/HealthPickup.png")] private var imgHealth:Class;
		private var sprHealth:Spritemap = new Spritemap(imgHealth, 8, 8);
		
		private const angleRate:int = 10;
		private var tag:int;
		private var doActions:Boolean = true;
		
		public function HealthPickup(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprHealth, null, false);
			(graphic as Spritemap).centerOO();
			(graphic as Spritemap).scaleX = FP.choose(1, -1);
			(graphic as Spritemap).scaleY = FP.choose(1, -1);
			setHitbox(4, 4, 2, 2);
			
			tag = _tag;
			
			special = true;
			text = "You got health!";
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
		
		override public function render():void
		{
			(graphic as Spritemap).angle += angleRate;
			(graphic as Spritemap).frame = Game.worldFrame((graphic as Spritemap).frameCount);
			super.render();
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
		
		override public function removed():void
		{
			if (doActions)
			{
				Player.hitsMax++;
				Main.unlockMedal(Main.badges[4]);
			}
			Game.setPersistence(tag, false);
			super.removed();
		}
		
	}

}