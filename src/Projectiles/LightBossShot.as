package Projectiles 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class LightBossShot extends TurretSpit
	{
		[Embed(source = "../../assets/graphics/LightBossShot.png")] private var imgLightBossShot:Class;
		private var sprLightBossShot:Spritemap = new Spritemap(imgLightBossShot, 8, 8);
		
		private const angleSpinRate:int = 10;
		
		public function LightBossShot(_x:int, _y:int, _v:Point) 
		{
			super(_x, _y, _v);
			graphic = sprLightBossShot;
			sprLightBossShot.centerOO();
			v = _v;
			f = 0;
			setHitbox(4, 4, 2, 2);
			type = "LightBossShot";
			solids = [];
			hitables = ["Player"];
		}
		
		override public function imageAngle():void
		{
			if (!Game.freezeObjects)
			{
				(graphic as Image).angle += angleSpinRate;
			}
		}
		
		override public function update():void
		{
			super.update();
			if (!onScreen())
			{
				FP.world.remove(this);
			}
		}
		
	}

}