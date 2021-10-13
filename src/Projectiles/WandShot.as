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
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Time
	 */
	public class WandShot extends Mobile
	{
		[Embed(source = "../../assets/graphics/WandShot.png")] private var imgWandShot:Class;
		private var sprWandShot:Spritemap = new Spritemap(imgWandShot, 7, 7, animEnd);
		[Embed(source = "../../assets/graphics/FireWandShot.png")] private var imgFireWandShot:Class;
		private var sprFireWandShot:Spritemap = new Spritemap(imgFireWandShot, 9, 9, animEnd);
		
		private const tilesMove:int = 3; // The number of tiles that the shot will travel in a given direction.
		private const force:int = 3; //The knockback when hitting enemies
		
		private var lifeMax:int = 0; //The length of time that the shot lives for
		private var life:int = 0; 
		
		private var damage:Number = 0.5;
		
		private var shotType:int = 0;
		
		private const fireVolume:Number = 0.6;
		private const fizzleVolume:Number = 0.3;
		
		public function WandShot(_x:int, _y:int, _v:Point, _fire:Boolean=false) 
		{
			super(_x, _y, sprWandShot);
			sprWandShot.centerOO();
			sprWandShot.add("flare", [0, 1, 2], 5);
			sprWandShot.add("die", [3, 4, 5], 20);
			sprWandShot.play("flare");
			sprFireWandShot.centerOO();
			sprFireWandShot.add("flare", [0, 1, 2], 5);
			sprFireWandShot.add("die", [3, 4, 5], 20);
			sprFireWandShot.play("flare");
			
			type = "Projectile";
			
			v = _v;
			f = 0;
			
			if (_fire)
			{
				graphic = sprFireWandShot;
				setHitbox(5, 5, 2, 2);
				damage = 1;
				shotType = 1;
			}
			else
			{
				setHitbox(3, 3, 2, 2);
			}
			
			//Only works in the four cardinal directions correctly (if Tile.w == Tile.h)
			lifeMax = tilesMove * Tile.w / v.length;
			life = lifeMax;
			
			solids.push("Enemy");
			
			Music.playSound("Wand Fire", -1, fireVolume);
		}
		
		public function animEnd():void
		{
			if ((graphic as Spritemap).currentAnim == "die")
			{
				destroy = true;
			}
		}
		
		override public function update():void
		{
			if ((graphic as Spritemap).currentAnim != "die")
			{
				life--;
				if (life <= 0)
				{
					Music.playSound("Wand Fizzle", -1, fizzleVolume);
					(graphic as Spritemap).play("die");
				}
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
			}
			death();
		}
		
		public function checkEntity(_e:Entity):void
		{
			if (_e is Enemy)
			{
				(_e as Enemy).hit(force, new Point(x, y), damage, "Wand");
			}
			else if (_e is MagicalLock)
			{
				(_e as MagicalLock).hit(shotType);
			}
			(graphic as Spritemap).play("die");
			Music.playSound("Wand Fizzle", -1, fizzleVolume);
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