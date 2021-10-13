package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Pixelmask;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class TreeLarge extends Entity
	{
		[Embed(source = "../../assets/graphics/TreeLargeMask.png")] private var imgTreeLargeMask:Class;
		[Embed(source = "../../assets/graphics/TreeLarge.png")] private var imgTreeLarge:Class;
		private var sprTreeLarge:Spritemap = new Spritemap(imgTreeLarge, 160, 192);
		
		private static const shine:Array = new Array(0, 1, 2, 3, 2, 1);
		private static const phases:int = 100;
		private static const loops:int = 3;
		
		public function TreeLarge(_x:int, _y:int) 
		{
			super(_x + 80, _y + 96, sprTreeLarge);
			sprTreeLarge.centerOO();
			mask = new Pixelmask(imgTreeLargeMask, -80, -96);//
			type = "Solid";
			layer = -(y - originY + 138);
			active = false;
		}
		
		override public function render():void
		{		
			
			drawTree(1);
			
			const minAlpha:Number = 0.5;
			const maxAlpha:Number = 1;
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			//drawTree(minAlpha + (maxAlpha - minAlpha) * (Math.sin(Game.worldFrame(phases, loops) / phases * 2 * Math.PI + Math.PI) + 1) / 2);
			Draw.resetTarget();
		}
		
		public function drawTree(alpha:Number):void
		{		
			var frame:Number = Game.worldFrame(phases, loops) / phases * shine.length;
			sprTreeLarge.alpha = alpha;
			sprTreeLarge.frame = shine[Math.floor(frame)];
			super.render();
			sprTreeLarge.alpha = alpha * (frame - Math.floor(frame));
			sprTreeLarge.frame = shine[Math.ceil(frame) % shine.length];
			super.render();
		}
		
	}

}