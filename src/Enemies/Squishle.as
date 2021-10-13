package Enemies 
{
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Time
	 */
	public class Squishle extends Enemy
	{
		[Embed(source = "../../assets/graphics/Squishle.png")] private var imgSquishle:Class;
		private var sprSquishle:Spritemap = new Spritemap(imgSquishle, 16, 11);
		
		private const sittingAnim:Array = new Array(2, 3);
		private const loops:int = 1;
		
		public function Squishle(_x:int, _y:int) 
		{
			super(_x, _y, sprSquishle);
			sprSquishle.add("run", [0, 1, 2, 3, 4], 10);
			
			sprSquishle.play("");
		}
		
		override public function render():void
		{
			if (sprSquishle.currentAnim == "")
			{
				sprSquishle.frame = sittingAnim[Game.worldFrame(sittingAnim.length, loops)];
			}
			super.render();
		}
		
	}

}