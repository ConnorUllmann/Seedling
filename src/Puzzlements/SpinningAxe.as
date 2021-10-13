package Puzzlements 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class SpinningAxe extends Entity
	{
		[Embed(source = "../../assets/graphics/SpinningAxe.png")] private var imgSpinningAxe:Class;
		[Embed(source = "../../assets/graphics/SpinningAxeRed.png")] private var imgSpinningAxeRed:Class;
		private var sprSpinningAxe:Image;
		
		private const length:int = 32;
		private const endRectSide:int = 12;
		
		private var spinRate:Number;
		private var force:int = 5;
		private var damage:int = 1;
		
		public function SpinningAxe(_x:int, _y:int, _rate:int, _colorType:int=0) 
		{
			switch(_colorType)
			{
				case 1:
					sprSpinningAxe = new Image(imgSpinningAxeRed);
					break;
				default:
					sprSpinningAxe = new Image(imgSpinningAxe);
			}
			super(_x + Tile.w / 2, _y + Tile.h / 2, sprSpinningAxe);
			sprSpinningAxe.originX = 4;
			sprSpinningAxe.originY = sprSpinningAxe.height / 2;
			sprSpinningAxe.x = -sprSpinningAxe.originX;
			sprSpinningAxe.y = -sprSpinningAxe.originY;
			
			setHitbox(8, 8, 4, 4);
			type = "Solid";
			
			spinRate = _rate;
		}
		
		override public function update():void
		{
			super.update();
			
			sprSpinningAxe.angle += spinRate;
			
			var a:Number = -sprSpinningAxe.angle / 180 * Math.PI;
			var p:Player = FP.world.collideLine("Player", x, y, x + length * Math.cos(a), y + length * Math.sin(a)) as Player;
			if (!p)
			{
				p = FP.world.collideRect("Player", x - endRectSide / 2, y - endRectSide / 2, endRectSide, endRectSide) as Player;
			}
			hitPlayer(p, a);
			
			layer = -(y + length);
		}
		
		public function hitPlayer(p:Player, a:Number):void
		{
			if (p)
			{
				var m:Number = Math.tan(a + 2 * spinRate / 180 * Math.PI);
				var a:Number = p.x;
				var b:Number = p.y;
				var c:Number = y - m * x;
				var _x:Number = (m * (b - c) + a) / (m * m + 1);
				
				p.hit(null, force, new Point(_x, b + (a - _x) / m), damage);
			}
		}
	}

}