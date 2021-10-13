package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class IceTrap extends Enemy
	{
		[Embed(source = "../../assets/graphics/IceTrap.png")] private var imgIceTrap:Class;
		private var sprIceTrap:Spritemap = new Spritemap(imgIceTrap, 16, 16, endAnim);
		
		private const chompAnimSpeed:int = 10;
		private const chompRange:int = 8; // The distance at which the ice trap will start chomping from a player
		
		public function IceTrap(_x:int, _y:int) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprIceTrap);
			
			sprIceTrap.centerOO();
			//the animation "" will reset it to the world frame speed
			sprIceTrap.add("chomp", [0, 1, 2, 1], chompAnimSpeed);
			sprIceTrap.add("hit", [1]);
			
			setHitbox(16, 16, 8, 8);
			
			layer = -(y - originY + height * 4 / 5);
			
			canHit = false;
		}
		
		override public function update():void
		{
			super.update();
			var player:Player = FP.world.nearestToEntity("Player", this) as Player;
			if (player)
			{
				var d:int = FP.distance(x, y, player.x, player.y);
				if (d <= chompRange && (graphic as Spritemap).currentAnim != "chomp")
				{
					Music.playSoundDistPlayer(x, y, "Enemy Attack", 3);
					(graphic as Spritemap).play("chomp");
				}
			}
			if (sprIceTrap.currentAnim == "")
			{
				sprIceTrap.frame = Game.worldFrame(2);
			}
		}
		
		override public function layering():void
		{
			
		}
		
		override public function knockback(f:Number = 0, p:Point = null):void
		{
			
		}
		
		override public function death():void
		{
			if (destroy)
			{
				super.death();
			}
		}
		
		public function endAnim():void
		{
			sprIceTrap.play("");
		}
		
	}

}