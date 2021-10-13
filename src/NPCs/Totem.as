package NPCs 
{
	import net.flashpunk.graphics.Spritemap;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class Totem extends NPC
	{
		[Embed(source = "../../assets/graphics/Totem.png")] private var imgTotem:Class;
		private var sprTotem:Spritemap = new Spritemap(imgTotem, 32, 64);
		
		public function Totem(_x:int, _y:int, _tag:int=-1, _text:String="", _talkingSpeed:int=10) 
		{
			//The weird tiles for the constructor are because NPC offsets by Tile.w/2, Tile.h/2 automagically.
			super(_x + Tile.w/2, _y + Tile.h*5/2, sprTotem, _tag, _text, _talkingSpeed);
			facePlayer = false;
			
			sprTotem.originX = 16;
			sprTotem.x = -sprTotem.originX;
			sprTotem.originY = 48;
			sprTotem.y = -sprTotem.originY;
			setHitbox(Tile.w * 2, Tile.h * 2, Tile.w, Tile.h);
		}
		
	}

}