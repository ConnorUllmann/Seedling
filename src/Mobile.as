package  
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Time
	 */
	public class Mobile extends Entity
	{
		public static const DEFAULT_FRICTION:Number = 0.25;
		public static const WATER_FRICTION:Number = 0.5;
		public var f:Number = DEFAULT_FRICTION; // Frictional constant
		public var solids:Object = ["Solid", "Tree", "Rock", "Rope", "ShieldBoss"];
		public var v:Point = new Point();
		public var destroy:Boolean = false;
		
		public function Mobile(_x:int, _y:int, _g:Graphic=null) 
		{
			super(_x, _y, _g);
		}
		
		override public function update():void
		{
			mobileUpdate();
		}
		
		public function mobileUpdate():void
		{
			if (!destroy)
			{
				if (!Game.freezeObjects)
				{
					friction();
					input();
					moveX(v.x);
					moveY(v.y);
				}
				layering();
			}
			death();
		}
		
		public function input():void
		{
			
		}
		
		public function layering():void
		{
			if (!isNaN(originY) && !isNaN(height))
			{
				layer = -(y-originY+height);
			}
		}
		
		public function death():void
		{
			if (destroy)
			{
				//(graphic as Image).scale -= 0.05;
				(graphic as Image).alpha -= 0.1;
				if ((graphic as Image).alpha <= 0)
				{
					FP.world.remove(this);
				}
			}
		}
		
		public function friction():void
		{
			v.normalize(Math.max(v.length - f, 0));
			if (Math.abs(v.x) < 0.05)
			{
				v.x = 0;
			}
			if (Math.abs(v.y) < 0.05)
			{
				v.y = 0;
			}
		}
		
		public function moveX(_xrel:Number):Entity //returns the object that is hit
		{
			for (var i:int = 0; i < Math.abs(_xrel); i++)
			{
				var c:Entity = collideTypes(solids, x + Math.min(1, (Math.abs(_xrel) - i)) * FP.sign(_xrel), y);
				if (!c)
				{
					x += Math.min(1, (Math.abs(_xrel) - i)) * FP.sign(_xrel);
				}
				else
				{
					return c;
				}
			}
			return null;
		}
		
		public function moveY(_yrel:Number):Entity //returns the object that is hit
		{
			for (var i:int = 0; i < Math.abs(_yrel); i++)
			{
				var c:Entity = collideTypes(solids, x, y + Math.min(1, Math.abs(_yrel) - i) * FP.sign(_yrel));
				if (!c)
				{
					y += Math.min(1, Math.abs(_yrel) - i) * FP.sign(_yrel);
				}
				else
				{
					return c;
				}
			}
			return null;
		}
		
	}

}