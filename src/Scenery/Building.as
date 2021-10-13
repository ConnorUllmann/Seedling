package Scenery
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Pixelmask;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class Building extends Entity
	{
		private var buildingType:int;
		private static const moundFrames:Array = new Array(0, 1, 2, 1);
		
		public function Building(_x:int, _y:int, _t:int=0) 
		{
			super(_x, _y, Game.buildings[_t]);
			Game.buildings[_t].y = -8;
			mask = new Pixelmask(Game.buildingMasks[_t], 0, 0);
			type = "Solid";
			buildingType = _t;
			
			switch(_t)
			{
				case 4:
					layer = -(y - originY + 1 / 2 * height);
					break;
				case 6: 
					layer = -(y - originY + 72);
					break;
				case 7:
					layer = -(y - originY + 16);
					break;
				case 8:
					layer = -(y - originY + 48);
					Game.buildings[_t].y = 0;
					break;
				default:
					layer = -(y - originY + height);
			}
		}
		
		override public function render():void
		{
			if (buildingType == 8)
			{
				const moundLoops:int = 1;
				Game.buildings[buildingType].frame = moundFrames[Game.worldFrame(moundFrames.length, moundLoops)];
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				super.render();
				Draw.resetTarget();
			}
			super.render();
		}
		
	}

}