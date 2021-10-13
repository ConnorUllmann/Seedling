package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class Light extends Entity
	{
		private var radiusMax:int;
		public var radiusMin:int;
		public var alpha:Number;
		public var color:uint;
		protected var frames:int;
		protected var loops:int;
		private var smooth:Boolean;
		
		public var i_radius_factor:Number = 0.5;	
		public var darkLight:Boolean = false;
		
		/**
		 * Sets the drawing target for Draw functions.
		 * @param	_x		x-position of the center of the light.
		 * @param	_y		y-position of the center of the light.
		 * @param	_f		the number of frames for the light.
		 * @param	_l		the number of animation loops for the frames to loop over.
		 * @param	_c		the color of the light.
		 * @param	_rmin	the minimum radius of the light.
		 * @param	_rmax	the maximum radius of the light.
		 * @param	_a		the alpha of each ring of the light.
		 * @param	_smooth	smoothens the animations between radius sizes.
		 */
		public function Light(_x:int, _y:int, _f:int = 1, _l:int = 1, _c:uint = 0xFFFFFF, _smooth:Boolean=false, _rmin:int = 28, _rmax:int = 32, _a:Number = 0.2) 
		{
			super(_x, _y);
			color = _c;
			radiusMax = _rmax;
			radiusMin = _rmin;
			alpha = _a;
			frames = _f;
			loops = _l;
			smooth = _smooth;
		}
		
		override public function render():void
		{
			if (!onScreen(radiusMax))
				return;
			super.render();
			layer = -FP.height * 3/2;
			if (darkLight)
			{
				draw();
			}
			else
			{
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				draw();
				Draw.resetTarget();
			}
		}
		
		public function draw():void
		{
			var c_radius:int;
			if (smooth)
			{
				c_radius = (radiusMax - radiusMin) * (Math.sin(Game.worldFrame(frames, loops) / (frames - 1) * 2 * Math.PI) + 1) / 2 + radiusMin;
			}
			else
			{
				c_radius = (radiusMax - radiusMin) * Game.worldFrame(frames, loops) / (frames - 1) + radiusMin;
			}
			Draw.circlePlus(x, y, c_radius, color, alpha);
			Draw.circlePlus(x, y, c_radius * i_radius_factor, color, alpha);
		}
		
	}

}