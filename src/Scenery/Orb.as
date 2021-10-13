package Scenery
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class Orb extends Entity
	{
		[Embed(source = "../../assets/graphics/Orb.png")] private var imgOrb:Class;
		private var sprOrb:Spritemap = new Spritemap(imgOrb, 8, 8);
		
		private var radiusMax:int = 48;
		private var radiusMin:int = 40;
		private var alpha:Number = 0.2;
		private var color:uint;
		
		private var startX:int;
		private var startY:int;
		
		private const moveRadius:int = 5;
		private const phases:int = 100;
		private const loops:int = 4;
		private const randVal:Number = Math.random();
		private var myLight:Light;
		
		public function Orb(_x:int, _y:int, _c:uint=0xFFFFFF) 
		{
			super(_x, _y, sprOrb);
			startX = x;
			startY = y;
			
			color = _c;
			layer = -(y - sprOrb.originY + sprOrb.height + Tile.h / 2);
			
			sprOrb.centerOO();
			sprOrb.color = color;
			
			FP.world.add(myLight = new Light(x, y, 60, 2, color, true, radiusMin, radiusMax, alpha));
		}
		
		override public function update():void
		{
			super.update();
			
			x = startX + moveRadius * Math.sin((Game.worldFrame(phases, loops) / (phases-1) + randVal) * 4 * Math.PI);
			y = startY + moveRadius * Math.sin((Game.worldFrame(phases, loops) / (phases - 1) + randVal) * 2 * Math.PI);
			
			if (myLight)
			{
				myLight.x = x;
				myLight.y = y;
			}
		}
		
		override public function render():void
		{
			sprOrb.frame = Game.worldFrame(sprOrb.frameCount, loops);
			super.render();
		}
		
	}

}