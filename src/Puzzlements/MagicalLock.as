package Puzzlements 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import Scenery.Tile;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class MagicalLock extends Entity
	{
		[Embed(source = "../../assets/graphics/MagicalLock.png")] private var imgMagicalLock:Class;
		private var sprMagicalLock:Spritemap = new Spritemap(imgMagicalLock, 22, 21, animEnd);
		[Embed(source = "../../assets/graphics/MagicalLockFire.png")] private var imgMagicalLockFire:Class;
		private var sprMagicalLockFire:Spritemap = new Spritemap(imgMagicalLockFire, 22, 21, animEnd);
		
		private var tag:int;
		private var lockType:int;
		
		public function MagicalLock(_x:int, _y:int, _tag:int=-1, _type:int=0) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2);
			
			switch(_type)
			{
				case 0:
					graphic = sprMagicalLock;
					break;
				case 1:
					graphic = sprMagicalLockFire;
					break;
				default:
			}
			
			(graphic as Spritemap).centerOO();
			(graphic as Spritemap).add("destroy", [3, 4, 5, 6, 7, 8, 9], 15);
			
			setHitbox(16, 16, 8, 8);
			type = "Solid";
			tag = _tag;
			
			lockType = _type;
			
			layer = -(y - originY + height);
		}
		
		override public function check():void
		{
			super.check();
			if (tag >= 0 && !Game.checkPersistence(tag))
			{
				FP.world.remove(this);
			}
		}
		
		public function animEnd():void
		{
			FP.world.remove(this);
		}
		
		public function hit(_t:int):void
		{
			if (lockType <= _t) //If the type of shot is more powerful than this lock, break it (so the firewand breaks both locks)
			{
				Music.playSoundDistPlayer(x, y, "Lock");
				Game.setPersistence(tag, false);
				(graphic as Spritemap).play("destroy");
			}
		}
		
		override public function render():void
		{
			if ((graphic as Spritemap).currentAnim != "destroy")
			{
				(graphic as Spritemap).frame = Game.worldFrame(3);
			}
			super.render();
		}
	}

}