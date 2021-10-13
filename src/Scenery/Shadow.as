package Scenery 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	import flash.display.BlendMode;
	/**
	 * ...
	 * @author Time
	 */
	public class Shadow extends Entity
	{
		private var c:uint;
		private var a:Number;
		private var w:int;
		private var h:int;
		private var myBmp:BitmapData;
		private var myMatrix:Matrix;
		
		public function Shadow(_x:int, _y:int, _c:uint, _a:Number, _w:int, _h:int) 
		{
			super(_x, _y);
			c = _c;
			a = _a;
			w = _w;
			h = _h;
			layer = -(y);
			
			myBmp = new BitmapData(w, h, true, int(a*255)*0x01000000+c);
		}
		
		override public function render():void
		{
			if (y + h > FP.camera.y && x + w > FP.camera.x && y < FP.camera.y + FP.screen.height && x < FP.camera.x + FP.screen.width)
			{
				//Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				//Draw.rect(x, y, w, h, c, a);
				//Draw.resetTarget();
				myMatrix = new Matrix();
				myMatrix.translate(x-FP.camera.x, y-FP.camera.y);
				(FP.world as Game).nightBmp.draw(myBmp, myMatrix);
			}
		}
		
	}

}