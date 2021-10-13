package Puzzlements
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class BreakableRock extends Entity
	{
		[Embed(source = "../../assets/graphics/BreakableRock.png")] private var imgBreakableRock:Class;
		private var sprBreakableRock:Spritemap = new Spritemap(imgBreakableRock, 16, 16, endAnim);
		[Embed(source = "../../assets/graphics/BreakableRockGhost.png")] private var imgBreakableRockGhost:Class;
		private var sprBreakableRockGhost:Spritemap = new Spritemap(imgBreakableRockGhost, 16, 16, endAnim);
		
		private var tag:int;
		private var rockType:int;
		
		public function BreakableRock(_x:int, _y:int, _tag:int=-1, _type:int=0) 
		{
			super(_x + Tile.w / 2, _y + Tile.h / 2);
			
			switch(_type)
			{
				case 0:
					graphic = sprBreakableRock;
					break;
				case 1:
					graphic = sprBreakableRockGhost;
					break;
				default:
			}
			
			rockType = _type;
			
			(graphic as Spritemap).centerOO();
			(graphic as Spritemap).add("break", [0, 1, 2, 3], 20);
			type = "Solid"; //Was "Rock"; If it's buggy, that might be why
			setHitbox(16, 16, 8, 8);
			layer = -(y - originY + height);
			tag = _tag;
		}
		
		override public function check():void
		{
			super.check();
			if (tag >= 0 && !Game.checkPersistence(tag))
			{
				FP.world.remove(this);
			}
		}
		
		public function hit(_t:int):void
		{
			if (rockType <= _t) //If the type of hit is more powerful than this rock, break it (so the ghostsword breaks both locks)
			{
				if ((graphic as Spritemap).currentAnim != "break")
				{
					Music.playSound("Rock", 1);
				}
				(graphic as Spritemap).play("break");
			}
		}
		
		public function endAnim():void
		{
			Game.setPersistence(tag, false);
			FP.world.remove(this);
		}
		
	}

}