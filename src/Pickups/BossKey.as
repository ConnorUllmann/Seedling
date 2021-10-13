package Pickups 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import Scenery.Tile;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class BossKey extends Pickup
	{
		private var keyType:int;
		private var doActions:Boolean = true;
		
		public function BossKey(_x:int, _y:int, _t:int=0) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, Game.bossKeys[_t], null, false);
			setHitbox(8, 8, 4, 4);
			keyType = _t;
			
			special = true;
			if (keyType == 0)
			{
				text = "You got a key!~Keys open locks of their color.";
			}
			mySound = Music.sndOKey;
		}
		
		override public function check():void
		{
			super.check();
			if (Player.hasKey(keyType))
			{
				doActions = false;
				FP.world.remove(this);
			}
		}
		
		override public function render():void
		{
			(graphic as Spritemap).frame = Game.worldFrame((graphic as Spritemap).frameCount);
			super.render();
			if (keyType == 2 || keyType == 3 || keyType == 4) // Wand/Ice/6th Dungeon key
			{
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				const minsc:Number = 0.1;
				const sc:Number = 0.25;
				const alph:Number = 0.25;
				const phases:int = 5;
				if(keyType == 2) Draw.circlePlus(x, y, Math.max(width, height) * (1 + minsc + sc * Game.worldFrame(phases) / phases), 0xFFFFCC, alph);
				super.render();
				Draw.resetTarget();
			}
			(graphic as Spritemap).frame = 0;
		}
		
		override public function removed():void
		{
			if (doActions)
			{
				Player.hasKeySet(keyType, true);
			}
		}
		
	}

}