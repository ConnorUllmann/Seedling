package Projectiles
{
	import Enemies.Enemy;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Time
	 */
	public class Arrow extends Mobile
	{
		[Embed(source = "../../assets/graphics/Arrow.png")] private var imgArrow:Class;
		private var sprArrow:Image = new Image(imgArrow);
		
		private var hitables:Object = ["Player", "Enemy", "Tree", "Solid", "Shield"];
		private var die:Boolean = false;
		
		public function Arrow(_x:int, _y:int, _v:Point) 
		{
			super(_x, _y, sprArrow);
			sprArrow.centerOO();
			v = _v;
			f = 0;
			setHitbox(4, 4, 2, 2);
			type = "Arrow";
			solids = [];
			if (v.length > 0)
			{
				sprArrow.angle = Math.atan2(-v.y, v.x) * 180 / Math.PI;
			}
		}
		
		override public function update():void
		{
			super.update();
			if (v.length > 0)
			{
				sprArrow.angle = Math.atan2( -v.y, v.x) * 180 / Math.PI;
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
					Music.playSoundDistPlayer(x, y, "Arrow", 1);
					v.x = v.y = 0;
					die = true;
				}
			}
			if (die)
			{
				(graphic as Image).alpha -= 0.1;
				if ((graphic as Image).alpha <= 0)
					FP.world.remove(this);
			}
			if (x > FP.width || x < 0 || y < 0 || y > FP.height)
			{
				FP.world.remove(this);
			}
		}
		
	}

}