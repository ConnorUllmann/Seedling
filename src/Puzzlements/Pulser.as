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
	public class Pulser extends Activators
	{
		[Embed(source = "../../assets/graphics/Pulser.png")] private var imgPulser:Class;
		private var sprPulser:Spritemap = new Spritemap(imgPulser, 16, 16, endAnim);
		
		private const radiusMin:int = 10;
		private const radiusMax:int = 28;
		private const radiusHit:int = 22;
		private var radius:Number = radiusMin;
		private const radiusRate:Number = 0.8;
		
		private const thicknessMin:int = 1;
		private const thicknessMax:int = 8;
		private const thicknessLightExtra:int = 2;
		
		private const pulseColor:uint = 0xFFFF00;
		private const pulseTimerMax:int = 20;
		private var pulseTimer:int = 0;
		
		private const force:int = 6;
		private const damage:int = 1;
		
		private const hitables:Object = ["Player", "Solid", "Enemy"];
		
		public function Pulser(_x:int, _y:int, _t:int) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprPulser, _t);
			(graphic as Image).centerOO();
			(graphic as Spritemap).add("pulse", [0, 1, 2, 3, 4], 20);
			(graphic as Spritemap).add("", [0]);
			(graphic as Spritemap).play("");
			setHitbox(16, 16, 8, 8);
			type = "Solid";
		}
		
		override public function update():void
		{
			super.update();
			if (activate || radius > radiusMin)
			{
				if ((graphic as Spritemap).currentAnim == "")
				{
					if (pulseTimer > 0)
					{
						pulseTimer--;
					}
					else if(pulseTimer == 0)
					{
						(graphic as Spritemap).play("pulse");
						Music.playSoundDistPlayer(x, y, "Energy Pulse", -1, 120);
						pulseTimer = -1;
					}
					else
					{
						hit();
						radius += radiusRate;
						if (radius >= radiusMax)
						{
							pulseTimer = pulseTimerMax;
							radius = radiusMin;
						}
					}
				}
			}
			else
			{
				pulseTimer = -1;
				radius = radiusMin;
			}
		}
		
		public function hit():void
		{
			var v:Vector.<Entity> = new Vector.<Entity>();
			for (var i:int = 0; i < hitables.length; i++)
			{
				FP.world.collideRectInto(hitables[i], x - radiusHit, y - radiusHit, radiusHit * 2, radiusHit * 2, v);
			}
			for each(var c:Entity in v)
			{
				if (FP.distanceRectPoint(x, y, c.x - c.originX, c.y - c.originY, c.width, c.height) > radiusHit)
				{
					continue;
				}
				if (c is PushableBlockFire)
				{
					(c as PushableBlockFire).hit(new Point(x, y), "Pulse");
				}
				else if (c is IceTurret)
				{
					(c as IceTurret).bump(new Point(x, y), "Pulse");
				}
				else if (c is Enemy)
				{
					(c as Enemy).hit(force, new Point(x, y), damage, "Pulse");
				}
				else if (c is Player)
				{
					(c as Player).hit(null, force, new Point(x, y), damage);
				}
			}
		}
		
		override public function render():void
		{
			if (radius > radiusMin)
			{
				const rVal:Number = 1 - radius / radiusMax;
				Draw.circlePlus(x, y, radius, pulseColor, rVal, false, (thicknessMax - thicknessMin) * rVal + thicknessMin);
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				Draw.circlePlus(x, y, radius, pulseColor, rVal, false, (thicknessMax - thicknessMin) * rVal + thicknessMin + thicknessLightExtra);
				Draw.resetTarget();
			}
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
			super.render();
		}
		
		public function endAnim():void
		{
			if ((graphic as Spritemap).currentAnim == "pulse")
			{
				(graphic as Spritemap).play("");
			}
		}
		
	}

}