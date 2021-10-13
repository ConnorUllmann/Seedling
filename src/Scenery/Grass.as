package Scenery
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class Grass extends Entity
	{
		private var startIndex:int = Math.floor(Math.random() * (Game.sprGrass.frameCount - 1) / 2) * 2 + 1;
		private var cutGrass:Boolean = false;
		
		private var color:uint = 0xFFFFFF;
		private var alpha:Number = 1;
		
		public function Grass(_x:int, _y:int) 
		{
			super(_x, _y, Game.sprGrass);
			active = false;
			layer = -y;
			type = "Grass";
			setHitbox(16, 4, 8, 4);
		}
		
		public function cut(t:String=""):void
		{
			if (!cutGrass)
			{
				if (!Music.soundIsPlaying("Arrow", 0))
					Music.playSound("Arrow", 0);
				Main.grassCut++;
				cutGrass = true;
			}
			if (t == "Fire")
			{
				color = 0x444444;
				alpha = 0.25;
			}
		}
		
		override public function render():void
		{
			if (cutGrass)
			{
				Game.sprGrass.frame = 0;
			}
			else
			{
				Game.sprGrass.frame = startIndex + Game.worldFrame(2);
			}
			Game.sprGrass.color = color;
			Game.sprGrass.alpha = alpha;
			super.render();
		}
		
	}

}