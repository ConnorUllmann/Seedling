package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Projectiles.TurretSpit;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class Turret extends Enemy
	{
		[Embed(source = "../../assets/graphics/Turret.png")] private var imgTurret:Class;
		private var sprTurret:Spritemap = new Spritemap(imgTurret, 16, 16, endAnim);
		
		private const attackAnimSpeed:int = 10;
		private const attackRange:int = 64;
		
		private const shootTimerMax:int = 40; // The time between shots
		private var shootTimer:int = 0;
		private const shotSpeed:int = 3;
		
		public function Turret(_x:int, _y:int) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprTurret);
			
			sprTurret.centerOO();
			//the animation "" will reset it to the world frame speed
			sprTurret.add("startshot", [1, 2], attackAnimSpeed);
			sprTurret.add("finishshot", [2, 1], attackAnimSpeed);
			sprTurret.add("hit", [0]);
			sprTurret.add("die", [3, 4, 5, 6, 7, 8], 10);
			
			setHitbox(16, 16, 8, 8);
			
			layer = -(y - originY + height * 4 / 5);
		}
		
		override public function check():void
		{
			super.check();
		}
		
		override public function update():void
		{
			super.update();
			if (Game.freezeObjects || destroy || (graphic as Spritemap).currentAnim == "die")
			{
				return;
			}
			var player:Player = FP.world.nearestToEntity("Player", this) as Player;
			if (player)
			{
				var d:int = FP.distance(x, y, player.x, player.y);
				if (d <= attackRange && sprTurret.currentAnim != "startshot" && sprTurret.currentAnim != "finishshot")
				{
					const angleSpeedDivisor:int = 10;
					sprTurret.angle += FP.angle_difference(-Math.atan2(player.y - y, player.x - x), sprTurret.angle / 180 * Math.PI) * 180 / Math.PI / angleSpeedDivisor;
					if (shootTimer > 0)
					{
						shootTimer--;
					}
					else if(hitsTimer <= 0)
					{
						shootTimer = shootTimerMax;
						sprTurret.play("startshot");
					}
				}
				else
				{
					shootTimer = shootTimerMax;
				}
			}
			if (sprTurret.currentAnim == "")
			{
				sprTurret.frame = 0;// Game.worldFrame(2);
			}
		}
		
		override public function layering():void
		{
			
		}
		
		override public function knockback(f:Number = 0, p:Point = null):void
		{
			
		}
		
		override public function startDeath(t:String=""):void
		{
			(graphic as Spritemap).play("die");
			dieEffects(t);
		}
		
		public function endAnim():void
		{
			switch(sprTurret.currentAnim)
			{
				case "startshot":
					sprTurret.play("finishshot");
					var a:Number = -sprTurret.angle / 180 * Math.PI;
					FP.world.add(new TurretSpit(x, y, new Point(shotSpeed * Math.cos(a), shotSpeed * Math.sin(a))));
					break;
				case "die":
					destroy = true;
					(graphic as Spritemap).play("");
					(graphic as Spritemap).frame = (graphic as Spritemap).frameCount - 1;
					break;
				default:
					sprTurret.play("");
			}
		}
		
	}

}