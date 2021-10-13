package Scenery 
{
	import net.flashpunk.masks.Pixelmask;
	import flash.geom.Point;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class OpenTree extends Tree
	{
		
		public function OpenTree(_x:int, _y:int) 
		{
			super(_x, _y);
			active = true;
		}
		
		override public function update():void
		{
			super.update();
			if (!mask)
			{
				setHitbox();
				mask = new Pixelmask(Game.imgOpenTreeMask, -16, -16);
			}
		}
		
		override public function render():void
		{
			Game.sprOpenTree.frame = frame;
			Game.sprOpenTree.render(new Point(x, y), FP.camera);
		}
		
	}

}