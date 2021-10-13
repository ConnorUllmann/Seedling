package Puzzlements 
{
	import Enemies.*;
	import net.flashpunk.Graphic;
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
	public class Lock extends Activators
	{
		[Embed(source = "../../assets/graphics/Lock.png")] private var imgLock:Class;
		public var sprLock:Spritemap = new Spritemap(imgLock, 16, 16);
		
		private var normType:String = "Solid";
		private var tag:int;
		
		private var hitables:Object = ["Player", "Enemy", "Solid"];
		
		public function Lock(_x:int, _y:int, _t:int, _tag:int=-1, _g:Graphic=null) 
		{
			if (!_g)
			{
				_g = sprLock;
			}
			super(_x + Tile.w/2, _y + Tile.h/2, _g, _t);
			(graphic as Image).centerOO();
			setHitbox(16, 16, 8, 8);
			type = normType;
			tag = _tag;
			layer = -y;
		}
		
		override public function check():void
		{
			super.check();
			if (tag >= 0 && tSet < 0 && !Game.checkPersistence(tag))
			{
				FP.world.remove(this);
			}
		}
		
		override public function update():void
		{
			super.update();
			checkEnemies();
			activationStep();
		}
		
		override public function set activate(a:Boolean):void
		{
			if (!_active && a)
			{
				Music.playSoundDistPlayer(x, y, "Lock");
			}
			_active = a;
		}
		
		public function activationStep():void
		{
			if (activate)
			{
				if ((graphic as Image).alpha > 0)
				{
					(graphic as Image).alpha -= 0.01;
				}
				else
				{
					turnOff();
				}
			}
			else
			{
				if (type == normType)
				{
					(graphic as Image).alpha = 1;
				}
				if(!collideTypes(hitables, x, y))
				{
					returnToNormal();
				}
			}
		}
		
		public function turnOff():void
		{
			if (type == normType)
			{
				type = "";
				(graphic as Image).alpha = 0;
				Game.setPersistence(tag, false);
			}
		}
		
		public function returnToNormal():void
		{
			if (type == "")
			{
				type = normType;
				Game.setPersistence(tag, true);
			}
		}
		
		public function checkEnemies():void
		{
			if (tSet == -1 && (FP.world as Game).totalEnemies() == 0)
			{
				activate = true;
			}
		}
		
		override public function render():void
		{
			(graphic as Spritemap).frame = Game.worldFrame((graphic as Spritemap).frameCount);
			
			if (activate)
			{
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				super.render();
				Draw.resetTarget();
			}
			(graphic as Image).blend = activate ? BlendMode.INVERT : BlendMode.NORMAL;
			super.render();
			(graphic as Image).blend = BlendMode.NORMAL;
		}
		
	}

}