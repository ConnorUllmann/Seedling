package Puzzlements 
{
	import Enemies.Enemy;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class LavaChain extends Entity
	{
		[Embed(source = "../../assets/graphics/LavaChain.png")] private var imgLavaChain:Class;
		private var sprLavaChain:Spritemap = new Spritemap(imgLavaChain, 64, 16, animEnd);
		
		private static const hitables:Object = ["Player", "Enemy"];
		private static const force:int = 5;
		private static const damage:int = 1;
		
		private const loops:int = 2;
		private var direction:int;
		
		public function LavaChain(_x:int, _y:int, _d:int) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprLavaChain);
			
			direction = _d;
			
			sprLavaChain.originX = 8;
			sprLavaChain.originY = 8;
			sprLavaChain.x = -sprLavaChain.originX;
			sprLavaChain.y = -sprLavaChain.originY;
			
			sprLavaChain.add("sit", [0]);
			sprLavaChain.add("extend", [1, 2], 15);
			sprLavaChain.add("hit", [3, 4, 5, 5, 5, 5, 4, 3], 15);
			sprLavaChain.add("retract", [6, 7, 8, 9, 10, 11, 12], 25);
			
			type = "Solid";
			setHitbox(16, 16, 8, 8);
			layer = -(y - originY + height);
		}
		
		override public function update():void
		{
			super.update();
			(graphic as Spritemap).angle = 90 * direction;
			if (!Game.worldFrame(Main.FPS, loops))
			{
				(graphic as Spritemap).play("extend");
			}
			if ((graphic as Spritemap).currentAnim == "hit" || (graphic as Spritemap).currentAnim == "extend")
			{
				reach();
			}
		}
		
		override public function render():void
		{
			super.render();
			
			if ((graphic as Spritemap).currentAnim == "hit")
			{
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				super.render();
				Draw.resetTarget();
			}
		}
		
		public function reach():void
		{
			var rect:Rectangle = getRect(direction);
			for (var i:int = 0; i < hitables.length; i++)
			{				
				var hit:Entity = FP.world.collideRect(hitables[i], rect.x, rect.y, rect.width, rect.height);
				if (hit)
				{					
					var hitPos:Point = getHitPos(new Point(hit.x, hit.y), direction);
					if (hit is Enemy)
					{
						(hit as Enemy).hit(force, hitPos, damage, "LavaChain");
					}
					else if (hit is Player)
					{
						(hit as Player).hit(null, force, hitPos, damage);
					}
				}
			}
		}
		
		public function getRect(_d:int):Rectangle
		{
			const w:int = (graphic as Image).width - Tile.w;
			const h:int = 4;
			var rect:Rectangle;
			switch(_d)
			{
				case 0:
					rect = new Rectangle(x - originX + width, y - originY + height/2 - h / 2, w, h);
					break;
				case 1:
					rect = new Rectangle(x - originX + width / 2 - h / 2, y - originY - w, h, w);
					break;
				case 2:
					rect = new Rectangle(x - originX - w, y - originY + height / 2 - h / 2, w, h);
					break;
				case 3:
					rect = new Rectangle(x - originX + width / 2 - h / 2, y - originY + height, h, w);
					break;
				default:
					rect = new Rectangle();
			}
			return rect;
		}
		
		public function getHitPos(_p:Point, _d:int):Point
		{
			var pos:Point;
			/*switch(_d)
			{
				case 0:
				case 2:
					pos = new Point(_p.x, y); break;
				case 1:
				case 3:
					pos = new Point(x, _p.y); break;
				default:
					pos = new Point;
			}*/
			pos = new Point(x, y);
			return pos;
		}
		
		public function animEnd():void
		{
			var g:Spritemap = graphic as Spritemap;
			switch(g.currentAnim)
			{
				case "extend":
					g.play("hit");
					break;
				case "hit":
					g.play("retract");
					break;
				case "retract":
					g.play("sit");
					break;
				default:
			}
		}
		
	}

}