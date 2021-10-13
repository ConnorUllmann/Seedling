package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class SlashHit extends Entity
	{
		[Embed(source = "../../assets/graphics/SlashHit.png")] private var imgSlashHit:Class;
		private var sprSlashHit:Spritemap = new Spritemap(imgSlashHit, 32, 16, endAnim);
		
		public function SlashHit(_x:int, _y:int, _scx:Number) 
		{
			super(_x, _y, sprSlashHit);
			sprSlashHit.centerOO();
			sprSlashHit.add("slash", [0, 1], 15);
			sprSlashHit.play("slash");
			sprSlashHit.scale = _scx / sprSlashHit.width + 0.35;
			layer = -(y + Tile.h * 3/2);
		}
		
		override public function render():void
		{
			super.render();
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
		
		public function endAnim():void
		{
			FP.world.remove(this);
		}
		
	}

}