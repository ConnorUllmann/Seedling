package Puzzlements 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class BeamTower extends Entity
	{
		[Embed(source = "../../assets/graphics/BeamTower.png")] private var imgBeamTower:Class;
		private var sprBeamTower:Spritemap = new Spritemap(imgBeamTower, 16, 40, animEnd);
		
		private var direction:int;
		private var rate:Number;
		
		private const force:int = 5;
		private const damage:int = 1;
		
		private var playedSound:Boolean = false;
		
		public function BeamTower(_x:int, _y:int, _startdirection:int=0, _rate:Number=1, speed:Number=1) 
		{
			super(_x + 8, _y + 16, sprBeamTower);
			
			sprBeamTower.originX = 8;
			sprBeamTower.originY = 32;
			sprBeamTower.x = -sprBeamTower.originX;
			sprBeamTower.y = -sprBeamTower.originY;
			
			const animSpeed:int = 10 * speed;
			sprBeamTower.add("right", [1, 2], animSpeed);
			sprBeamTower.add("up", [3, 4], animSpeed);
			sprBeamTower.add("left", [5, 6], animSpeed);
			sprBeamTower.add("down", [7, 8], animSpeed);
			sprBeamTower.add("sit", [0, 0], animSpeed);
			sprBeamTower.play("right");
			
			setHitbox(16, 32, 8, 24);
			type = "Solid";
			
			direction = _startdirection;
			rate = _rate;
			
			layer = -y;
		}
		
		override public function update():void
		{
			if (Game.freezeObjects)
			{
				return;
			}
			super.update();
			if ((sprBeamTower.frame - 1) % 2 == 1) //Beaming
			{
				if (!playedSound)
				{
					var p:Player = FP.world.nearestToPoint("Player", x, y) as Player;
					var xT:int = x;
					var yT:int = y;
					if (p)
					{
						if (direction == 0)
						{
							xT = Math.max(p.x, x);
						}
						else if (direction == 1)
						{
							yT = Math.min(p.y, y);
						}
						else if (direction == 2)
						{
							xT = Math.min(p.x, x);
						}
						else if (direction == 3)
						{
							yT = Math.max(p.y, y);
						}
					}
					Music.playSoundDistPlayer(xT, yT, "Energy Beam");
					playedSound = true;
				}
				var rect:Rectangle = getRect(direction);
				p = FP.world.collideRect("Player", rect.x, rect.y, rect.width, rect.height) as Player;
				if (p)
				{
					p.hit(null, force, new Point(x,y), damage);
					Game.shake = 15;
				}
			}
			else
				playedSound = false;
			
			var radius:Number = 0.3;
			const phases:int = 100;
			const loops:Number = 2;
			y += radius * Math.sin(Game.worldFrame(phases, loops) / phases * 2 * Math.PI);
		}
		
		override public function render():void
		{
			var a:Number = 0;
			if (sprBeamTower.currentAnim != "sit")
			{
				a = (sprBeamTower.frame - 1) % 2 == 0 ? 0.1 : 1;
			}
			
			if (a > 0 && direction == 1)
			{
				drawLine(direction, a);
			}
			super.render();
			if (a > 0 && direction != 1)
			{
				drawLine(direction, a);
			}
		}
		
		private function drawLine(d:int, a:Number):void
		{
			if (Game.freezeObjects)
			{
				return;
			}
			var line:Vector.<Point> = new Vector.<Point>();
			var n:int = (d == 0 || d == 2) ? 5 : 4;
			for (var i:int = 0; i < n; i++)
			{
				line = getLine(d, i);
				Draw.linePlus(line[0].x, line[0].y, line[1].x, line[1].y, (i <= 0 || i >= n-1) ? 0xFF0000 : 0xFFFF00, a);
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				Draw.linePlus(line[0].x, line[0].y, line[1].x, line[1].y, (i <= 0 || i >= n-1) ? 0xFF0000 : 0xFFFF00, a);
				Draw.resetTarget();
			}
		}
		
		private function getRect(d:int):Rectangle
		{
			var line:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
			line.push(getLine(direction, 0));
			line.push(getLine(direction, 4));
			return new Rectangle(Math.min(line[0][0].x, line[1][1].x), Math.min(line[0][0].y, line[1][1].y), Math.abs(line[1][1].x-line[0][0].x), Math.abs(line[1][1].y-line[0][0].y))
		}
		
		/**
		 * Gets the line in a direction
		 * @param	d	The direction (0 = right, 1 = up, 2 = left, 3 = down)
		 * @param	n	Which line it is of the thickness of the laser
		 * return	Vector of two points where the first is the start point, and the second is the end point.
		 */
		private function getLine(d:int, n:int):Vector.<Point>
		{
			var line:Vector.<Point> = new Vector.<Point>();
			var from:Point = new Point(x, y - 8);
			var to:Point = new Point;
			switch(d)
			{
				case 0:
					from.x += 6; from.y -= 11 - n;
					to = new Point(FP.width, from.y);
					break;
				case 1:
					from.x -= 2 - n; from.y -= 11;
					to = new Point(from.x, 0);
					break;
				case 2:
					from.x -= 6; from.y -= 11 - n;
					to = new Point(0, from.y);
					break;
				case 3:
					from.x -= 2 - n; from.y -= 5;
					to = new Point(from.x, FP.height);
					break;
				default:
					to = from.clone();
			}
			line.push(from, to);
			return line;
		}
		
		public function animEnd():void
		{
			if (sprBeamTower.currentAnim == "sit")
			{
				direction = (direction + rate + 4) % 4;
				sprBeamTower.play(getAnimation(direction));
			}
			else
			{
				sprBeamTower.play("sit");
			}
		}
		
		private function getAnimation(d:int):String
		{
			switch(d)
			{
				case 0:
					return "right";
				case 1:
					return "up";
				case 2:
					return "left";
				case 3:
					return "down";
				default:
					return "";
			}
		}
		
	}

}