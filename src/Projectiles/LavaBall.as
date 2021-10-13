package Projectiles
{
	import Enemies.Enemy;
	import Enemies.LavaBoss;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class LavaBall extends Mobile
	{
		[Embed(source = "../../assets/graphics/LavaBall.png")] private var imgLavaBall:Class;
		private var sprLavaBall:Spritemap = new Spritemap(imgLavaBall, 48, 32);
		
		public var hitables:Object = ["Player", "Tree", "Solid", "Shield"];
		private const sc:Number = 0.5;
		private var beenHit:Boolean = false;
		
		public function LavaBall(_x:int, _y:int, _v:Point) 
		{
			super(_x, _y, sprLavaBall);
			sprLavaBall.scale = sc;
			sprLavaBall.originX = 32;
			sprLavaBall.x = -sprLavaBall.originX;
			sprLavaBall.originY = 16;
			sprLavaBall.y = -sprLavaBall.originY;
			sprLavaBall.add("fly", [0, 1, 2], 10);
			sprLavaBall.play("fly");
			v = _v;
			f = 0;
			setHitbox(24 * sc, 24 * sc, 12 * sc, 12 * sc);
			type = "LavaBall";
			solids = [];
			if (v.length > 0)
			{
				sprLavaBall.angle = Math.atan2(-v.y, v.x) * 180 / Math.PI;
			}
		}
		
		public function hit():void
		{
			if (!beenHit)
			{
				beenHit = true;
				v.x = -v.x * 2;
				v.y = -v.y * 2;
				hitables.push("LavaBoss");
			}
		}
		
		override public function update():void
		{
			super.update();
			if (v.length > 0)
			{
				imageAngle();
				var hits:Vector.<Entity> = new Vector.<Entity>();
				collideTypesInto(hitables, x, y, hits);
				for (var i:int = 0; i < hits.length; i++)
				{
					switch(hits[i].type)
					{
						case "Player":
							(hits[i] as Player).hit(null, v.length, new Point(x, y));
							break;
						case "Enemy":
							(hits[i] as Enemy).hit(v.length, new Point(x, y));
							break;
						case "LavaBoss":
							(hits[i] as LavaBoss).hit(0, new Point, 1, "LavaBall");
							break;
						default:
					}
				}
				if (hits.length > 0)
				{
					FP.world.add(new Explosion(x + v.x, y + v.y, hitables, 32 * sc, 1));
					FP.world.remove(this);
				}
			}
			if (!onScreen((graphic as Spritemap).width))
			{
				FP.world.remove(this);
			}
		}
		
		public function imageAngle():void
		{
			(graphic as Image).angle = Math.atan2( -v.y, v.x) * 180 / Math.PI;
		}
		
		override public function render():void
		{
			super.render();
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
		
	}

}