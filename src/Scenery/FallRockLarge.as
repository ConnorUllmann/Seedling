package Scenery 
{
	import Enemies.BobBoss;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import Puzzlements.Activators;
	import Scenery.Tile;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 * 
	 */
	public class FallRockLarge extends Activators
	{
		[Embed(source = "../../assets/graphics/FallRockLarge.png")] private var imgRockLarge:Class;
		private var sprRock:Image = new Image(imgRockLarge);
		
		private var bossRock:Boolean;
		private var thirdBoss:Boolean;
		
		private var tag:int;
		
		private var trigger:Boolean = false;
		
		private const fallRate:Number = 0.6;
		private var vy:Number = 0;
		private var fallTo:int;
		
		private const cameraTimerMax:int = 90; // The length of time that the camera focuses after this hits
		private var cameraTimer:int = -1;
		
		private const waitToFallTimerMax:int = 60; // The length of time before the rock falls
		private var waitToFallTimer:int = 0;
		
		public function FallRockLarge(_x:int, _y:int, _t:int, _tag:int = -1, _bRock:Boolean = false, _tboss:Boolean = false) 
		{
			super(_x + Tile.w, _y + Tile.h, sprRock, _t);
			bossRock = _bRock;
			fallTo = y;
			sprRock.centerOO();
			setHitbox(32, 32, 16, 16);
			type = "";
			tag = _tag;
			thirdBoss = _tboss;
			y = -32;
			if (!Game.checkPersistence(tag)) //False = fell, true = not fallen
			{
				y = fallTo;
				type = "Solid";
				_active = true; //Set it back to having fallen.
				cameraTimer = 0;
			}
			layer = -(fallTo - originY + height);
		}
		
		override public function update():void
		{
			var p:Player;
			if (activate && y >= fallTo)
			{
				p = collide("Player", x, y) as Player;
				if (p)
				{
					p.y = y - originY + p.originY - p.height;
				}
			}
			else if (bossRock)
			{
				p = FP.world.nearestToEntity("Player", this) as Player;
				if (p)
				{
					if (!p.fallFromCeiling && p.y < fallTo - sprRock.height / 2 - 8)
					{
						activate = true;
					}
				}
			}
			if (!Game.checkPersistence(tag))
			{
				if (trigger && y < fallTo)
				{
					Game.cameraTarget = new Point(x - FP.screen.width / 2, fallTo - FP.screen.height / 2);
					if (waitToFallTimer > 0)
					{
						waitToFallTimer--;
					}
					else
					{
						vy += fallRate;
						y += vy;
					}
					if (y >= fallTo)
					{
						cameraTimer = cameraTimerMax;
						y = fallTo;
						type = "Solid";
						Game.shake = 30;
						Music.playSound("Rock", 0, 1.5);
						trigger = false;
					}
				}
				else
				{
					if (cameraTimer > 0)
					{
						cameraTimer--;
					}
					else
					{
						if (cameraTimer == 0)
						{
							if (bossRock && thirdBoss)
							{
								FP.world.add(new BobBoss(72, 72)); //Create the third dungeon boss when this falls.
								(FP.world as Game).playerPosition = new Point(72, 104);
							}
							Game.freezeObjects = false;
							Game.resetCamera();
							cameraTimer = -1;
						}
					}
				}
			}
			super.update();
		}
		
		public function fall():void
		{
			Game.setPersistence(tag, false);
			trigger = true;
			Game.freezeObjects = true;
			waitToFallTimer = waitToFallTimerMax;
		}
		
		override public function set activate(a:Boolean):void
		{
			if (a && !_active)
			{
				fall();
				_active = a; //Can only be set to true--cannot be reset back to false without errors in the update.
			}
		}
	}
}