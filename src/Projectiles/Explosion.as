package Projectiles 
{
	import Enemies.Enemy;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class Explosion extends Entity
	{
		[Embed(source = "../../assets/graphics/Explosion.png")] private var imgExplosion:Class;
		private var sprExplosion:Spritemap = new Spritemap(imgExplosion, 128, 128, endAnim);
		
		private const animSpeed:int = 20;
		private const force:int = 4;
		private const radiusCoeff:Number = 0.65; //so that the fringes of the explosion image aren't included for collision.
		
		private var radius:int;
		private var hitables:Object;
		private var damage:int;
		
		public function Explosion(_x:int, _y:int, _hit:Object, _r:int = 16, _d:int=1) 
		{
			super(_x, _y, sprExplosion);
			sprExplosion.add("explode", [0, 1, 2, 3, 4, 5, 6, 7], animSpeed);
			sprExplosion.play("explode");
			sprExplosion.centerOO();
			
			hitables = _hit;
			radius = _r;
			damage = _d;
			
			type = "Explosion";
			sprExplosion.scale = radius * 2 / sprExplosion.width; //Assume that the explosion sprite is circular.
			sprExplosion.angle = Math.random() * 360;
			radius *= radiusCoeff; //radius now represents the hitable area of the explosion.
			
			layer = -FP.height;
		}
		
		override public function added():void
		{
			super.added();
			Music.playSoundDistPlayer(x, y, "Explosion", -1, 120);
			var v:Vector.<Entity> = new Vector.<Entity>();
			for (var i:int = 0; i < hitables.length; i++)
			{
				FP.world.collideRectInto(hitables[i], x - radius, y - radius, radius * 2, radius * 2, v);
			}
			for each (var c:Entity in v)
			{
				if (FP.distance(x, y, c.x, c.y) <= radius)
				{
					if (c is Player)
					{
						(c as Player).hit(null, force, new Point(x, y), damage);
					}
					else if (c is Enemy)
					{
						(c as Enemy).hit(force, new Point(x, y), damage);
					}
				}
			}
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override public function render():void
		{
			super.render();
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
		
		public function endAnim():void
		{
			FP.world.remove(this);
		}
		
	}

}