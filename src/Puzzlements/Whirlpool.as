package Puzzlements 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class Whirlpool extends Entity
	{
		[Embed(source = "../../assets/graphics/WhirlPool.png")] private var imgWhirlpool:Class;
		private var sprWhirlpool:Spritemap = new Spritemap(imgWhirlpool, 32, 32);
		
		private const whirlFrames:Array = new Array(0, 1, 2, 1,0,1,2,1,0,1,2,1,0,1,2,1);
		private var spinRate:int = 20;
		private var deathCount:int = 0;
		
		private const timerSetGrow:int = 150;
		private const timerSetLive:int = 60;
		private const timerSetDies:int = 30;
		private var timerSet:int = timerSetGrow + timerSetLive + timerSetDies;
		private var useTimer:Boolean;
		
		private const maxAlpha:Number = 0.5;
		
		public function Whirlpool(_x:int, _y:int, _timer:Boolean=false) 
		{
			super(_x + Tile.w, _y + Tile.h, sprWhirlpool);
			
			useTimer = _timer;
			
			sprWhirlpool.centerOO();
			sprWhirlpool.angle = Math.random() * 360;
			sprWhirlpool.alpha = maxAlpha;
			setHitbox(sprWhirlpool.width, sprWhirlpool.height, sprWhirlpool.originX, sprWhirlpool.originY);
			
			update();
		}
		
		override public function update():void
		{
			if (timerSet > 0 && useTimer)
			{
				timerSet--;
			}
			
			if (timerSet >= timerSetLive + timerSetDies && useTimer) // During the growth portion
			{
				sprWhirlpool.scale = 1 - (timerSet - timerSetLive - timerSetDies) / timerSetGrow;
				sprWhirlpool.alpha = maxAlpha*(1 - (timerSet - timerSetLive - timerSetDies) / timerSetGrow);
			}
			else if (timerSet >= timerSetDies || !useTimer) // During the life portion
			{
				sprWhirlpool.scale = 1;
				sprWhirlpool.alpha = maxAlpha;
				
				var player:Player = collide("Player", x, y) as Player;
				if (player && FP.distance(x, y, player.x, player.y) < ((graphic as Image).width - (graphic as Image).originX) * (graphic as Image).scale)
				{
					var a:Number = Math.atan2(player.y - y, player.x - x);
					var r:int = FP.distance(x, y, player.x, player.y);
					player.x -= r * Math.cos(a);
					player.y -= r * Math.sin(a);
					r *= 0.999;
					a -= spinRate / 180 * Math.PI;
					player.x += r * Math.cos(a);
					player.y += r * Math.sin(a);
					
					if (r <= 1)
					{
						if (deathCount > 0)
						{
							deathCount--;
						}
						else
						{
							player.drown();
						}
					}
				}
			}
			else if(timerSet > 0) // During the death portion
			{
				sprWhirlpool.scale = timerSet / timerSetDies;
				sprWhirlpool.alpha = maxAlpha * timerSet / timerSetDies;
			}
			else
			{
				FP.world.remove(this);
				return;
			}
			super.update();
		}
		
		override public function render():void
		{
			(graphic as Spritemap).frame = whirlFrames[Game.worldFrame(whirlFrames.length)];
			(graphic as Image).angle += spinRate;
			super.render();
		}
		
	}

}