package Scenery 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class Droplet extends Entity
	{
		private const g:Number = 0.1;
		private const frameRate:Number = 0.6;
		private const maxDist:int = 80;
		
		private var startY:int;
		private var endY:int;
		private var v:Point = new Point;
		private var frame:Number = 0;
		private var color:uint;
		
		private var player:Player;
		
		public function Droplet(_x:int, _y:int, _height:int, _color:uint) 
		{
			super(_x, _y - _height);
			startY = y;
			endY = _y;
			layer = -startY;
			
			color = _color;
			
			v.y = 1; //starting speed
		}
		
		override public function added():void
		{
			super.added();
			const checkW:int = 6;
			var tileHit:Tile = FP.world.collideRect("Tile", x - checkW / 2, endY, checkW, 1) as Tile;
			if (FP.world.collideRect("Solid", x - checkW/2, endY, checkW, 1) || (tileHit && tileHit.t == 6 /* PIT */) || !tileHit)
			{
				FP.world.remove(this);
			}
			else
			{
				var tileHitTemp:Tile;
				while (true)
				{
					if (tileHit && (tileHit.t == 9 || tileHit.t == 10 || tileHit.t == 13 || tileHit.t == 25)) // Cliff, Stairs, Cave, Waterfall (vertical parts)
					{
						endY += Tile.h;
					}
					else if (tileHit && (tileHit.t == 6 /* Pit */))
					{
						FP.world.remove(this);
						break;
					}
					else
					{
						break;
					}
					tileHit = FP.world.collideRect("Tile", x - checkW / 2, endY, checkW, 1) as Tile;
				}
			}
		}
		
		override public function update():void
		{
			
			
			
			v.y += g;
			
			x += v.x;
			y += v.y;
			
			if (y >= endY)
			{
				y = endY;
				frame += frameRate;
				if (frame >= Game.sprDroplet.frameCount)
				{
					FP.world.remove(this);
				}
			}
			
			player = FP.world.nearestToPoint("Player", x, y) as Player;
		}
		
		override public function render():void
		{
			Game.sprDroplet.alpha = (y - startY) / (endY - startY);
			if (player)
			{
				Game.sprDroplet.alpha *= Math.max(1 - FP.distance(x, y, player.x, player.y) / maxDist, 0);
			}
			Game.sprDroplet.frame = frame;
			Game.sprDroplet.color = color;
			Game.sprDroplet.render(new Point(x, y), FP.camera);
			
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			Game.sprDroplet.render(new Point(x, y), FP.camera);
			Draw.resetTarget();
			//NOT RESTORATIVE--PROPERTIES ARE LEFT AS-IS
		}
		
	}

}