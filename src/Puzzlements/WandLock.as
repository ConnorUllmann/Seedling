package Puzzlements 
{
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Time
	 */
	public class WandLock extends Lock
	{
		[Embed(source = "../../assets/graphics/WandLock.png")] private var imgWandLock:Class;
		private var sprWandLock:Spritemap = new Spritemap(imgWandLock, 16, 16);
		
		public function WandLock(_x:int, _y:int, _t:int, _tag:int=-1) 
		{
			super(_x, _y, _t, _tag, sprWandLock);
		}
		
	}

}