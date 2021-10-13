package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import flash.display.BlendMode;
	import Projectiles.LavaBall;
	import Scenery.Tile;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class LavaBoss extends Enemy
	{
		[Embed(source = "../../assets/graphics/LavaBoss.png")] private var imgLavaBoss:Class;
		private var sprLavaBoss:Spritemap = new Spritemap(imgLavaBoss, 160, 82, endAnim);
		
		private const shotSpeed:int = 1;
		private var tag:int;
		private var lastHitType:String = "";
		private var startAttacking:Boolean = false;
		
		public function LavaBoss(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + 48, _y + 40, sprLavaBoss);
			sprLavaBoss.centerOO();
			sprLavaBoss.add("sit", [0, 1,2,3,4], 8);
			sprLavaBoss.add("smash", [5, 6, 7, 8, 9], 10);
			sprLavaBoss.add("smashback", [10, 11, 12, 6, 5], 10);
			sprLavaBoss.add("armsup", [6, 7, 13, 14, 14, 14, 14], 10); 
			sprLavaBoss.add("sweep", [13, 15, 16], 10);
			sprLavaBoss.add("sweepback", [17, 16, 15, 6, 5], 10);
			sprLavaBoss.add("hit", [18, 19], hitsTimerInt);
			sprLavaBoss.add("hitplayer", [20], hitsTimerInt);
			sprLavaBoss.add("die", [21, 22, 23, 24, 25, 26, 27], 5);
			sprLavaBoss.add("dead", [27]);
			
			sprLavaBoss.play("sit");
			
			tag = _tag;
			layer = -(y - sprLavaBoss.originY + sprLavaBoss.height);
			
			type = "LavaBoss";
			
			setHitbox(64, 58, 32, 29);
			
			activeOffScreen = true;
			dieInLava = false;
			
			hitsTimerMax = 120;
			
			(FP.world as Game).playerPosition = new Point(152, 176);
			
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
		
		override public function removed():void
		{
			Game.resetCamera();
		}
		
		
		override public function update():void
		{			
			sprLavaBoss.active = !Game.freezeObjects && startAttacking;
			if (!Game.freezeObjects && !destroy)
			{
				if (startAttacking)
				{
					super.update();
					if (hitsTimer > 0)
					{
						if (lastHitType == "LavaBall")
						{
							sprLavaBoss.play("hit");
						}
						else
						{
							sprLavaBoss.play("hitplayer");
						}
					}
					else
					{
						if (sprLavaBoss.currentAnim == "hit" || sprLavaBoss.currentAnim == "hitplayer")
						{
							sprLavaBoss.play("sit");
						}
					}
				}
				var p:Player = FP.world.nearestToPoint("Player", x, y) as Player;
				if (p && !p.fallFromCeiling && (Math.abs(y - p.y) <= FP.screen.height * 3 / 4 && Math.abs(x - p.x) <= FP.screen.width * 3 / 4))
				{
					Game.cameraTarget = new Point((x + p.x) / 2 - FP.screen.width / 2, (y + p.y) / 2 - FP.screen.height / 2);
					if (!startAttacking)
					{
						startAttacking = true;
						Game.levelMusics[(FP.world as Game).level] = Game.bossMusic;
					}
				}
				else
				{
					Game.resetCamera();
				}
			}
		}
		
		override public function knockback(f:Number = 0, p:Point = null):void
		{
		}
		
		override public function layering():void
		{
		}
		
		override public function hitPlayer():void
		{
		}
		
		override public function startDeath(t:String=""):void
		{
			destroy = true;
			sprLavaBoss.play("die");
			sprLavaBoss.color = 0xFFFFFF;
			if (Game.checkPersistence(tag))
			{
				Game.setPersistence(tag, false);
				Main.unlockMedal(Main.badges[11]);
			}
			Game.levelMusics[(FP.world as Game).level] = -1;
		}
		
		override public function hit(f:Number=0, p:Point=null, d:Number=1, t:String=""):void
		{
			if (((hitsTimer <= 0 && t == "LavaBall") || hitByDarkStuff || (t != "LavaBall" && lastHitType == "LavaBall" && hitsTimer > 0)) && !Game.freezeObjects && canHit)
			{
				if (hitByFire || t != "Fire")
				{
					if (hits < hitsMax)
					{
						if ( t != "LavaBall")
						{
							hits += 1;
						}
						hitsTimer = hitsTimerMax;
						hitByDarkStuff = (t == "Shield" || t == "Suit");
						if (hits >= hitsMax)
						{
							startDeath();
						}
						else
						{
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
			lastHitType = t;
		}
		
		override public function render():void
		{
			super.render();
			
			if (sprLavaBoss.currentAnim == "armsup" ||
				sprLavaBoss.currentAnim == "sweep")
			{
				var n:Number = 0.2;
				sprLavaBoss.scale = 1 + Math.random() * n - n;
			}
			if (!destroy)
			{
				sprLavaBoss.alpha = 0.8;
			}
			else if (sprLavaBoss.currentAnim == "dead")
			{
				sprLavaBoss.alpha -= 0.01;
				if (sprLavaBoss.alpha <= 0)
				{
					FP.world.remove(this);
				}
			}
			Draw.setTarget((FP.world as Game).solidBmp, FP.camera);
			super.render();
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
			
			if (!destroy)
			{
				sprLavaBoss.scale = 1;
				sprLavaBoss.alpha = 1;
			}
		}
		
		public function endAnim():void
		{
			switch(sprLavaBoss.currentAnim)
			{
				case "sit":
					sprLavaBoss.play("smash");
					break;
				case "smash":
					sprLavaBoss.play("smashback");
					Music.playSound("Lava", 0);
					
					var xpos:Object = [ -34, 34];
					var ypos:Object = [32, 32];
					for (var i:int = 0; i < xpos.length; i++)
					{
						//This area covered must be >= the area covered by the hitbox of the lava runner, 
						//or else they will stick on top of one another.
						if (!FP.world.collideRect("Enemy", x + xpos[i] - Tile.w / 2, y + ypos[i] - Tile.h/2, Tile.w, Tile.h))
						{
							var lr:LavaRunner;
							FP.world.add(lr = new LavaRunner(x + xpos[i] - Tile.w / 2, y + ypos[i] - Tile.h / 2));
							lr.runRange = 1000;
							lr.activeOffScreen = true;
							lr.jump(!Boolean(i));
						}
					}
					break;
				case "smashback":
					sprLavaBoss.play("armsup");
					break;
				case "armsup":
					sprLavaBoss.play("sweep");
					break;
				case "sweep":
					sprLavaBoss.play("sweepback");
					Game.shake = 15;
					Music.playSound("Lava", 1);
					
					const numLavaBalls:int = 5;
					const angle:Number = Math.PI;
					for (i = 0; i < numLavaBalls; i++)
					{
						var ang:Number = -angle / 2 + i / (numLavaBalls - 1) * angle + Math.PI/2;
						FP.world.add(new LavaBall(x, y + 32, new Point(shotSpeed * Math.cos(ang), shotSpeed * Math.sin(ang))));
					}
					break;
				case "hit":
					sprLavaBoss.play("sit");
					break;
				case "die":
					sprLavaBoss.play("dead");
					break;
				case "dead":
					break;
				default:
					sprLavaBoss.play("sit");
			}
			if (sprLavaBoss.currentAnim == "die")
			{
				destroy = true;
			}
		}
	}

}