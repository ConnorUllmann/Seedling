package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class DustParticle extends Entity
	{
		private const w:int = Math.random() * 3 + 1;
		private const h:int = w;
		private const c:uint = FP.getColorRGB(Math.random() * 64 + 192, Math.random() * 64 + 192, 0);
		private var a:Number = Math.random() / 2 + 0.5;
		
		private const m:Number = Math.random() * 2 + 1;
		private var startT:int;
		private var startY:int;
		
		public function DustParticle(_x:int, _y:int) 
		{
			super(_x, _y);
			startY = y - FP.camera.y;
			startT = Game.time;
			
			layer = -FP.height;
		}
		
		override public function update():void
		{
			x = (Game.time - startT) * m + FP.camera.x;
			y = FP.camera.y + startY + Math.sin((Game.time - startT) / m) * m;
			
			if ((FP.world as Game).timeRate <= 0)
			{
				a -= 1 / (m * 10);
				if (a <= 0)
				{
					FP.world.remove(this);
				}
			}
			
			if (x >= FP.camera.x + FP.screen.width || x < FP.camera.x || y <  FP.camera.y || y >= FP.camera.y + FP.screen.height)
			{
				FP.world.remove(this);
			}
		}
		
		override public function render():void
		{
			Draw.rect(x, y, w, h, c, a);
		}
		
	}

}