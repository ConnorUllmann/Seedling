package Puzzlements
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import Scenery.Tile;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class PushableBlockFire extends Mobile
	{
		[Embed(source = "../../assets/graphics/PushableBlockFire.png")] private var imgPushableBlockFire:Class;
		private var sprPushableBlockFire:Spritemap = new Spritemap(imgPushableBlockFire, 16, 16);
		
		private const moveSpeed:Number = 0.5;
		private var tile:Point; // The middle of the tile that you want to move toward
		private var vMusicCheck:Point = new Point;
		
		public var moveTypes:Array = new Array("Fire", "Pulse");
		
		public function PushableBlockFire(_x:int, _y:int) 
		{
			super(_x, _y, sprPushableBlockFire);
			sprPushableBlockFire.color = 0xFF0000;
			setHitbox(16, 16);
			type = "Solid";
			solids.push("Enemy", "Player");
			
			tile = getPos(x, y);
		}
		
		override public function input():void
		{
			if (gridPos(x, y).equals(new Point(x, y)))
			{
				var myTile:Tile = FP.world.nearestToPoint("Tile", x - originX + width/2, y - originY + height/2) as Tile;
				if (myTile)
				{
					if (myTile.t == 1 || myTile.t == 17 || myTile.t == 6) //Water && Lava && Pit
					{
						destroy = true;
					}
				}
			}
			vMusicCheck = v.clone();
			v.x = moveSpeed * FP.sign(tile.x - x - Tile.w / 2);
			v.y = moveSpeed * FP.sign(tile.y - y - Tile.h / 2);
			
			
			if (!collideTypes(solids, gridPos(x, y).x, gridPos(x, y).y))
			{
				if (Math.abs(v.x) <= 0.01)
				{
					x = int(gridPos(x, y).x);
				}			
				if (Math.abs(v.y) <= 0.01)
				{
					y = int(gridPos(x, y).y);
				}
			}
		}
		
		public function gridPos(_x:int, _y:int):Point
		{
			return new Point(Math.floor(_x / Tile.w) * Tile.w, Math.floor(_y / Tile.h) * Tile.h);
		}
		public function getPos(_x:int, _y:int):Point
		{
			return new Point((Math.floor(_x / Tile.w) + 0.5) * Tile.w, (Math.floor(_y / Tile.h) + 0.5) * Tile.h);
		}
		
		public function hit(p:Point, t:String, _relative:Boolean=false):void
		{
			if (v.length > 0) //Don't reset if we're already moving
				return;
			
			if (_relative)
			{
				tile.x = getPos(x,y).x - p.x * Tile.w;
				tile.y = getPos(x,y).y - p.y * Tile.h;
				return;
			}
			var cont:Boolean = false;
			for (var i:int = 0; i < moveTypes.length; i++)
			{
				if (t == moveTypes[i])
				{
					cont = true;
					break;
				}
			}
			if (cont)
			{
				var a:Number = Math.atan2( -(y - originY + height / 2) + p.y, p.x - (x - originX + width / 2));
				const bothRange:Number = 0.1; //This range determines when both horizontal and vertical movement will occur.
				if (Math.abs(Math.sin(a)) - bothRange < Math.abs(Math.cos(a)))
				{
					if (Math.cos(a) > 0)
					{
						tile.x = getPos(x,y).x - Tile.w;
					}
					else
					{
						tile.x = getPos(x,y).x + Tile.w;
					}
				}
				if (Math.abs(Math.sin(a)) > Math.abs(Math.cos(a)) - bothRange)
				{
					if (Math.sin(a) > 0)
					{
						tile.y = getPos(x,y).y - Tile.h;
					}
					else
					{
						tile.y = getPos(x,y).y + Tile.h;
					}
				}
			}
		}
		
		override public function update():void
		{
			friction();
			input();
			//If we're going to hit something, get rid of our velocity.
			if (moveX(v.x))
			{
				tile.x = getPos(x,y).x;
			}
			if (moveY(v.y))
			{
				tile.y = getPos(x,y).y;
			}
			if (!tile.equals(getPos(x+Tile.w/2,y+Tile.h/2)) && vMusicCheck.equals(new Point))
				Music.playSound("Push Rock", -1, 0.5);
			layering();
			death();
		}
		
		override public function render():void
		{
			sprPushableBlockFire.frame = Game.worldFrame(sprPushableBlockFire.frameCount);
			super.render();
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
		
	}

}