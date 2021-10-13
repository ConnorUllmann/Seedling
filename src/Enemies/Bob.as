package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	import Pickups.Coin;
	/**
	 * ...
	 * @author Time
	 */
	public class Bob extends Enemy
	{
		[Embed(source = "../../assets/graphics/Bob.png")] private var imgBob:Class;
		private var sprBob:Spritemap = new Spritemap(imgBob, 8, 8, endAnim);
		
		public var moveSpeed:Number = 0.5;
		private const walkAnimSpeed:int = 10;
		public var sitFrames:Array = new Array(0, 1, 2, 1);
		public var runRange:int = 80; //Range at which the Bob will run after the character
		public var animateNormally:Boolean = true;
		public var sitLoops:Number = 1;
		public var targetOffset:Point = new Point();
		
		public var hopSoundIndex:int = 0;
		
		public function Bob(_x:int, _y:int, _g:Graphic=null) 
		{
			if (!_g)
			{
				_g = sprBob;
			}
			super(_x + Tile.w/2, _y + Tile.h/2, _g);
			sprBob.centerOO();
			sprBob.add("walk", sitFrames, walkAnimSpeed, false);
			sprBob.add("die", [3, 4, 5, 6], 5);
			
			solids.push("Enemy");
			
			setHitbox(8, 8, 4, 4);
		}
		
		override public function removed():void
		{
			//if(!fell) dropCoins();
		}
		
		override public function update():void
		{
			super.update();
			if (destroy || (graphic as Spritemap).currentAnim == "die" || Game.freezeObjects)
				return;
			
			var player:Player = FP.world.nearestToEntity("Player", this) as Player;
			if (player)
			{
				var d:Number = FP.distance(x, y, player.x + targetOffset.x, player.y + targetOffset.y);
				if (d <= runRange) //&& !FP.world.collideLine("Solid", x, y, player.x, player.y))
				{
					var a:Number = Math.atan2(player.y + targetOffset.y - y, player.x + targetOffset.x - x);
					var toV:Point = new Point(moveSpeed * Math.cos(a), moveSpeed * Math.sin(a));
					var pushed:Boolean = v.length > moveSpeed; //If we're already moving faster than we should...
					v.x += FP.sign(toV.x - v.x) * moveSpeed;
					v.y += FP.sign(toV.y - v.y) * moveSpeed;
					if (!pushed && v.length > moveSpeed)
					{
						v.normalize(moveSpeed); //If we weren't moving to fast, and are now, then reset speed.
					}
					if (animateNormally && (graphic as Spritemap).currentAnim != "walk")
					{
						Music.playSoundDistPlayer(x, y, "Enemy Hop", hopSoundIndex);
						(graphic as Spritemap).play("walk");
					}
				}
			}
			
			if (!Game.freezeObjects && (graphic as Spritemap).currentAnim == "")
			{
				(graphic as Spritemap).frame = sitFrames[Game.worldFrame(sitFrames.length, sitLoops)];
			}
		}
		
		override public function startDeath(t:String=""):void
		{
			(graphic as Spritemap).play("die");
			dieEffects(t);
		}
		
		public function endAnim():void
		{
			if ((graphic as Spritemap).currentAnim == "die")
			{
				destroy = true;
				(graphic as Spritemap).play("");
				(graphic as Spritemap).frame = (graphic as Spritemap).frameCount - 1;
			}
			else
			{
				(graphic as Spritemap).play("");
			}
		}
		
	}

}