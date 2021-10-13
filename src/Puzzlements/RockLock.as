package Puzzlements 
{
	import Enemies.*;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	import net.flashpunk.utils.Draw;
	import flash.display.BlendMode;
	/**
	 * ...
	 * @author Time
	 */
	public class RockLock extends Activators
	{
		[Embed(source = "../../assets/graphics/RockLock.png")] private var imgRockLock:Class;
		private var sprRockLock:Image = new Image(imgRockLock);
		
		private var normType:String = "Solid";
		private var tag:int;
		
		public function RockLock(_x:int, _y:int, _t:int, _tag:int=-1) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprRockLock, _t);
			sprRockLock.centerOO();
			setHitbox(16, 16, 8, 8);
			type = normType;
			tag = _tag;
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
			if (tSet == -1 && (FP.world as Game).totalEnemies() == 0)
			{
				activate = true;
			}
			if (activate)
			{
				if (sprRockLock.alpha > 0)
				{
					sprRockLock.alpha -= 0.01;
					if (sprRockLock.alpha <= 0)
					{
						type = "";
						sprRockLock.alpha = 0;
						Game.setPersistence(tag, false);
					}
				}
			}
			else if(!Game.checkPersistence(tag))
			{
				type = normType;
				sprRockLock.alpha = 1;
				Game.setPersistence(tag, true);
			}
		}
		
		override public function render():void
		{
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