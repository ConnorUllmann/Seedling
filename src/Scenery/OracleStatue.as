package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Time
	 */
	public class OracleStatue extends Entity
	{
		
		[Embed(source = "../../assets/graphics/OracleStatue.png")] private var imgOracleStatue:Class;
		private var sprOracleStatue:Spritemap = new Spritemap(imgOracleStatue, 32, 48);
		
		public function OracleStatue(_x:int, _y:int) 
		{
			super(_x, _y, sprOracleStatue);
			sprOracleStatue.y = -16;
			sprOracleStatue.originY = -sprOracleStatue.y;
			setHitbox(32, 32);
			type = "Solid";
			layer = -(y - originY + height * 4/5);
		}
		
		override public function render():void
		{
			sprOracleStatue.frame = Game.worldFrame(sprOracleStatue.frameCount);
			super.render();
		}
		
	}

}