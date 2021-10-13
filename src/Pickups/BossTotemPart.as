package Pickups 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class BossTotemPart extends Pickup
	{
		[Embed(source = "../../assets/graphics/BossTotemParts.png")] private var imgBossTotemPart:Class;
		private var sprBossTotemPart:Spritemap = new Spritemap(imgBossTotemPart, 24, 24);
		
		private var totemPart:int;
		private var doActions:Boolean = true;
		
		public function BossTotemPart(_x:int, _y:int, _t:int) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprBossTotemPart, new Point(), false);
			sprBossTotemPart.frame = _t;
			sprBossTotemPart.centerOO();
			setHitbox(16, 16, 8, 8);
			totemPart = _t;
			layer = -(y - originY + height);
			
			special = true;
		}
		
		override public function check():void
		{
			super.check();
			if (Player.hasTotemPart(totemPart))
			{
				doActions = false;
				FP.world.remove(this);
			}
		}
		
		override public function removed():void
		{
			if (doActions)
			{
				Player.hasTotemPartSet(totemPart, true);
			}
		}
	}

}