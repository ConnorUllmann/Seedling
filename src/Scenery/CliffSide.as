package Scenery 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.masks.Pixelmask;
	/**
	 * ...
	 * @author Time
	 */
	public class CliffSide extends Entity
	{
		private var frame:int;
		
		public function CliffSide(_x:int, _y:int, _f:int=0) 
		{
			super(_x, _y);
			frame = _f;
			
			switch(frame)
			{
				case 0:
					mask = new Pixelmask(Game.imgCliffSidesMaskL); break;
				case 1:
					mask = new Pixelmask(Game.imgCliffSidesMaskR); break;
				case 2:
					mask = new Pixelmask(Game.imgCliffSidesMaskLU); break;
				case 3:
					mask = new Pixelmask(Game.imgCliffSidesMaskRU); break;
				default:
					mask = new Pixelmask(Game.imgCliffSidesMaskU);
			}
			type = "Solid";
		}
		
		
		override public function render():void
		{
			Game.sprCliffSides.frame = frame;
			Game.sprCliffSides.render(new Point(x, y), FP.camera);
		}
	}

}