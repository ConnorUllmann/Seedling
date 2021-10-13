package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	import flash.display.BlendMode;
	/**
	 * ...
	 * @author Time
	 */
	public class LightRay extends Entity
	{
		private var c:uint;
		private var a:Number;
		private var w:int;
		private var h:int;
		
		public function LightRay(_x:int, _y:int, _c:uint, _a:Number, _w:int, _h:int) 
		{
			super(_x, _y);
			c = _c;
			a = _a;
			w = _w;
			h = _h;
			layer = -(y + h);
		}
		
		override public function render():void
		{
			if (y - FP.camera.y + h >= 0)
			{
				Draw.rect(x, FP.camera.y, w, y - FP.camera.y + h, c, 0.2);
				Draw.blend = BlendMode.SCREEN;
				Draw.rect(x, y, w, h, c, a/2);
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				Draw.rect(x, FP.camera.y, w, y - FP.camera.y + h, c, a);
				Draw.resetTarget();
				Draw.blend = BlendMode.NORMAL;
			}
		}
		
	}

}