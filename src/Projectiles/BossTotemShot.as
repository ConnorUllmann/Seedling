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
	public class BossTotemShot extends Mobile
	{
		[Embed(source = "../../assets/graphics/BossTotemShot.png")] private var imgBossTotemShot:Class;
		private var sprBossTotemShot:Spritemap = new Spritemap(imgBossTotemShot, 20, 20);
		
		public var hitables:Object = ["Player", "Solid"];
		private const roomBottom:int = 384; // THE BOTTOM WALL OF THE ROOM TO DESTROY AT
		private const spinRate:int = -6;
		
		public function BossTotemShot(_x:int, _y:int, _v:Point) 
		{
			super(_x, _y, sprBossTotemShot);
			sprBossTotemShot.centerOO();
			sprBossTotemShot.add("fly", [0, 1, 2], 10);
			sprBossTotemShot.play("fly");
			v = _v;
			f = 0;
			setHitbox(16, 16, 8, 8);
			type = "BossTotemShot";
			solids = [];
			if (v.length > 0)
			{
				imageAngle();
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
				destroy = false;
				var flipped:Boolean = false;
				for (var i:int = 0; i < hits.length; i++)
				{
					switch(hits[i].type)
					{
						case "Player":
							(hits[i] as Player).hit(null, v.length, new Point(x, y));
							destroy = true;
							break;
						case "Solid":
							if (!flipped)
							{
								v.x = -v.x;
								flipped = true;
							}
							break;
						default:
					}
				}
				if (destroy || y - originY + height >= roomBottom)
				{
					FP.world.add(new Explosion(x + v.x, y + v.y, hitables, 24, 1));
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
			(graphic as Image).angle += spinRate * FP.sign(v.x);
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