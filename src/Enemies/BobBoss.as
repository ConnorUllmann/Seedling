package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import NPCs.BobBossNPC;
	import Pickups.Fire;
	import Scenery.Tile;
	import net.flashpunk.Entity;
	/**
	 * ...
	 * @author Time
	 */
	public class BobBoss extends BobSoldier
	{
		[Embed(source = "../../assets/graphics/BobBoss1.png")] private static const imgBobBoss1:Class;
		[Embed(source = "../../assets/graphics/BobBoss2.png")] private static const imgBobBoss2:Class;
		[Embed(source = "../../assets/graphics/BobBoss3.png")] private static const imgBobBoss3:Class;
		private static const images:Array = new Array(imgBobBoss1, imgBobBoss2, imgBobBoss3);
		
		[Embed(source = "../../assets/graphics/BobBossWeapons.png")] private var imgBobBossWeapons:Class;
		private var sprBobBossWeapons:Spritemap = new Spritemap(imgBobBossWeapons, 24, 5);
		
		private var bossType:int;
		
		private const nextBossTimerMax:int = 120;
		private var nextBossTimer:int = nextBossTimerMax; //The time between bosses.
		
		private const formingTimerMax:int = 60;
		private var formingTimer:int = formingTimerMax; //The time after creation that this boss does its animation before beginning its actions.
		
		private const text:Array = new Array("..., ...?~...~...!", "...never...~ages...~...seen...~...odd.~...for...minutes?~seconds...hours...~mine!", "Time is stasis.~You bring much conflict.~Is it my place to resist?~Seems I must.");
		
		public function BobBoss(_x:int, _y:int, _st:int=0) 
		{
			//Tile offsets are multiplied by the BobSoldier constructor
			super(_x, _y, new Spritemap(images[_st], 20, 20, endAnim));
			if (Player.hasFire)
			{
				FP.world.remove(this);
				return;
			}
			
			Game.levelMusics[(FP.world as Game).level] = Game.bossMusic;
			
			bossType = _st;
			
			weapon = sprBobBossWeapons;
			sprBobBossWeapons.y = -3;
			sprBobBossWeapons.originY = -sprBobBossWeapons.y;
			sprBobBossWeapons.frame = _st;
			weaponLength = sprBobBossWeapons.width;
			
			swordSpinRate = -swordSpinRate;
			switch(bossType)
			{
				case 0:
					swordSpinRate /= 4;
					damage = 2;
					hitsMax = 2;
					moveSpeed = 0.5;
					(graphic as Spritemap).rate = 1 / 4;
					break;
				case 1:
					swordSpinRate /= 3;
					swords = 2;
					moveSpeed = 0.65;
					(graphic as Spritemap).rate = 1 / 2;
					break;
				case 2:
					swordSpinRate /= 2;
					hitsMax = 2;
					swordSpinResetTimerMax = 0;
					swords = 2;
					moveSpeed = 0.5;
					break;
				default:
			}
			(graphic as Spritemap).alpha = 0;
			
			setHitbox(14, 14, 7, 7);
			
			FP.world.add(new BobBossNPC(_x, _y, bossType, text[bossType], 6));
			
			canFallInPit = false; //So that he doesn't fall in the pit while flying off of the screen when killed.
			
			activeOffScreen = true;
			
			hitSoundIndex = 1; //Big hit sound
			hopSoundIndex = 1; //Big hop sound
			dieSoundIndex = 1; //Bit die sound
		}
		
		override public function update():void
		{
			if (Player.hasFire)
			{
				FP.world.remove(this);
				return;
			}
			if (Game.freezeObjects)
				return;
			if (formingTimer > 0)
			{
				formingTimer--;
				(graphic as Spritemap).alpha = 1 - formingTimer / formingTimerMax;
				(graphic as Spritemap).scale = 1 + formingTimer / formingTimerMax;
				var v:int = 255 * (1 - formingTimer / formingTimerMax);
				(graphic as Spritemap).color = FP.getColorRGB(v, 255, v);
			}
			else
			{
				super.update();
			}
			standingAnimation();
		}
		
		override public function render():void
		{
			if (Player.hasFire)
				return;
			super.render();
		}
		
		override public function swordSpinningBeginCheck(d:int=0):void
		{
			if (!swordSpinning)
			{
				if (swordSpinResetTimer > 0)
				{
					swordSpinResetTimer--;
				}
				else
				{
					swordSpinningBegin();
				}
			}
		}
		
		override public function swordSpinningStep(player:Player):void
		{
			if (swordSpinning)
			{								
				switch(bossType)
				{
					case 0:
						swordSpin[swordIndex] += swordSpinRate;
						break;
					case 1:
						swordSpin[0] += swordSpinRate;
						swordSpin[1] += swordSpinRate / 4;
						break;
					case 2:
						swordSpin[swordIndex] += swordSpinRate;
						var ang:Number = Math.PI * 2;
						if (Math.abs(swordSpin[swordIndex] - swordSpinBegin[swordIndex]) >= ang)
						{
							swordSpinningStop(swordSpin[swordIndex]);
						}
						break;
					default:
				}
			}
		}
		
		override public function hit(f:Number=0, p:Point=null, d:Number=1, t:String=""):void
		{
			if (hitsTimer <= 0 && bossType == 2 && !Game.freezeObjects)
			{
				swords++;
				for (var i:int = 0; i < swords; i++)
				{
					swordSpinBegin[i] = Math.PI * 3 / 2 + 2 * Math.PI / swords * i;
					swordSpin[i] = swordSpinBegin[i];
				}
			}
			super.hit(0, null, d, t);
		}
		
		override public function death():void
		{
			if (destroy)
			{
				var player:Player = FP.world.nearestToPoint("Player", x, y, true) as Player;
				if(nextBossTimer <= 0 || !player)
				{
					if (bossType < 2)
					{
						FP.world.add(new BobBoss(FP.width/2 - Tile.w/2, FP.height / 2 - Tile.h/2, bossType + 1));
					}
					else
					{
						FP.world.add(new Fire(FP.width / 2 - Tile.w / 2, FP.height / 2 - Tile.h / 2, -1));
						Game.levelMusics[(FP.world as Game).level] = -1;
						Main.unlockMedal(Main.badges[5]);
					}
					FP.world.remove(this);
					player.receiveInput = true;
					player.hits = 0;
					player.directionFace = -1;
					(player.graphic as Image).color = 0xFFFFFF;
					return;
				}
				if (nextBossTimer > 0)
				{
					nextBossTimer--;
					(graphic as Spritemap).scaleX /= 1.1;
					(graphic as Spritemap).scaleY += 0.1;
					swords = 0;
					v.y = Math.min(0, v.y);
					v.y -= 1.2;
					y += v.y;
					(player.graphic as Image).color = FP.getColorRGB(255 * (1 - nextBossTimer / nextBossTimerMax), 255 * (1 - nextBossTimer / nextBossTimerMax), 255);
					
					
					if(nextBossTimer <= nextBossTimerMax / 3)
					{
						player.x = FP.width / 2;
						player.y = FP.height - 40;
						(player.graphic as Image).alpha = 1 - nextBossTimer / (nextBossTimerMax/3);
					}
					else
					{
						(player.graphic as Image).alpha = (nextBossTimer - nextBossTimerMax / 3) / (nextBossTimerMax - nextBossTimerMax / 3);
					}
					player.receiveInput = false;
					player.directionFace = 1;
				}
				//FP.console.log(nextBossTimer + " / " + nextBossTimerMax);
			}
		}
	}
}