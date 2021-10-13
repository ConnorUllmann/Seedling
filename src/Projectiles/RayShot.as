package Projectiles 
{
	import Enemies.Enemy;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Puzzlements.MagicalLock;
	import Scenery.Tile;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class RayShot extends Mobile
	{
		[Embed(source = "../../assets/graphics/DeathRayShot.png")] private var imgRayShot:Class;
		private var sprRayShot:Spritemap = new Spritemap(imgRayShot, 8, 3, animEnd);
		
		private const force:int = 3; //The knockback when hitting enemies
		private var damage:Number = 100;
		
		public function RayShot(_x:int, _y:int, _v:Point) 
		{
			super(_x, _y, sprRayShot);
			sprRayShot.centerOO();
			sprRayShot.add("flare", [0, 1],15);
			sprRayShot.play("flare");
			
			setHitbox(3, 3, 2, 2);
			type = "Projectile";
			
			v = _v;
			sprRayShot.angle = -Math.atan2(v.y, v.x) * 180 / Math.PI;
			f = 0;			
			solids.push("Enemy");
		}
		
		public function animEnd():void
		{
			destroy = true;
		}
		
		override public function update():void
		{
			const margin:int = 160; //The distance outside of the camera view for which the wandshot will survive
			if(x < FP.camera.x - margin || x > FP.camera.x + FP.screen.width + margin || y < FP.camera.y - margin || y > FP.camera.y + FP.screen.height + margin)
			{
				destroy = true;
			}
			var hitX:Entity = moveX(v.x);
			var hitY:Entity = moveY(v.y);
			if (hitX)
			{
				checkEntity(hitX);
			}
			else if (hitY)
			{
				checkEntity(hitY);
			}
			layering();
			death();
		}
		
		override public function render():void
		{
			super.render();
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
		
		public function checkEntity(_e:Entity):void
		{
			if (_e is Enemy)
			{
				(_e as Enemy).hit(force, new Point(x, y), damage);
			}
			else if (_e is MagicalLock)
			{
				(_e as MagicalLock).hit(100);
			}
			destroy = true;
		}
		
	}

}