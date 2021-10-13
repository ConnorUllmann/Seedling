package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	import Projectiles.Bomb;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class BombPusher extends Enemy
	{
		[Embed(source = "../../assets/graphics/BombPusher.png")] private var imgBombPusher:Class;
		private var sprBombPusher:Spritemap = new Spritemap(imgBombPusher, 48, 48, endAnim);
		
		private const sitAnimation:Array = new Array(0, 3);
		private const shootAnimation:Array = new Array(0, 2, 1, 2, 3);
		private const shotTimeMax:int = 15;
		private var shotTime:int = 0;
		private const maxDistance:int = 256;
		
		public function BombPusher(_x:int, _y:int) 
		{
			super(_x + Tile.w * 3 / 2, _y + Tile.h * 3 / 2, sprBombPusher);
			sprBombPusher.centerOO();
			setHitbox(48, 48, 24, 24);
			sprBombPusher.add("shoot", shootAnimation, 5);
			sprBombPusher.add("sit", sitAnimation, 2);
			type = "Solid";
			layer = -(y - originY + height);
			
			activeOffScreen = true;
		}
		
		override public function update():void
		{
			var p:Player = FP.world.nearestToPoint("Player", x, y) as Player;
			if (shotTime > 0)
			{
				shotTime--;
			}
			else if(shotTime == 0 && p && FP.distance(x, y, p.x, p.y) <= maxDistance)
			{
				shotTime = -1;
				sprBombPusher.play("shoot");
			}
			super.update();
		}
		
		public function endAnim():void
		{
			if (sprBombPusher.currentAnim == "shoot")
			{
				shotTime = shotTimeMax;
				var p:Player = FP.world.nearestToPoint("Player", x, y) as Player;
				if (p)
				{
					FP.world.add(new Bomb(x, y, new Point(p.x, p.y)));
				}
				sprBombPusher.play("sit");
			}
		}
		
		override public function knockback(f:Number = 0, p:Point = null):void { }
		override public function hit(f:Number = 0, p:Point = null, d:Number = 1, t:String = ""):void { }
		
	}

}