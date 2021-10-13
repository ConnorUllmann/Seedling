package Puzzlements 
{
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Time
	 */
	public class GrassLock extends Lock
	{
		[Embed(source = "../../assets/graphics/GrassLock.png")] private var imgGrassLock:Class;
		private var sprGrassLock:Spritemap = new Spritemap(imgGrassLock, 16, 16);
		
		public function GrassLock(_x:int, _y:int, _t:int, _tag:int=-1) 
		{
			super(_x, _y, _t, _tag, sprGrassLock);
		}
		
	}

}