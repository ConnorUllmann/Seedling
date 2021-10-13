package NPCs
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Pixelmask;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class Statue extends NPC
	{
		private var frame:int;
		
		public function Statue(_x:int, _y:int, _t:int=0, _text:String="", _talkingSpeed:int=10) 
		{
			super(_x + Tile.w, _y - Tile.h/2 + Tile.h*int(_t==0), Game.sprStatues, -1, _text, _talkingSpeed, 34);
			facePlayer = false;
			frame = _t;
			type = "Solid";
			align = "CENTER";
			talkRange = 32;
		}
		
		override public function render():void
		{
			const w:int = (graphic as Image).width;
			
			switch(frame)
			{
				case 0:
					graphic.y = -24;
					setHitbox(w, 32, w/2, 16);
					break;
				case 1:
					graphic.y = -16;
					setHitbox(w, 24, w/2);
					break;
			}
			(graphic as Spritemap).frame = frame;
			super.render();
		}
		
		override public function layering():void
		{
			switch(frame)
			{
				case 0:
					layer = -(y - originY + height - 8);
					break;
				case 1:
					layer = -(y - originY + height - 24);
					break;
				default:
					layer = -(y - originY + height);
			}
		}
	}

}