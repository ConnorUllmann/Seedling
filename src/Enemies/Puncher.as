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
	public class Puncher extends Enemy
	{
		[Embed(source = "../../assets/graphics/Puncher.png")] private var imgPuncher:Class;
		private var sprPuncher:Spritemap = new Spritemap(imgPuncher, 20, 20, endAnim);
		
		private var direction:int = 3; //0 = right, counter-clockwise from there.
		public var moveSpeed:Number = 1;
		private const standAnimSpeed:int = 2;
		private const walkAnimSpeed:int = 4;
		private const attackAnimSpeed:int = 12;
		private const runRange:int = 80; //Range at which the Puncher will run after the character
		private const attackRange:int = 10; //Range at which the Puncher will attack the character
		private const punchForce:Number = 5;
		
		public function Puncher(_x:int, _y:int) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprPuncher);
			
			sprPuncher.centerOO();
			
			sprPuncher.add("walk-side", [6, 7, 8, 9], walkAnimSpeed);
			sprPuncher.add("walk-up", [16, 17, 18, 19], walkAnimSpeed);
			sprPuncher.add("walk-down", [26, 27, 28, 29], walkAnimSpeed);
			
			sprPuncher.add("attack-side", [2, 3, 4, 5], attackAnimSpeed);
			sprPuncher.add("attack-up", [12, 13, 14, 15], attackAnimSpeed);
			sprPuncher.add("attack-down", [22, 23, 24, 25], attackAnimSpeed);
			
			sprPuncher.add("stand-side", [0, 1], standAnimSpeed);
			sprPuncher.add("stand-up", [10, 11], standAnimSpeed);
			sprPuncher.add("stand-down", [20, 21], standAnimSpeed);
			
			sprPuncher.add("die", [30, 31, 32, 33, 34, 35, 36, 37, 38, 39], 10);
			
			setHitbox(12, 12, 6, 4);
			
			solids.push("Enemy", "Player");
			
			damage = 1;
		}
		
		override public function update():void
		{
			super.update();
			if (destroy || (graphic as Spritemap).currentAnim == "die")
				return;
			
			var player:Player = FP.world.nearestToPoint("Player", x, y) as Player;
			if (player && getSprite() != "attack")
			{
				var d:Number = FP.distance(x, y, player.x, player.y);
				if (d <= runRange) //&& !FP.world.collideLine("Solid", x, y, player.x, player.y) && !FP.world.collideLine("Tree", x, y, player.x, player.y))
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
					
					if (direction == 2)
					{
						sprPuncher.scaleX = -Math.abs(sprPuncher.scaleX);
					}
					else
					{
						sprPuncher.scaleX = Math.abs(sprPuncher.scaleX);
					}
					if (Math.abs(v.x) > Math.abs(v.y))
					{
						if (v.x > 0)
						{
							direction = 0;
						}
						else if (v.x < 0)
						{
							direction = 2;
						}
					}
					else
					{
						if (v.y >= 0)
						{
							direction = 3;
						}
						else
						{
							direction = 1;
						}
					}
					setSprite("walk");
				}
				else
				{
					setSprite("stand");
				}
				if (d <= attackRange)
				{
					//ATTTAAAACK
					if ((graphic as Spritemap).currentAnim != "attack")
						Music.playSoundDistPlayer(x, y, "Punch");
					setSprite("attack");
				}
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
				if (getSprite() == "attack")
				{
					attackPlayer();
				}
				setSprite("stand");
			}
		}
		
		public function getSprite():String
		{
			var s:String = sprPuncher.currentAnim.substring(0, sprPuncher.currentAnim.indexOf("-", 0));
			return s;
		}
		
		public function setSprite(prefix:String):void
		{
			switch(direction)
			{
				case 0:
					sprPuncher.play(prefix + "-side"); break;
				case 1:
					sprPuncher.play(prefix + "-up"); break;
				case 2:
					sprPuncher.play(prefix + "-side"); break;
				case 3:
					sprPuncher.play(prefix + "-down"); break;
				default:
			}
		}
		
		override public function knockback(f:Number = 0, p:Point = null):void
		{
			
		}
		
		public function attackPlayer():void
		{
			if (hitsTimer > 0)
			{
				return;
			}
			var p:Player = FP.world.nearestToPoint("Player", x, y) as Player;
			if (Math.abs(p.x - x) > Math.abs(p.y - y))
			{
				if (p.x - x > 0)
				{
					direction = 0;
				}
				else
				{
					direction = 2;
				}
			}
			else
			{
				if (p.y - y > 0)
				{
					direction = 3;
				}
				else
				{
					direction = 1;
				}
			}
			const r:int = 8; //The width/height of the hitbox that hits the player; the length of the punch.
			switch(direction)
			{
				case 0:
					p = FP.world.collideRect("Player", x - originX + width, y - originY, r, height) as Player; break;
				case 1:
					p = FP.world.collideRect("Player", x - originX, y - originY - r, width, r) as Player; break;
				case 2:
					p = FP.world.collideRect("Player", x - originX - r, y - originY, r, height) as Player; break;
				case 3:
					p = FP.world.collideRect("Player", x - originX, y - originY + height, width, r) as Player; break;
				default:
			}
			if (p)
			{
				p.hit(this, punchForce, new Point(x, y), damage);
			}
		}
		
	}

}