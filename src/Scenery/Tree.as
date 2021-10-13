package Scenery
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import Pickups.Stick;
	/**
	 * ...
	 * @author Time
	 */
	public class Tree extends Entity
	{
		public var frame:int = 0;
		private var solids:Object = ["Solid", "Tree"];
		private var bare:Boolean;
		
		public function Tree(_x:int, _y:int, _bare:Boolean=false, _g:Graphic=null) 
		{
			super(_x + Tile.w, _y + Tile.h, _g);
			setHitbox(32, 32, 16, 16);
			type = "Tree";
			layer = -(y - originY + height);
			active = false;
			bare = _bare;
		}
		
		override public function check():void
		{
			super.check();
			frame = getFrame();
		}
		
		override public function render():void
		{
			if (!onScreen())
			{
				return;
			}
			if (bare)
			{
				Game.sprTreeBare.frame = frame;
				Game.sprTreeBare.render(new Point(x, y), FP.camera);
			}
			else
			{
				Game.sprTree.frame = frame;
				Game.sprTree.render(new Point(x, y), FP.camera);
			}
		}
		
		public function hit(t:String = ""):void
		{
			
		}
		
		public function getFrame():int
		{
			var v:int = 0;
			if (collide("Tree", x + 1, y) || x + width - originX + 1 > FP.width) { v++; }
			if (collide("Tree", x, y - 1) || y - originY - 1 < 0) { v += 2; }
			if (collide("Tree", x - 1, y) || x - originX - 1 < 0) { v += 4; }
			if (collide("Tree", x, y + 1) || y + height - originY + 1 > FP.height) { v += 8;}
			return v;
		}
	}

}