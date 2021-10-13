package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import Puzzlements.RockLock;
	import Scenery.Pod;
	import Scenery.RockFall;
	import Scenery.Tile;
	import Puzzlements.Button;
	
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * ...
	 * @author Time
	 */
	public class FinalBoss extends Enemy
	{
		[Embed(source = "../../assets/graphics/FinalBoss.png")] private var imgFinalBoss:Class;
		private var sprFinalBoss:Spritemap = new Spritemap(imgFinalBoss, 16, 16, endAnim);
		[Embed(source = "../../assets/graphics/NPCs/OwlPic.png")] private var imgOwlPic:Class;
		private var sprOwlPic:Spritemap = new Spritemap(imgOwlPic, 16, 16, endAnim);
		
		public var moveSpeed:Number = 1;
		public var sitFrames:Array = new Array(0, 1, 2, 3);
		public var sitLoops:Number = 1;
		private const lavaForce:int = 6;
		
		private const rockfallTimeMax:int = 240;
		private var rockfallTime:int = -1;
		
		private const podPositions:Array = new Array(new Point(120, 56), new Point(48, 128), new Point(120, 200), new Point(192, 128));
		private var pods:Vector.<Pod> = new Vector.<Pod>();
		private var cpod:int = 0; // The pod that you're currently going to
		private var hitThisSequence:Boolean = false;
		
		private var tag:int;
		
		private var started:Boolean = false;
		
		public function FinalBoss(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w / 2, _y + Tile.h / 2, sprFinalBoss);
			sprFinalBoss.centerOO();
			sprFinalBoss.add("walk", [0, 1, 2, 3], 15);
			sprFinalBoss.add("die", [4, 5, 6, 7, 8, 9, 10, 11], 5);
			sprFinalBoss.add("dead", [11, 11], 1);
			sprFinalBoss.add("deadframe", [11]);
			sprFinalBoss.play("");
			
			setHitbox(12, 12, 6, 6);
			
			tag = _tag;
			
			activeOffScreen = true;
			canFallInPit = false;
			dieInWater = false;
			dieInLava = false; //Handled manually
			onlyHitBy = "Lava";
			justKnock = true;
			
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
			for (var i:int = 0; i < podPositions.length; i++)
			{
				var pod:Pod = collide("Pod", podPositions[i].x, podPositions[i].y) as Pod;
				if (pod)
				{
					pods.push(pod);
				}
			}
		}
		
		override public function update():void
		{
			if (!started)
			{
				Game.talking = true;
				Game.talkingText = "EEEEP!";
				Game.talkingPic = sprOwlPic;
				Game.freezeObjects = true;
				Game.cameraTarget = new Point(Math.max(Math.min(x - FP.screen.width/2, FP.width-FP.screen.width), 0), Math.max(Math.min(y - FP.screen.height/2, FP.height-FP.screen.height), 0));
				var p:Player = FP.world.nearestToEntity("Player", this) as Player;
				if (p)
				{
					if (Input.released(p.keys[6]))
					{
						Game.talking = false;
						Game.talkingText = "";
						Game.talkingPic = null;
						Game.freezeObjects = false;
						Game.resetCamera();
						started = true;
						Game.levelMusics[(FP.world as Game).level] = Game.bossMusic;
					}
				}
			}
			
			super.update();
			if (Game.freezeObjects || destroy)
			{
				return;
			}
			
			var tile:Tile = collide("Tile", x, y) as Tile;
			if (tile && tile.t == 17 /*Lava*/ && !hitThisSequence)
			{
				maxForce = -1;
				hit(lavaForce, new Point(FP.width / 2, (FP.height - Tile.h) / 2), 1, "Lava");
				maxForce = 2;
				hitThisSequence = true;
				return;
			}
			
			if (v.length > 4)
			{
				v.normalize(4);
			}
			
			canHit = rockfallTime < 0;
			if (rockfallTime > 0)
			{
				rockfallTime--;
				sprFinalBoss.play("");
				const rockFrequency:int = 6;
				const stepsAhead:int = -15;
				const radius:int = 20;
				p = FP.world.nearestToEntity("Player", this) as Player;
				if (p)
				{
					if (!Math.floor(Math.random() * rockFrequency))
					{
						FP.world.add(new RockFall(p.x + p.v.x * stepsAhead + Math.random() * radius * 2 - radius, p.y + p.v.y * stepsAhead + Math.random() * radius * 2 - radius));
					}
				}
			}
			else if (rockfallTime == 0)
			{
				pods[cpod].open = true;
				cpod = (cpod + 1 + pods.length) % pods.length;
				hitThisSequence = false;				
				rockfallTime--;
			}
			else if (v.length <= moveSpeed)
			{
				const grenadeFrequency:int = 40;
				if (!Math.floor(Math.random() * grenadeFrequency))
				{
					FP.world.add(new Grenade(x - 8, y - 8, true, 30));
				}
				
				var to:Point = new Point(pods[cpod].x - x, pods[cpod].y - y);
				to.normalize(moveSpeed);
				v = to;
				sprFinalBoss.play("walk");
				var pod:Pod = collide("Pod", x, y) as Pod;
				if (pod == pods[cpod])
				{
					if (!pods[cpod].open)
					{
						pods[cpod].open = true;
					}
					if (FP.distance(x, y, pod.x, pod.y) <= v.length * 2)
					{
						x = pod.x;
						y = pod.y+1;
						rockfallTime = rockfallTimeMax;
						pods[cpod].open = false;
					}
				}
			}
			
			if (sprFinalBoss.currentAnim == "")
			{
				sprFinalBoss.frame = sitFrames[Game.worldFrame(sitFrames.length, sitLoops)];
			}
			
			layer = -(y-originY+height);
		}
		
		override public function removed():void
		{
			super.removed();
			if (Game.checkPersistence(tag))
			{
				Game.setPersistence(tag, false);
				Main.unlockMedal("Fall of the Owl");
			}
		}
		
		public function endAnim():void
		{
			switch(sprFinalBoss.currentAnim)
			{
				case "walk":
					sprFinalBoss.play("");
					break;
				case "die":
					sprFinalBoss.play("dead");
					break;
				case "dead":
					const n:int = 5;
					for (var i:int = 0; i < n; i++)
					{
						FP.world.add(new RockFall(120 + Math.random() * 8 - 4, i / n * Tile.h * 2));
					}
					Button.activateAll(null, 0, true);
					if (Game.checkPersistence(tag))
					{
						Game.setPersistence(tag, false);
						Game.setPersistence(tag+1, false);
						Main.unlockMedal(Main.badges[9]);
					}
					sprFinalBoss.play("deadframe");
					break;
				default:
			}
		}
		
		override public function startDeath(t:String=""):void
		{
			type = "Solid";
			sprFinalBoss.play("die");
			Game.levelMusics[(FP.world as Game).level] = -1;
			destroy = true;
		}
		
		override public function death():void
		{
		}
		
	}

}