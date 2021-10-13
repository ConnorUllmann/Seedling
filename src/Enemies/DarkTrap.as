package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import Scenery.Light;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class DarkTrap extends SandTrap
	{
		[Embed(source = "../../assets/graphics/DarkTrap.png")] private var imgDarkTrap:Class;
		private var sprDarkTrap:Spritemap = new Spritemap(imgDarkTrap, 14, 14, endAnim);
		
		private var deathCounter:int = 30;
		private var startDying:Boolean = false;
		
		public function DarkTrap(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x, _y, _tag, sprDarkTrap);
			
			sprDarkTrap.add("die1", [4, 0, 1, 0, 4, 5, 4, 5, 6, 7, 8, 9, 10, 11], 10);
		}
		
		override public function update():void
		{			
			var v:Vector.<Light> = new Vector.<Light>();
			FP.world.getClass(Light, v);
			for each(var light:Light in v)
			{
				if (!(light is PlayerLight) && FP.distance(x, y, light.x, light.y) <= light.radiusMin && !light.darkLight && !startDying)
				{
					Music.playSound("Enemy Die", 0);
					startDying = true;
				}
			}
			if (startDying)
			{
				if (deathCounter > 0)
				{
					deathCounter--;
				}
				else
				{
					sprDarkTrap.play("die1");
				}
			}
			else
			{
				super.update();
			}
		}
		
		override public function hit(f:Number=0, p:Point=null, d:Number=1, t:String=""):void
		{
			
		}
		
		override public function render():void
		{
			super.render();
			if ((graphic as Spritemap).currentAnim == "die1")
			{
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				super.render();
				Draw.resetTarget();
			}
		}
		
		override public function endAnim():void
		{
			switch((graphic as Spritemap).currentAnim)
			{
				case "die1":
					FP.world.remove(this);
					break;
				default:
					(graphic as Spritemap).play("");
			}
		}
		
	}

}