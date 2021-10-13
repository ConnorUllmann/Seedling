package Scenery
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class Torch extends Entity
	{
		[Embed(source = "../../assets/graphics/Torch.png")] private var imgTorch:Class;
		private var sprTorch:Spritemap = new Spritemap(imgTorch, 4, 10);
		
		private var color:uint;
		
		public function Torch(_x:int, _y:int, _c:uint=0xFFFFFF) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprTorch);
			sprTorch.centerOO();
			color = _c;
			layer = -(y - sprTorch.originY + sprTorch.height + Tile.h / 2);
			FP.world.add(new Light(x, y, sprTorch.frameCount, 1, color, false));
		}
		
		override public function render():void
		{
			sprTorch.frame = Game.worldFrame(sprTorch.frameCount);
			super.render();
		}
		
	}

}