package Projectiles
{
	import Enemies.Enemy;
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
	public class TurretSpit extends Mobile
	{
		[Embed(source = "../../assets/graphics/TurretSpit.png")] private var imgTurretSpit:Class;
		private var sprTurretSpit:Spritemap = new Spritemap(imgTurretSpit, 12, 8);
		
		public var hitables:Object = ["Player", "Tree", "Solid", "Shield"];
		
		public function TurretSpit(_x:int, _y:int, _v:Point) 
		{
			super(_x, _y, sprTurretSpit);
			sprTurretSpit.x = -8;
			sprTurretSpit.originX = -sprTurretSpit.x;
			sprTurretSpit.y = -4;
			sprTurretSpit.originY = -sprTurretSpit.y;
			v = _v;
			f = 0;
			setHitbox(4, 4, 2, 2);
			type = "TurretSpit";
			solids = [];
			if (v.length > 0)
			{
				sprTurretSpit.angle = Math.atan2(-v.y, v.x) * 180 / Math.PI;
			}
			Music.playSoundDistPlayer(x, y, "Turret Shoot");
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
						default:
					}
				}
				if (hits.length > 0)
				{
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
			(graphic as Image).alpha = 0.1;
			super.render();
			(graphic as Image).alpha = 1;
			Draw.resetTarget();
		}
		
	}

}