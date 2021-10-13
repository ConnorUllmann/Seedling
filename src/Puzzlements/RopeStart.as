package Puzzlements
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class RopeStart extends Activators
	{
		[Embed(source = "../../assets/graphics/RopePulley.png")] private var imgRope:Class;
		private var sprRope:Spritemap = new Spritemap(imgRope, 16, 16);
		
		private var tag:int;
		private var xend:int;
		
		public function RopeStart(_x:int, _y:int, _xend:int, _t:int, _tag:int = -1) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprRope, _t);
			sprRope.centerOO();
			xend = _xend + Tile.w/2;
			type = "Rope";
			setHitbox(_xend - _x + 16, 16, 8, 8);
			layer = -(y - originY + height/2);
			tag = _tag;
		}
		
		override public function check():void
		{
			super.check();
			if (tag >= 0 && !Game.checkPersistence(tag))
			{
				hit();
			}
		}
		
		public function hit():void
		{
			if (!activate)
			{
				setHitbox(16, 16, 8, 8);
				activate = true;
				Game.setPersistence(tag, false);
				Music.playSound("Other", 3);
			}
		}
		
		override public function render():void
		{
			if (!activate)
			{
				//Rope part
				sprRope.frame = 1;
				for (var i:int = 0; i < xend - x; i+=sprRope.width)
				{
					sprRope.render(new Point(x + i, y), FP.camera);
				}
				//Pulley part
				sprRope.frame = 0;
				sprRope.render(new Point(x, y), FP.camera);
				//Handle part
				sprRope.frame = 2;
				sprRope.render(new Point(xend, y), FP.camera);
			}
			else
			{
				//Pulley part
				sprRope.frame = 0;
				sprRope.render(new Point(x, y), FP.camera);
				//Handle part
				sprRope.frame = 3;
				sprRope.render(new Point(xend, y), FP.camera);
			}
		}
		
		override public function set activate(a:Boolean):void
		{
			_active = a;
			var v:Vector.<Activators> = new Vector.<Activators>();
			FP.world.getClass(Activators, v);
			for (var i:int = 0; i < v.length; i++)
			{
				if (v[i] != this && v[i].t == t)
				{
					v[i].activate = activate;
				}
			}
		}
		
	}

}