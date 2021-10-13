package Enemies 
{
	import adobe.utils.CustomActions;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.masks.Pixelmask;
	import Scenery.Tile;
	import Puzzlements.Whirlpool;
	/**
	 * ...
	 * @author Time
	 */
	public class TentacleBeast extends Enemy
	{
		[Embed(source = "../../assets/graphics/TentacleBeastMask.png")] private var imgTentacleBeastMask:Class;
		[Embed(source = "../../assets/graphics/TentacleBeast.png")] private var imgTentacleBeast:Class;
		private var sprTentacleBeast:Spritemap = new Spritemap(imgTentacleBeast, 46, 44, animEnd);
		
		private const sittingFrames:Array = new Array(0, 1, 2, 1);
		private const sittingDeadFrames:Array = new Array(17, 18, 19, 18);
		private const spawnRect:Rectangle = new Rectangle(16, 96, 176, 96);
		private const distActivate:int = 48;
		
		private const tentacleMargin:Rectangle = new Rectangle(8, 0, 8, 4); //2x2 point specifying left margin, up margin, right margin, down margin
		private const whirlpoolMargin:Rectangle = new Rectangle(Tile.w, Tile.h, Tile.w, Tile.h);
		
		public var maxTentacles:int = 8;
		public var maxWhirlpools:int = 1;
		private var activated:Boolean = false;
		private var dead:Boolean = false;
		
		private var tag:int;
		
		public function TentacleBeast(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + 24, _y + 24, sprTentacleBeast);
			sprTentacleBeast.add("sink", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 8);
			sprTentacleBeast.add("rise", [11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0], 8);
			sprTentacleBeast.add("under", [12]);
			sprTentacleBeast.add("dying", [13, 14, 15, 16], 2);
			sprTentacleBeast.centerOO();
			
			mask = new Pixelmask(imgTentacleBeastMask, -23, -22);
			type = "Solid";
			
			layer = -(y - sprTentacleBeast.originY + 46);
			
			tag = _tag;
			
			if (tag >= 0 && !Game.checkPersistence(tag))
			{
				sprTentacleBeast.play("");
				dead = true;
				maxTentacles = 0;
				maxWhirlpools = 0;
				activated = true;
				createMouthEntrance();
			}
			else
			{
				sprTentacleBeast.play("under");
			}
		}
		
		override public function check():void
		{
			super.check();
			if (dead)
			{
				sprTentacleBeast.frame = 17;
			}
		}
		
		override public function update():void
		{
			if (Game.freezeObjects)
				return;
			
			var player:Player = FP.world.nearestToEntity("Player", this) as Player;
			if (player && !activated && FP.distance(x, y, player.x, player.y) <= distActivate && !player.fallFromCeiling)
			{
				sprTentacleBeast.play("rise");
				Game.levelMusics[(FP.world as Game).level] = Game.bossMusic;
				Music.playSound("Boss Die", 3, 0.2);
				activated = true;
			}
			if (sprTentacleBeast.currentAnim == "rise")
			{
				Game.shake = 5;
			}
			if (!dead && maxTentacles <= 0)
			{
				sprTentacleBeast.play("dying");
				Music.playSound("Boss Die", 4, 0.2);
				Game.levelMusics[(FP.world as Game).level] = -1;
				dead = true;
				if (Game.checkPersistence(tag))
				{
					Main.unlockMedal(Main.badges[7]);
					Game.setPersistence(tag, false);
				}
			}
			if (sprTentacleBeast.currentAnim == "")
			{
				if (dead)
				{
					sprTentacleBeast.frame = sittingDeadFrames[Game.worldFrame(sittingFrames.length, 2)];
				}
				else
				{
					sprTentacleBeast.frame = sittingFrames[Game.worldFrame(sittingFrames.length)];
				}
			}
			if (activated && !dead)
			{
				if (sprTentacleBeast.currentAnim == "")
				{
					var cont:Boolean = true;
					var xpos:int;
					var ypos:int;
					var cWhirl:Whirlpool;
					var cTent:Tentacle;
					
					const whirlpoolDist:int = 16 + Tile.w * 2; //Radii of both whirlpools, plus the minimum margin in between them
					var vW:Vector.<Whirlpool> = new Vector.<Whirlpool>();
					FP.world.getClass(Whirlpool, vW);
					
					const tentacleDistance:int = 32;
					var v:Vector.<Tentacle> = new Vector.<Tentacle>();
					FP.world.getClass(Tentacle, v);
					
					var tries:int = 0;
					var created:int = 0;
					while (FP.world.classCount(Whirlpool) + created < maxWhirlpools && tries <= 100)
					{
						xpos = Math.random() * (spawnRect.width - whirlpoolMargin.x - whirlpoolMargin.width) + spawnRect.x + whirlpoolMargin.x;
						ypos = Math.random() * (spawnRect.height - whirlpoolMargin.y - whirlpoolMargin.height) + spawnRect.y + whirlpoolMargin.y;
						
						for each (cTent in v)
						{
							if (FP.distance(xpos, ypos, cTent.x, cTent.y) <= whirlpoolDist)
							{
								cont = false;
								break;
							}
						}
						for each(cWhirl in vW)
						{
							if (FP.distance(xpos, ypos, cWhirl.x, cWhirl.y) <= whirlpoolDist)
							{
								cont = false;
								break;
							}
						}
						if (cont)
						{
							FP.world.add(new Whirlpool(xpos - Tile.w, ypos - Tile.h, true));
							created++;
						}
						tries++;
					}
					cont = true;
					if (FP.world.classCount(Tentacle) < maxTentacles)
					{
						xpos = Math.random() * (spawnRect.width - tentacleMargin.x - tentacleMargin.width) + spawnRect.x + tentacleMargin.x;
						ypos = Math.random() * (spawnRect.height - tentacleMargin.y - tentacleMargin.height) + spawnRect.y + tentacleMargin.y;
						
						for each (cTent in v)
						{
							if (FP.distance(xpos, ypos, cTent.x, cTent.y) <= tentacleDistance)
							{
								cont = false;
								break;
							}
						}
						for each (cWhirl in vW)
						{
							if (FP.distance(xpos, ypos, cWhirl.x, cWhirl.y) <= whirlpoolDist) //Tile.w as radii of whirlpool
							{
								cont = false;
								break;
							}
						}
						if (cont)
						{
							FP.world.add(new Tentacle(xpos, ypos, this, xpos < FP.width / 2));
						}
					}
				}
			}
		}
		
		public function animEnd():void
		{
			switch(sprTentacleBeast.currentAnim)
			{
				case "rise":
					sprTentacleBeast.play("");
					break;
				case "dying":
					sprTentacleBeast.play("");
					//Teleporter to the tentacle beast's mouth
					createMouthEntrance();
					break;
				default:
			}
		}
		
		public function createMouthEntrance():void
		{
			FP.world.add(new Teleporter(x - Tile.w / 2, y - Tile.h / 2, 58, 56, 96));
		}
		
	}

}