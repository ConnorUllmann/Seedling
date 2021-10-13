package Scenery 
{
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
	 */
	public class FallRock extends Activators
	{
		[Embed(source = "../../assets/graphics/FallRock.png")] private var imgRock:Class;
		private var sprRock:Image = new Image(imgRock);
		
		private var tag:int;
		
		private var trigger:Boolean = false;
		
		private const fallRate:Number = 0.6;
		private var vy:Number = 0;
		private var fallTo:int;
		
		private const cameraTimerMax:int = 90; // The length of time that the camera focuses after this hits
		private var cameraTimer:int = 0;
		
		private const waitToFallTimerMax:int = 60; // The length of time before the rock falls
		private var waitToFallTimer:int = 0;
		
		public function FallRock(_x:int, _y:int, _t:int, _tag:int=-1) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprRock, _t);
			fallTo = y;
			sprRock.centerOO();
			setHitbox(16, 16, 8, 8);
			type = "";
			tag = _tag;
			y = -16;
			if (!Game.checkPersistence(tag)) //False = fell, true = not fallen
			{
				y = fallTo;
				type = "Solid";
				_active = true; //Set it back to having fallen.
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
						Music.playSound("Rock", 0);
						trigger = false;
					}
				}
				else
				{
					if (cameraTimer > 0)
					{
						cameraTimer--;
					}
					else if(cameraTimer == 0)
					{
						cameraTimer = -1;
						Game.freezeObjects = false;
						Game.resetCamera();
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