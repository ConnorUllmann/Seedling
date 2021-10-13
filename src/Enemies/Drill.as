package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.SlashHit;
	import Scenery.Tile;
	import Pickups.Coin;
	/**
	 * ...
	 * @author Time
	 */
	public class Drill extends Enemy
	{
		[Embed(source = "../../assets/graphics/Drill.png")] private var imgDrill:Class;
		private var sprDrill:Spritemap = new Spritemap(imgDrill, 16, 16, endAnim);
		
		private const runRange:int = 48; //Range at which the Drill will move after the character
		private const drillAnimSpeed:int = 20;
		
		public function Drill(_x:int, _y:int) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprDrill);
			
			sprDrill.centerOO();
			sprDrill.add("sit", [0]); //doesn't matter the frame--turns invisible when sitting.
			sprDrill.add("drill", [0, 1, 2, 3, 4], drillAnimSpeed, false);
			sprDrill.add("undrill", [3, 2, 1, 0], drillAnimSpeed, false);
			sprDrill.add("die", [5, 6, 7, 8, 9, 10], 10, false);
			sprDrill.add("hit", [3, 4], 20, true);
			
			sprDrill.play("sit");
			sprDrill.visible = false;
			
			solids.push("Enemy");
			
			setHitbox(10, 10, 5, 5);
			
			hitSound = "Metal Hit";
		}
		
		override public function removed():void
		{
			//if(!fell) dropCoins();
		}
		
		override public function knockback(f:Number=0, p:Point=null):void
		{
			
		}
		
		override public function update():void
		{
			if (Game.freezeObjects)
			{
				return;
			}
			super.update();
			if (destroy || (graphic as Spritemap).currentAnim == "die")
				return;
			
			if (hitsTimer > 0)
			{
				sprDrill.play("hit");
			}
			else
			{
				if (sprDrill.currentAnim == "hit")
				{
					sprDrill.play("undrill");
				}
				
				if (sprDrill.currentAnim == "sit")
				{
					sprDrill.visible = false;
				}
				else
				{
					sprDrill.visible = true;
				}
				
				var player:Player = FP.world.nearestToPoint("Player", x, y) as Player;
				if (player)
				{
					var d:Number = FP.distance(x, y, player.x, player.y);
					if (sprDrill.currentAnim == "sit" && d <= runRange && !FP.world.collideLine("Solid", x, y, player.x, player.y))
					{
						var tox:int = x;
						var toy:int = y;
						if (Math.abs(player.x - x) > Tile.w/2)
						{
							tox += (2 * int(player.x > x) - 1) * Tile.w;
						}
						if (Math.abs(player.y - y) > Tile.h/2)
						{
							toy += (2 * int(player.y > y) - 1) * Tile.h;
						}
						if (tox != x && !collideTypes(solids, tox, y))
						{
							x = tox;
							sprDrill.play("drill");
							Music.playSound("Drill", 0.6);
						}
						if (toy != y && !collideTypes(solids, x, toy))
						{
							y = toy;
							sprDrill.play("drill");
							Music.playSound("Drill", 0.6);
						}
					}
				}
			}
		}
		
		override public function startDeath(t:String=""):void
		{
			(graphic as Spritemap).play("die");
			dieEffects(t);
		}
		
		public function endAnim():void
		{
			switch(sprDrill.currentAnim)
			{
				case "drill":
					sprDrill.play("undrill");
					break;
				case "undrill":
					sprDrill.play("sit");
					break;
				case "hit":
					sprDrill.play("hit");
					break;
				case "die":
					destroy = true;
					sprDrill.play("");
					sprDrill.frame = sprDrill.frameCount - 1;
					break;
				default: sprDrill.play("sit");
			}
		}
		
	}

}