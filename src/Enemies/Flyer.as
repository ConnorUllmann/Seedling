package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import Scenery.Tile;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class Flyer extends Bob
	{
		[Embed(source = "../../assets/graphics/Flyer.png")] private var imgFlyer:Class;
		private var sprFlyer:Spritemap = new Spritemap(imgFlyer, 18, 26, endAnim);
		
		private static const normalSpeed:Number = 1;
		private static const animSpeed:int = 15;
		private static const dropForce:int = 1;
		private static const droppedFrame:int = 10; //The frame at which the flyer is on the ground (when to hit the player)
		
		public function Flyer(_x:int, _y:int) 
		{
			super(_x, _y, sprFlyer);
			
			sitFrames = new Array(0, 1, 2, 3);
			sitLoops = 0.5;
			targetOffset = new Point(0, -10);
			
			sprFlyer.centerOO();
			sprFlyer.add("walk", [0, 1, 2, 3], animSpeed);
			sprFlyer.add("fall", [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22], 2 * animSpeed);
			sprFlyer.add("die", [23, 24, 25, 26], 10);
			sprFlyer.play("");
			setHitbox(10, 8, 5, 12);
			
			dieInLava = false;
			dieInWater = false;
			canFallInPit = false;
			
			moveSpeed = normalSpeed;	
			hitsMax = 3;
			damage = 2;
			
			solids = new Array();
		}
		
		override public function update():void
		{
			if (Game.freezeObjects)
				return;
			if(destroy || (graphic as Spritemap).currentAnim == "die")
			{
				super.update();
				return;
			}
			
			var p:Player = FP.world.collidePoint("Player", x - targetOffset.x, y - targetOffset.y) as Player;
			if (p)
			{
				sprFlyer.play("fall");
			}
			if (sprFlyer.currentAnim == "fall" && !destroy)
			{
				v.x = v.y = 0;
				if (p && sprFlyer.frame == droppedFrame)
				{
					p.hit(null, dropForce, new Point(x, y), damage);
				}
				hitUpdate();
			}
			else
			{
				super.update();
			}
		}
		
		override public function layering():void
		{
			layer = -(y - targetOffset.y);
		}
		
		override public function hitPlayer():void
		{
		}
		
	}

}