package Scenery 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import Puzzlements.ButtonRoom;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class Wire extends Entity
	{
		private var img:int;
		public var on:Boolean = false;
		
		private const onColor:uint = 0xFFFF00;
		private const offColor:uint = 0x404040;
		
		public function Wire(_x:int, _y:int, _img:int=-1) 
		{
			super(_x, _y);
			type = "Wire";
			setHitbox(16, 16);
			active = false;
			img = _img;
		}
		
		override public function check():void
		{
			super.check();
			if (img < 0)
			{
				img = 0;
				var c:Boolean;
				const types:Object = ["Wire", "ButtonRoom"];
				if (collideTypes(types, x + Tile.w/2, y) || x - originX + width + 1 >= FP.width)
					img++;
				if (collideTypes(types, x, y - Tile.h/2) || y - originY - 1 < 0)
					img += 2;
				if (collideTypes(types, x - Tile.w/2, y) || x - originX - 1 < 0)
					img += 4;
				if (collideTypes(types, x, y + Tile.h/2) || y - originY + height + 1 >= FP.height)
					img += 8;
			}
		}
		
		override public function render():void
		{
			if (!onScreen())
			{
				return;
			}
			var c:Entity;
			const types:Object = ["Wire", "ButtonRoom"];
			c = collideTypes(types, x + Tile.w, y);
			if (c)
				if (c is ButtonRoom && (c as ButtonRoom).activate)
					on = (c as ButtonRoom).activate;
				else if (c is Wire && (c as Wire).on)
					on = (c as Wire).on;
			c = collideTypes(types, x, y - Tile.h);
			if (c)
				if (c is ButtonRoom && (c as ButtonRoom).activate)
					on = (c as ButtonRoom).activate;
				else if (c is Wire && (c as Wire).on)
					on = (c as Wire).on;
			c = collideTypes(types, x - Tile.w, y);
			if (c)
				if (c is ButtonRoom && (c as ButtonRoom).activate)
					on = (c as ButtonRoom).activate;
				else if (c is Wire && (c as Wire).on)
					on = (c as Wire).on;
			c = collideTypes(types, x, y + Tile.h);
			if (c)
				if (c is ButtonRoom && (c as ButtonRoom).activate)
					on = (c as ButtonRoom).activate;
				else if (c is Wire && (c as Wire).on)
					on = (c as Wire).on;
			if (on)
			{
				Game.sprWire.color = onColor;
			}
			else
			{
				Game.sprWire.color = offColor;
			}
			Game.sprWire.frame = img;
			Game.sprWire.render(new Point(x, y), FP.camera);
			if (on)
			{
				Game.sprWire.alpha = 0.1;
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				Game.sprWire.render(new Point(x, y), FP.camera);
				Draw.resetTarget();
				Game.sprWire.alpha = 1;
			}
		}
		
	}

}