package Puzzlements 
{
	import net.flashpunk.Entity;
	import Scenery.Tile;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class Pull extends Entity
	{
		private var direction:Number; //the direction that it will pull whatever object it touches (radians)
		private var force:Number;
		
		private var alpha:Number = 0;
		private var radius:Number = 0;
		
		private const radiusRate:Number = 0.5; //The rate at which the radius increases, per colliding object.
		private const pullables:Object = ["Player", "Enemy", "Solid"];
		private const color:uint = 0xFF0000;
		private const maxEntitiesAlpha:int = 3; //The number of colliding entities at which the alpha will be one.
		
		public function Pull(_x:int, _y:int, _d:Number, _f:Number) 
		{
			super(_x, _y);
			setHitbox(Tile.w, Tile.h);
			type = "Pull";
			direction = _d * Math.PI * 2;
			force = _f;
		}
		
		override public function update():void
		{
			var v:Vector.<Entity> = new Vector.<Entity>();
			collideTypesInto(pullables, x, y, v);
			alpha = v.length / maxEntitiesAlpha;
			for each(var e:Entity in v)
			{
				e.x += force * Math.cos(direction);
				e.y -= force * Math.sin(direction);
				
				radius += radiusRate;
			}
			if (v.length <= 0)
			{
				radius = 0;
			}
			else
			{
				radius = radius % (Math.sqrt(width * width + height * height) / 2);
			}
		}
		
		override public function render():void
		{
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			Draw.circlePlus(x - originX + width / 2, y - originY + height / 2, radius, color, alpha); 
			Draw.resetTarget();
		}
		
	}

}