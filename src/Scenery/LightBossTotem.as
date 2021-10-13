package Scenery 
{
	import Enemies.LightBoss;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class LightBossTotem extends Entity
	{
		[Embed(source = "../../assets/graphics/LightBossTotem.png")] private var imgLightBossTotem:Class;
		private var sprLightBossTotem:Image = new Image(imgLightBossTotem);
		
		private var _die:Boolean = false;
		
		public function LightBossTotem(_x:int, _y:int) 
		{
			super(_x, _y, sprLightBossTotem);
			setHitbox(16, 16);
			sprLightBossTotem.originY = 8;
			sprLightBossTotem.y = -sprLightBossTotem.originY;
			type = "Solid";
			layer = -(y - originY + height / 2);
		}
		
		override public function render():void
		{
			if (die)
			{
				FP.world.add(new Light(x + Tile.w / 2, y + Tile.h / 2, 100, 1, 0xFFFF00, true, 6, 10, y/FP.height));
				(graphic as Image).scaleX *= 0.9;
				(graphic as Image).scaleY += 0.1;
				(graphic as Image).color = FP.colorLerp(0xFFFFFF, 0xFF0000, Math.min(1, (graphic as Image).scaleY / 2));
				type = "";
				y -= 10;
			}
			super.render();
			(graphic as Image).alpha = 0.5;
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
			(graphic as Image).alpha = 1;
		}
		
		public function set die(_t:Boolean):void
		{
			Music.playSound("Boss Die", 2, 0.3);
			_die = _t;
		}
		public function get die():Boolean
		{
			return _die;
		}
		
	}

}