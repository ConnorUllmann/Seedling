package Pickups
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class Coin extends Pickup
	{
		[Embed(source = "../../assets/graphics/Coin.png")] private var imgCoin:Class;
		private var sprCoin:Spritemap = new Spritemap(imgCoin, 4, 4);
		
		public function Coin(_x:int, _y:int, _v:Point=null)
		{
			super(_x, _y, sprCoin, _v);
			sprCoin.centerOO();
			type = "Coin";
			setHitbox(4, 4, 2, 2);
		}
		
		override public function render():void
		{
			sprCoin.frame = Game.worldFrame(sprCoin.frameCount);
			super.render();
		}
		
	}

}