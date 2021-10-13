package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	import Pickups.Coin;
	/**
	 * ...
	 * @author Time
	 */
	public class Jellyfish extends Enemy
	{
		[Embed(source = "../../assets/graphics/Jellyfish.png")] private var imgJelly:Class;
		private var sprJelly:Spritemap = new Spritemap(imgJelly, 14, 15, endAnim);
		
		public const moveSpeedNormal:Number = 0.8;
		public var moveSpeed:Number = moveSpeedNormal;
		private const walkAnimSpeed:int = 15;
		private const walkFrames:Array = new Array(0, 1, 2, 3, 2, 1);
		private const dieFrames:Array = new Array(4, 5, 6, 7, 8, 9, 10, 11);
		private const runRange:int = 160; //Range at which the Jellyfish will run after the character
		
		public function Jellyfish(_x:int, _y:int) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprJelly);
			
			sprJelly.centerOO();
			sprJelly.add("walk", walkFrames, walkAnimSpeed, false);
			sprJelly.add("die", dieFrames, 7, false);
			dieInWater = false;
			dieInLava = false;
			setHitbox(12, 12, 6, 6);
			
			solids.push("Enemy");
			
			canFallInPit = false;
		}
		
		override public function removed():void
		{
			//if(!fell) dropCoins();
		}
		
		override public function update():void
		{
			super.update();
			if(destroy || (graphic as Spritemap).currentAnim == "die")
				return;
				
			moveSpeed = moveSpeedNormal;// * (1 + hits / hitsMax);
			var player:Player = FP.world.nearestToEntity("Player", this) as Player;
			if (player)
			{
				var d:Number = FP.distance(x, y, player.x, player.y);
				if (d <= runRange) //&& !FP.world.collideLine("Solid", x, y, player.x, player.y))
				{
					var a:Number = Math.atan2(player.y - y, player.x - x);
					var toV:Point = new Point(moveSpeed * Math.cos(a), moveSpeed * Math.sin(a));
					var pushed:Boolean = v.length > moveSpeed; //If we're already moving faster than we should...
					v.x += FP.sign(toV.x - v.x) * moveSpeed;
					v.y += FP.sign(toV.y - v.y) * moveSpeed;
					if (!pushed && v.length > moveSpeed)
					{
						v.normalize(moveSpeed); //If we weren't moving to fast, and are now, then reset speed.
					}
					sprJelly.play("walk");
				}
			}
			
			if (sprJelly.currentAnim == "")
			{
				sprJelly.frame = walkFrames[Game.worldFrame(walkFrames.length)];
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