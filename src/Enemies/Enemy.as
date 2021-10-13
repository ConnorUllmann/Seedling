package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import Pickups.HealthPickup;
	import Projectiles.Explosion;
	import Scenery.SlashHit;
	import Scenery.Tile;
	import Pickups.Coin;
	/**
	 * ...
	 * @author Time
	 */
	public class Enemy extends Mobile
	{
		public var damage:int = 1; //The amount of damage this will do when it hits the player
		public var hits:Number = 0;
		public var hitsMax:int = 3;
		public var hitsTimer:int = 0;
		public var hitsTimerMax:int = 30;
		public const hitsTimerInt:int = 10;
		public var hitsColor:uint = 0xFF0000;
		public var normalColor:uint = 0xFFFFFF;
		public var hitByDarkStuff:Boolean = false;
		
		private const coins:int = 4 + Math.random() * 4; //The number of coins to throw upon death
		private const healths:int = 1;
		
		public var canFallInPit:Boolean = true;
		public var fallInPit:Boolean = false;
		public const fallSpinSpeed:int = 8 * FP.choose(-1, 1);
		public const fallAlphaSpeed:Number = 0.05;
		
		public var hitByFire:Boolean = false;
		public var dieInWater:Boolean = true;
		public var dieInLava:Boolean = true;
		public var canHit:Boolean = true;
		public var justKnock:Boolean = false; //If the enemy is hit, only bump him, don't hurt him.
		
		public var fell:Boolean = false;
		public var activeOffScreen:Boolean = false;
		
		public var onlyHitBy:String = "";
		public var maxForce:Number = -1;
		
		public var hitSound:String = "Enemy Hit";
		public var hitSoundIndex:int = 0; //0 = small, 1 = big
		public var dieSound:String = "Enemy Die";
		public var dieSoundIndex:int = 0; //0 = small, 1 = big
		
		public function Enemy(_x:int, _y:int, _g:Graphic=null) 
		{
			super(_x, _y, _g);
			type = "Enemy";
			//solids.push("Shield");
		}
		
		override public function update():void
		{
			if (!activeOffScreen && !onScreen())
			{
				return;
			}
			var state:int = getState();
			switch(state)
			{
				case 1: //Water
					if (dieInWater)
					{
						destroy = true;
					}
					break;
				case 6:
					if (canFallInPit && !fallInPit)
					{
						Music.playSoundDistPlayer(x, y, "Enemy Fall");
						fallInPit = true;
					}
					break;
				case 17: //Lava
					if (dieInLava)
					{
						destroy = true;
					}
					break;
				default:
			}
			if (!destroy && fallInPit && canFallInPit)
			{
				x += (Math.floor(x / Tile.w) * Tile.w + Tile.w / 2 - x) / 10;
				y += (Math.floor(y / Tile.h) * Tile.h + Tile.h / 2 - y) / 10;
				(graphic as Image).angle += fallSpinSpeed;
				(graphic as Image).alpha -= fallAlphaSpeed;
				if ((graphic as Image).alpha <= 0)
				{
					destroy = true;
					fell = true;
				}
			}
			else
			{
				super.update();
				if (!destroy)
				{
					hitUpdate();
					hitPlayer();
				}
			}
			
			/*if (x > FP.width || x < 0 || y < 0 || y > FP.height)
			{
				destroy = true;
			}*/
		}
		
		public function dropCoins():void
		{
			const l:Number = 2;
			var astart:Number = Math.random() * Math.PI * 2;
			for (var i:int = 0; i < coins; i++)
			{
				var a:Number = i / coins * Math.PI * 2 + astart;
				FP.world.add(new Coin(x, y, new Point(l * Math.cos(a), l * Math.sin(a))));
			}
		}
		
		public function getState(_yOffset:Number = 0):int
		{
			var tile:Tile = FP.world.nearestToPoint("Tile", x, y + _yOffset) as Tile;
			if (tile)
			{
				return tile.t;
			}
			return 0;
		}
		
		public function hit(f:Number=0, p:Point=null, d:Number=1, t:String=""):void
		{
			if (maxForce >= 0)
			{
				f = Math.min(f, maxForce);
			}
			if ((hitsTimer <= 0 || hitByDarkStuff) && !Game.freezeObjects && canHit)
			{
				if (onlyHitBy == "" || onlyHitBy == t)
				{
					if (hitByFire || t != "Fire")
					{
						if (hits < hitsMax)
						{
							hits += d;
							hitsTimer = hitsTimerMax;
							hitByDarkStuff = (t == "Shield" || t == "Suit");
							if (hits >= hitsMax)
							{
								Music.playSoundDistPlayer(x, y, dieSound, dieSoundIndex);
								startDeath(t);
							}
							else
							{
								Music.playSoundDistPlayer(x, y, hitSound, hitSoundIndex);
								knockback(f, p);
							}
						}
					}
					else
					{
						//hitsTimer = hitsTimerMax;
						knockback(f, p);
					}
				}
				else if (justKnock)
				{
					knockback(f, p);
				}
			}
		}
		
		public function startDeath(t:String=""):void
		{
			destroy = true;
			dieEffects(t);
		}
		
		public function dieEffects(t:String, _sc:Number=0, _xoff:int=0, _yoff:int=0):void
		{
			const g:Spritemap = graphic as Spritemap;
			if (!g)
				return;
			if (_sc == 0)
			{
				_sc = Math.max(g.width, g.height) * Math.max(g.scaleX, g.scaleY) * g.scale;
			}
			switch(t)
			{
				case "Sword":
				case "Spear":
					FP.world.add(new SlashHit(x + _xoff, y + _yoff, _sc));
					break;
				case "Wand":
					FP.world.add(new Explosion(x + _xoff, y + _yoff, ["Player", "Enemy"], Math.max(width, height), 1));
					break;
				default:
			}
		}
		
		public function hitPlayer():void
		{
			if (!destroy && (!(graphic is Spritemap) || (graphic as Spritemap).currentAnim != "die") && hitsTimer <= 0)
			{
				var p:Player = collide("Player", x, y) as Player;
				if (p)
				{
					p.hit(this, 3, new Point(x, y), damage);
				}
			}
		}
		
		public function hitUpdate():void
		{
			if (hitsTimer > 0)
			{
				if (hitsTimer % hitsTimerInt == 0)
				{
					if ((graphic as Image).color == normalColor)
					{
						(graphic as Image).color = hitsColor;
					}
					else
					{
						(graphic as Image).color = normalColor;
					}
				}
				hitsTimer--;
				if (hitsTimer <= 0)
				{
					(graphic as Image).color = normalColor;
					//watch out--this is a color resetter
				}
			}
		}
		
		public function knockback(f:Number=0,p:Point=null):void
		{
			if (p && !destroy && (!(graphic is Spritemap) || (graphic as Spritemap).currentAnim != "die"))
			{
				var a:Number = Math.atan2(y - p.y, x - p.x);
				v.x += f * Math.cos(a);
				v.y += f * Math.sin(a);
			}
		}
		
	}

}