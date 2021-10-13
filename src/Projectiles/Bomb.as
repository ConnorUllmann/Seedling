package Projectiles
{
	import Enemies.Enemy;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Time
	 */
	public class Bomb extends Mobile
	{
		[Embed(source = "../../assets/graphics/Bomb.png")] private var imgBomb:Class;
		private var sprBomb:Spritemap = new Spritemap(imgBomb, 16, 16);
		
		private var hitables:Object = ["Player", "Enemy", "ShieldBoss"];
		
		private const scaleMin:Number = 0.5;
		private const scaleMax:Number = 1.5;
		private var scale:Number = 0.5;
		
		private const tMax:int = 30;
		private var t:int = tMax;
		
		public function Bomb(_x:int, _y:int, _p:Point) 
		{
			super(_x, _y, sprBomb);
			sprBomb.centerOO();
			v = new Point(_p.x - x, _p.y - y);
			v.normalize(v.length / tMax);
			f = 0;
			setHitbox(sprBomb.width, sprBomb.height, sprBomb.width/2, sprBomb.height/2);
			type = "Bomb";
			solids = [];
		}
		
		override public function update():void
		{
			super.update();
			if (t > 0)
			{
				t--;
				scale = (scaleMax - scaleMin) * (Math.sin(t / tMax * Math.PI) + 1)/2 + scaleMin;
			}
			else
			{
				FP.world.remove(this);
			}
			sprBomb.scale = scale;
			sprBomb.angle += 15;
		}
		
		override public function layering():void
		{
			layer = -FP.height;
		}
		
		override public function removed():void
		{
			super.removed();
			FP.world.add(new Explosion(x, y, hitables, 24));
		}
		
	}

}