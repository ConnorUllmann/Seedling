package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Time
	 */
	public class RuinedPillar extends Entity
	{
		
		[Embed(source = "../../assets/graphics/RuinedPillar.png")] private var imgRuinedPillar:Class;
		private var sprRuinedPillar:Spritemap = new Spritemap(imgRuinedPillar, 32, 48);
		
		public function RuinedPillar(_x:int, _y:int) 
		{
			super(_x, _y, sprRuinedPillar);
			sprRuinedPillar.y = -16;
			sprRuinedPillar.originY = -sprRuinedPillar.y;
			setHitbox(32, 32);
			type = "Solid";
			layer = -(y - originY + height * 4/5);
		}
		
	}

}