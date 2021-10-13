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
	public class IceTurretBlast extends Mobile
	{
		[Embed(source = "../../assets/graphics/IceBlast.png")] private var imgIceBlast:Class;
		private var sprIceBlast:Spritemap = new Spritemap(imgIceBlast, 16, 7);
		
		private var hitables:Object = ["Player", "Tree", "Solid", "Shield"];
		private const freezeTime:int = 15;
		
		public function IceTurretBlast(_x:int, _y:int, _v:Point) 
		{
			super(_x, _y, sprIceBlast);
			sprIceBlast.x = -8;
			sprIceBlast.originX = -sprIceBlast.x;
			sprIceBlast.y = -4;
			sprIceBlast.originY = -sprIceBlast.y;
			v = _v;
			f = 0;
			setHitbox(4, 4, 2, 2);
			type = "IceBlast";
			solids = [];
			if (v.length > 0)
			{
				sprIceBlast.angle = Math.atan2(-v.y, v.x) * 180 / Math.PI;
			}
			Music.playSoundDistPlayer(x, y, "Other", 2, 200, 0.4);
		}
		
		override public function update():void
		{
			super.update();
			if (v.length > 0)
			{
				sprIceBlast.angle = Math.atan2( -v.y, v.x) * 180 / Math.PI;
				var hits:Vector.<Entity> = new Vector.<Entity>();
				collideTypesInto(hitables, x, y, hits);
				for (var i:int = 0; i < hits.length; i++)
				{
					switch(hits[i].type)
					{
						case "Player":
							(hits[i] as Player).freeze(freezeTime);
							(hits[i] as Player).hit(null, 0, new Point(x, y));
							break;
						case "Enemy":
							(hits[i] as Enemy).hit(0, new Point(x, y));
							break;
						default:
					}
				}
				if (hits.length > 0)
				{
					FP.world.remove(this);
				}
			}
		}
		
	}

}