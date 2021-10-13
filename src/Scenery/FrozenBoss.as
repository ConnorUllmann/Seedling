package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class FrozenBoss extends Entity
	{
		[Embed(source = "../../assets/graphics/FrozenBoss.png")] private var imgFrozenBoss:Class;
		private var sprFrozenBoss:Image = new Image(imgFrozenBoss);
		
		public function FrozenBoss(_x:int, _y:int) 
		{
			super(_x, _y, sprFrozenBoss);
			setHitbox(80, 32, -32, -128);
			type = "Solid";
			layer = -(y - originY + height*2/3);
		}
		
		override public function render():void
		{
			super.render();
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
		
	}

}