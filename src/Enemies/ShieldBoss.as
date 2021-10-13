package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import flash.display.BlendMode;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class ShieldBoss extends Enemy
	{
		[Embed(source = "../../assets/graphics/ShieldBoss.png")] private var imgShieldBoss:Class;
		private var sprShieldBoss:Spritemap = new Spritemap(imgShieldBoss, 56, 80, endAnim);
		
		private var tag:int;
		
		private const openShieldFrame:int = 2;
		private var retaliation:Boolean = false;
		private var stabbing:Boolean = false;
		private var activated:Boolean = false;
		
		private const swingForce:Number = 6;
		private const swingTimeMax:int = 120;
		private var swingTime:int = 0;
		
		private var playedSound:Boolean = false;
		
		public function ShieldBoss(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w * 1.5, _y + Tile.h * 2, sprShieldBoss);
			sprShieldBoss.centerOO();
			sprShieldBoss.add("sit", [0]);
			sprShieldBoss.add("stab", [3, 4, 5, 6, 7, 8], 15);
			sprShieldBoss.add("moveShield", [0, 1], 15); 
			sprShieldBoss.add("movedShield", [2], 2);
			sprShieldBoss.add("die", [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 15);
			
			sprShieldBoss.play("sit");
			
			tag = _tag;
			layer = -(y - sprShieldBoss.originY + sprShieldBoss.height);
			
			type = "ShieldBoss";
			
			setHitbox(48, 48, 24, 24);
			
			hitSoundIndex = 1; //Big hit sound
			dieSoundIndex = 1; //Big die sound
		}
		
		override public function check():void
		{
			super.check();
			if (tag >= 0 && !Game.checkPersistence(tag))
			{
				FP.world.remove(this);
			}
		}
		
		override public function startDeath(t:String=""):void
		{
			Game.setPersistence(tag, false);
			sprShieldBoss.play("die");
		}
		
		override public function update():void
		{
			var p:Player = FP.world.nearestToPoint("Player", x, y) as Player;
			if (p)
			{
				if (FP.distance(x, y, p.x, p.y) <= 96)
				{
					Game.levelMusics[(FP.world as Game).level] = Game.bossMusic;
				}
			}
			if (sprShieldBoss.currentAnim != "die")
			{
				super.update();
			}
			else
			{
				death();
			}
		}
		
		override public function death():void
		{
			if (destroy)
			{
				Game.levelMusics[(FP.world as Game).level] = -1;
				Main.unlockMedal(Main.badges[8]);
			}
			super.death();
		}
		
		override public function knockback(f:Number = 0, p:Point = null):void
		{
			
		}
		
		override public function hitPlayer():void
		{
			var p:Player = FP.world.collideRect("Player", x - originX, y - originY + height, width, Tile.h) as Player;
			if (sprShieldBoss.frame >= 5 && sprShieldBoss.frame <= 8)
			{
				if (p && !destroy)
				{
					p.hit(this, swingForce, new Point(x, y));
				}
			}
			if (p && sprShieldBoss.currentAnim == "sit")
			{
				swingTime++;
				if (swingTime >= swingTimeMax)
				{
					swingTime = 0;
					startStab(false);
				}
			}
			else
			{
				swingTime = 0;
			}
		}
		
		override public function hit(f:Number=0, p:Point=null, d:Number=1, t:String=""):void
		{
			if (!activated)
			{
				activated = true;
				return;
			}
			if (sprShieldBoss.currentAnim == "movedShield")
			{
				super.hit(f, p, d, t);
				sit();
			}
			else
			{
				if (!playedSound)
				{
					Music.playSound("Metal Hit");
					playedSound = true;
				}
				startStab(true);
			}
		}
		
		override public function render():void
		{
			if (destroy)
			{
				return;
			}
			if (sprShieldBoss.currentAnim == "die")
			{
				sprShieldBoss.blend = BlendMode.HARDLIGHT;
			}
			else
			{
				sprShieldBoss.blend = BlendMode.NORMAL;
			}
			super.render();
		}
		
		public function startStab(_retaliation:Boolean=false):void
		{
			if (hitsTimer <= 0 && sprShieldBoss.currentAnim == "sit")
			{
				stabbing = true;
				retaliation = _retaliation;
				sprShieldBoss.play("moveShield");
			}
		}
		
		public function sit():void
		{
			if (sprShieldBoss.currentAnim != "die")
			{
				sprShieldBoss.play("sit");
				stabbing = false;
				retaliation = false;
			}
		}
		
		public function endAnim():void
		{
			playedSound = false;
			if (stabbing)
			{
				switch(sprShieldBoss.currentAnim)
				{
					case "moveShield":
						if (retaliation)
						{
							sprShieldBoss.play("stab");
						}
						else
						{
							sprShieldBoss.play("movedShield");
						}
						break;
					case "movedShield":
						sprShieldBoss.play("stab");
						break;
					case "stab":
						sit();
						break;
					default:
				}
			}
			if (sprShieldBoss.currentAnim == "die")
			{
				destroy = true;
			}
		}
	}

}