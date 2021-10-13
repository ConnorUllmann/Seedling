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
	public class Bulb extends Bob
	{
		[Embed(source = "../../assets/graphics/Bulb.png")] private var imgBulb:Class;
		private var sprBulb:Spritemap = new Spritemap(imgBulb, 16, 16, endAnim);
		
		public function Bulb(_x:int, _y:int) 
		{
			super(_x, _y, sprBulb);
			
			sprBulb.centerOO();
			const animSpeed:int = 8;
			sprBulb.add("walk", [0, 1, 2, 3, 4], animSpeed);
			sprBulb.add("drop", [5, 6, 7, 8, 9, 10, 11], animSpeed);
			sprBulb.add("die", [12, 13, 14, 15, 16, 17, 18], animSpeed);
			sprBulb.play("");
			setHitbox(12, 12, 6, 6);
			
			moveSpeed = 0.65;	
			hitsMax = 1;
			sitFrames = new Array(0, 3);
			hitsColor = normalColor;
		}
		
		override public function update():void
		{
			if ((graphic as Spritemap).currentAnim == "drop" || (graphic as Spritemap).currentAnim == "die")
			{
				var tile:Point = new Point((Math.floor(x / Tile.w) + 0.5) * Tile.w, (Math.floor(y / Tile.h) + 0.5) * Tile.h);
				v.x = tile.x - x;
				v.y = tile.y - y;
				v.normalize(Math.min(v.length, moveSpeed));
				mobileUpdate();
			}
			else
			{
				super.update();
				if (v.x >= moveSpeed/2)
				{
					(graphic as Spritemap).scaleX = Math.abs((graphic as Spritemap).scaleX);
				}
				else if (v.x <= -moveSpeed/2)
				{
					(graphic as Spritemap).scaleX = -Math.abs((graphic as Spritemap).scaleX);
				}
			}
			
			if (hits >= hitsMax && sprBulb.currentAnim != "drop" && sprBulb.currentAnim != "die")
			{
				sprBulb.play("drop");
				Music.playSound("Lava", 2);
			}
		}
		
		override public function startDeath(t:String=""):void
		{
			
		}
		
		override public function endAnim():void
		{
			switch((graphic as Spritemap).currentAnim)
			{
				case "drop":
					(graphic as Spritemap).play("die");
					var tile:Tile = FP.world.collidePoint("Tile", x, y) as Tile;
					if (tile)
					{
						tile.t = 17; //Lava
					}
					break;
				case "die":
					FP.world.remove(this);
					break;
				default:
				
			}
		}
		
		override public function render():void
		{
			super.render();
		}
		
	}

}