package Puzzlements 
{
	import Enemies.Enemy;
	import Enemies.IceTurret;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import Scenery.Tile;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class Crusher extends Activators
	{
		[Embed(source = "../../assets/graphics/Crusher.png")] private var imgCrusher:Class;
		private var sprCrusher:Spritemap = new Spritemap(imgCrusher, 32, 32);
		
		private const hitables:Object = ["Player", "Solid", "Enemy", "ShieldBoss"];
		private const solids:Object = ["Solid"];
		private const intDist:int = 64;
		private const speed:int = 1; //The speed of the crusher when it moves.
		private const spinRate:int = 8;
		
		/* Utility constant for collisions */
		private const directions:Array = new Array(new Point(1, 0), new Point(0, -1), new Point( -1, 0), new Point(0, 1));
		
		private var v:Point = new Point();
		
		private var force:int = 1;
		private var damage:int = 1000; // KILL EVERYTHING
		
		public function Crusher(_x:int, _y:int, _t:int) 
		{
			super(_x + Tile.w, _y + Tile.h, sprCrusher, _t);
			(graphic as Image).centerOO();
			setHitbox(32, 32, 16, 16);
			type = "Solid";
		}
		
		override public function update():void
		{
			super.update();
			if (activate || t == -1)
			{
				var roundedPos:Point = new Point(Math.round(x / Tile.w) * Tile.w, Math.round(y / Tile.h) * Tile.h);
				if (v.x == 0 && v.y == 0)
				{
					x = roundedPos.x;
					y = roundedPos.y;
					var p:Player = FP.world.nearestToEntity("Player", this) as Player;
					if (p)
					{
						var checkMovement:Boolean = true;
						type = "BS";
						var c:Entity = FP.world.collideLine("Solid", x, y, p.x, p.y);
						type = "Solid";
						if (!c)
						{
							for (var i:int = 0; i < directions.length; i++)
							{
								var offsetX:int = -originX + intDist * (directions[i].x < 0 ? directions[i].x : 0);
								var offsetY:int = -originY + intDist * (directions[i].y < 0 ? directions[i].y : 0);
								var w:int = width  + intDist * Math.abs(directions[i].x);
								var h:int = height + intDist * Math.abs(directions[i].y);
								if (FP.world.collideRect("Player", x + offsetX, y + offsetY, w, h))
								{
									v.x = directions[i].x * speed;
									v.y = directions[i].y * speed;
								}
							}
						}
					}
				}
				else if (Music.soundPercentage("Other", 4) >= 0.1 || !Music.soundIsPlaying("Other", 4))
				{
					Music.playSoundDistPlayer(x, y, "Other", 4, 120, 0.5);
				}
				moveX(v.x);
				moveY(v.y);
				hit();
			}
		}
		
		public function hit():void
		{
			var v:Vector.<Entity> = new Vector.<Entity>();
			for (var i:int = 0; i < hitables.length; i++)
			{
				collideInto(hitables[i], x, y, v);
			}
			for each(var c:Entity in v)
			{
				if (c is Player)
				{
					(c as Player).hit(null, force, new Point(x, y), damage);
				}
				else if (c is Enemy)
				{
					(c as Enemy).hit(force, new Point(x, y), damage, "Crusher");
				}
			}
		}
		
		override public function render():void
		{
			(graphic as Image).angle += v.length > 0 ? spinRate : 0;
			if (v.length == 0)
			{
				(graphic as Image).angle = 0;
			}
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			super.render();
			for (var i:int = 0; i < directions.length; i++)
			{
				var offsetX:int = -originX + intDist * (directions[i].x < 0 ? directions[i].x : 0);
				var offsetY:int = -originY + intDist * (directions[i].y < 0 ? directions[i].y : 0);
				var w:int = width  + intDist * Math.abs(directions[i].x);
				var h:int = height + intDist * Math.abs(directions[i].y);
				Draw.rect(x + offsetX, y + offsetY, w, h);
			}
			Draw.resetTarget();
			super.render();
		}
		
		public function moveX(_xrel:Number):Entity //returns the object that is hit
		{
			for (var i:int = 0; i < Math.abs(_xrel); i++)
			{
				var c:Entity = collideTypes(solids, x + Math.min(1, (Math.abs(_xrel) - i)) * FP.sign(_xrel), y);
				if (!c)
				{
					x += Math.min(1, (Math.abs(_xrel) - i)) * FP.sign(_xrel);
				}
				else
				{
					v.x = 0;
					return c;
				}
			}
			return null;
		}
		
		public function moveY(_yrel:Number):Entity //returns the object that is hit
		{
			for (var i:int = 0; i < Math.abs(_yrel); i++)
			{
				var c:Entity = collideTypes(solids, x, y + Math.min(1, Math.abs(_yrel) - i) * FP.sign(_yrel));
				if (!c)
				{
					y += Math.min(1, Math.abs(_yrel) - i) * FP.sign(_yrel);
				}
				else
				{
					v.y = 0;
					return c;
				}
			}
			return null;
		}
		
	}

}