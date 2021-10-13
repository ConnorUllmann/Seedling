package Enemies 
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class Cactus extends Enemy
	{
		[Embed(source = "../../assets/graphics/Cactus.png")] private var imgCactus:Class;
		private var sprCactus:Spritemap = new Spritemap(imgCactus, 8, 8, endAnim);
		
		private const chompAnimSpeed:int = 10;
		private const chompRange:int = 20; // The distance at which the cactus will start chomping from a player
		
		public function Cactus(_x:int, _y:int) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprCactus);
			sprCactus.centerOO();
			sprCactus.add("sit", [0]);
			sprCactus.add("chomp", [0, 1], chompAnimSpeed, true);
			sprCactus.add("hit", [1]);
			sprCactus.play("sit");
			
			setHitbox(6, 6, 3, 3);
		}
		
		override public function update():void
		{
			super.update();
			var player:Player = FP.world.nearestToEntity("Player", this) as Player;
			if (player)
			{
				var d:int = FP.distance(x, y, player.x, player.y);
				if (d <= chompRange)
				{
					sprCactus.play("chomp");
				}
			}
			
			if (hitsTimer <= 0 && collide("Player", x, y))
			{
				if (sprCactus.frame == 1) //The closed frame
				{
					//Hit the player
				}
				else
				{
					hit();
				}
			}
		}
		
		public function endAnim():void
		{
			sprCactus.play("sit");
		}
		
	}

}