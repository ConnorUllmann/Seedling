package Puzzlements 
{
	import Enemies.*;
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	import flash.display.BlendMode;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class BossLock extends Activators
	{		
		private var normType:String = "Solid";
		private var keyType:int; //corresponds to a player variable "hasKey" which is an array of booleans denoting if they've picked up the right key.
		private var tag:int;
		private var myKey:Spritemap;
		
		//These are placeholders values for use on the sprite when drawn from the Game class
		private var scale:Number = 1;
		private var alpha:Number = 1;
		
		private const keyTimerMax:int = 60;
		private var keyTimer:int = keyTimerMax;
		
		public function BossLock(_x:int, _y:int, _t:int=0, _tag:int=-1) 
		{
			super(_x + Tile.w / 2, _y + Tile.h / 2, Game.bossLocks[_t], -1);
			myKey = Game.bossKeys[_t];
			setHitbox(16, 16, 8, 8);
			type = normType;
			tag = _tag;
			keyType = _t;
			layer = -(y - originY + height);
		}
		
		override public function check():void
		{
			super.check();
			if (tag >= 0 && !Game.checkPersistence(tag))
			{
				FP.world.remove(this);
			}
		}
		
		override public function set activate(a:Boolean):void
		{
			if (!_active && a)
			{
				Music.playSoundDistPlayer(x, y, "Lock");
			}
			_active = a;
		}
		
		override public function update():void
		{
			super.update();
			var m:int = 2; //The distance to check from the edges of the chest
			var p:Player = FP.world.collideLine("Player", x - originX + m, y - originY + height + 1, x - originX + width - 2 * m, y - originY + height + 1) as Player;
			if (p && Player.hasKey(keyType))
			{
				activate = true;
			}
			if (activate)
			{
				if (keyTimer > 0)
				{
					keyTimer--;
				}
				else
				{
					scale += 0.05;
					alpha -= 0.05;
					if (alpha <= 0 && type != "")
					{
						type = "";
						alpha = 0;
						Game.setPersistence(tag, false);
					}
				}
			}
			else if(type != normType)
			{
				type = normType;
				alpha = 1;
				Game.setPersistence(tag, true);
			}
		}
		
		override public function render():void
		{
			(graphic as Image).alpha = alpha;
			(graphic as Image).scale = scale;
			(graphic as Spritemap).frame = Game.worldFrame((graphic as Spritemap).frameCount);
			if (activate)
			{
				if (keyTimer <= keyTimerMax / 3)
				{
					(graphic as Spritemap).blend = BlendMode.SCREEN;
				}
			}
			super.render();
			if (keyType == 4 /* Dungeon 6 */)
			{
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				(graphic as Spritemap).alpha = alpha * 0.2;
				super.render();
				Draw.resetTarget();
			}
			if (activate)
			{
				if (myKey && keyTimer > 0)
				{
					var a:Number = myKey.alpha;
					myKey.alpha = keyTimer / keyTimerMax;
					myKey.render(new Point(x - originX + width / 2 - myKey.originX + myKey.width/2, y + height/2 - myKey.height - keyTimer / keyTimerMax * 8 + 3), FP.camera);
					myKey.alpha = a;
				}
			}
			(graphic as Spritemap).frame = 0;
			(graphic as Spritemap).blend = BlendMode.NORMAL;
			(graphic as Image).alpha = (graphic as Image).scale = 1;
			
			/*
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			const n:int = 3;
			const m:int = Math.pow(Math.sin(Game.worldFrame(100, 2) / 100 * Math.PI), 0.5) * n;
			Draw.rect(x - originX + m, y - originY + height - 1, Tile.w - m * 2, Math.max(Tile.h / 4 - m * 2, 2), 0xFFFF00, 0.5);
			Draw.resetTarget();
			*/
		}
		
	}

}