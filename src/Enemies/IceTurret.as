package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Projectiles.IceTurretBlast;
	import Projectiles.TurretSpit;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class IceTurret extends Enemy
	{
		[Embed(source = "../../assets/graphics/IceTurret.png")] private var imgIceTurret:Class;
		private var sprIceTurret:Spritemap = new Spritemap(imgIceTurret, 32, 32, endAnim);
		
		private const attackAnimSpeed:int = 10;
		private const attackRange:int = 128;
		
		private const shootTimerMax:int = 25; // The time between shots
		private var shootTimer:int = 0;
		private const shotSpeed:int = 6;
		
		private const moveSpeed:Number = 0.5;
		private var cTile:Point;
		private var lTile:Point;
		private var tile:Point;
		
		public function IceTurret(_x:int, _y:int) 
		{
			super(_x + Tile.w, _y + Tile.h, sprIceTurret);
			
			sprIceTurret.originX = 12;
			sprIceTurret.x = -sprIceTurret.originX;
			sprIceTurret.originY = 16;
			sprIceTurret.y = -sprIceTurret.originY;
			//the animation "" will reset it to the world frame speed
			sprIceTurret.add("startshot", [0], attackAnimSpeed);
			sprIceTurret.add("finishshot", [1,2,3,4,5], attackAnimSpeed);
			sprIceTurret.add("hit", [1]);
			sprIceTurret.add("dead", [6]);
			
			setHitbox(32, 32, 16, 16);
			
			tile = new Point(Math.floor(x / Tile.w), Math.floor(y / Tile.h));
			cTile = tile;
			lTile = tile;
			
			v = new Point();
			dieInWater = false;
		}
		
		override public function update():void
		{
			dieInWater = hits >= hitsMax;
			super.update();
			if (Game.freezeObjects)
			{
				return;
			}
			if (sprIceTurret.currentAnim != "dead")
			{
				var player:Player = FP.world.nearestToEntity("Player", this) as Player;
				if (player)
				{
					var d:int = FP.distance(x, y, player.x, player.y);
					if (d <= attackRange && sprIceTurret.currentAnim != "startshot" && sprIceTurret.currentAnim != "finishshot")
					{
						const angleSpeedDivisor:int = 10;
						sprIceTurret.angle += FP.angle_difference(-Math.atan2(player.y - y, player.x - x), sprIceTurret.angle / 180 * Math.PI) * 180 / Math.PI / angleSpeedDivisor;
						if (shootTimer > 0)
						{
							shootTimer--;
						}
						else if(hitsTimer <= 0)
						{
							shootTimer = shootTimerMax;
							sprIceTurret.play("startshot");
						}
					}
					else
					{
						shootTimer = shootTimerMax;
					}
				}
				if (sprIceTurret.currentAnim == "")
				{
					sprIceTurret.frame = 0;// Game.worldFrame(2);
				}
			}
			else if(!collide("Player", x, y))
			{
				type = "Solid";
			}
			layer = -(y - originY + height);
		}
		
		override public function render():void
		{
			var tpos:Point = new Point(x, y);
			x = Math.round(x);
			y = Math.round(y);
			super.render();
			x = tpos.x;
			y = tpos.y;
		}
		
		override public function layering():void
		{
			
		}
		
		override public function knockback(f:Number = 0, p:Point = null):void
		{
			
		}
		
		override public function hit(f:Number=0, p:Point=null, d:Number=1, t:String=""):void
		{
			if (sprIceTurret.currentAnim != "dead")
			{
				super.hit(f, p, d, t);
			}
		}
		
		override public function hitPlayer():void
		{
			if (sprIceTurret.currentAnim != "dead")
			{
				super.hitPlayer();
			}
		}
		
		override public function death():void
		{
			if (destroy)
			{
				if ((graphic as Spritemap).currentAnim == "dead")
				{
					super.death();
				}
				else
				{
					setHitbox(16, 16, 8, 8);
					(graphic as Spritemap).play("dead");
					destroy = false;
					solids.push("Enemy", "Player");
				}
			}
		}
		
		public function endAnim():void
		{
			switch(sprIceTurret.currentAnim)
			{
				case "startshot":
					sprIceTurret.play("finishshot");
					var a:Number = -sprIceTurret.angle / 180 * Math.PI;
					FP.world.add(new IceTurretBlast(x, y, new Point(shotSpeed * Math.cos(a), shotSpeed * Math.sin(a))));
					const distBtwnShots:int = 12;
					FP.world.add(new IceTurretBlast(x + distBtwnShots * Math.cos(a + Math.PI / 2), y + distBtwnShots * Math.sin(a + Math.PI / 2), new Point(shotSpeed * Math.cos(a), shotSpeed * Math.sin(a))));
					FP.world.add(new IceTurretBlast(x - distBtwnShots * Math.cos(a + Math.PI / 2), y - distBtwnShots * Math.sin(a + Math.PI / 2), new Point(shotSpeed * Math.cos(a), shotSpeed * Math.sin(a))));
					break;
				case "dead":
					break;
				default:
					sprIceTurret.play("");
			}
		}	
		
		public function bump(p:Point, t:String):void
		{
			if (sprIceTurret.currentAnim == "dead" && (t == "Fire" || t == "Pulse"))
			{
				var tTile:Point = new Point(Math.round(x / Tile.w), Math.round(y / Tile.h));
				var a:Number = Math.atan2( -(y - originY + height / 2) + p.y, p.x - (x - originX + width / 2));
				const bothRange:Number = 0.1; //This range determines when both horizontal and vertical movement will occur.
				if (Math.abs(Math.sin(a)) - bothRange < Math.abs(Math.cos(a)))
				{
					if (Math.cos(a) > 0)
					{
						tile.x = tTile.x - 1;
					}
					else
					{
						tile.x = tTile.x + 1;
					}
				}
				if (Math.abs(Math.sin(a)) > Math.abs(Math.cos(a)) - bothRange)
				{
					if (Math.sin(a) > 0)
					{
						tile.y = tTile.y - 1;
					}
					else
					{
						tile.y = tTile.y + 1;
					}
				}
				
			}
		}
		
		override public function input():void
		{
			if (sprIceTurret.currentAnim == "dead")
			{
				sprIceTurret.angle -= FP.angle_difference(Math.atan2(1, 0), -sprIceTurret.angle / 180 * Math.PI) * 180 / Math.PI / 10;
			}
			lTile = cTile; 
			cTile = new Point(Math.round(x / Tile.w), Math.round(y / Tile.h));
			if (x == cTile.x * Tile.w && y == cTile.y * Tile.h)//cTile.x != lTile.x || cTile.y != lTile.y)
			{
				var myTile:Tile = FP.world.nearestToPoint("Tile", x - originX + width/2, y - originY + height/2) as Tile;
				if (myTile)
				{
					if (myTile.t == 1 || myTile.t == 17 || myTile.t == 6) //Water && Lava && Pit
					{
						destroy = true;
					}
				}
			}
			v.x = moveSpeed * FP.sign(tile.x - cTile.x);
			if (v.x == 0)
			{
				x = Math.floor(x / Tile.w) * Tile.w + Tile.w/2;
			}
			v.y = moveSpeed * FP.sign(tile.y - cTile.y);
			if (v.y == 0)
			{
				y = Math.floor(y / Tile.h) * Tile.h + Tile.h/2;
			}
			
			if (x == Math.floor(x / Tile.w) * Tile.w + Tile.w/2 && y == Math.floor(y / Tile.h) * Tile.h + Tile.h/2)
			{
				if (v.length > 0 && !collideTypes(solids, x + v.x, y + v.y))
					Music.playSound("Push Rock", -1, 0.5);
			}
		}
		
	}

}