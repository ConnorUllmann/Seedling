package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class LittleStones extends Entity
	{
		[Embed(source = "../../assets/graphics/LittleStones.png")] private var imgLittleStones:Class;
		private var sprLittleStones:Image = new Image(imgLittleStones);
		
		private var grassPosX:Object = [1,1,9,5,1];
		private var grassPosY:Object = [14, 9, 14, 1, 6];
		
		public function LittleStones(_x:int, _y:int) 
		{
			super(_x, _y, sprLittleStones);
			layer = -y;
			for (var i:int = 0; i < grassPosX.length; i++)
			{
				FP.world.add(new Grass(x + grassPosX[i], y + grassPosY[i]));
			}
		}
		
	}

}