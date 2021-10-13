package Scenery 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Time
	 */
	public class BurnableTree extends Tree
	{
		[Embed(source = "../../assets/graphics/BurnableTreeBurn.png")] private var imgBurnableTreeBurn:Class;
		private var sprBurnableTreeBurn:Spritemap = new Spritemap(imgBurnableTreeBurn, 32, 32, burnEnd);
		
		private var tag:int;
		private var burn:Boolean = false;
		
		public function BurnableTree(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x, _y, false, sprBurnableTreeBurn);
			tag = _tag;
			active = true;
			type = "Solid"; //NOT a tree.  Done so it doesn't loop with the other trees.
			sprBurnableTreeBurn.centerOO();
			sprBurnableTreeBurn.add("burn", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 15);
		}
		
		override public function hit(t:String = ""):void
		{
			if (t == "Fire" && !burn)
			{
				Music.playSound("Burn", 0);
				burn = true;
				sprBurnableTreeBurn.play("burn");
			}
		}
		
		public function burnEnd():void
		{
			die();
		}
		
		override public function render():void
		{
			graphic.render(new Point(x, y), FP.camera);
		}
		
		override public function removed():void
		{
			super.removed();
			Game.setPersistence(tag, false);
			resetSurroundingTreeFrames();
		}
		
		override public function check():void
		{
			super.check();
			if (tag >= 0 && !Game.checkPersistence(tag))
			{
				die();
			}
		}
		
		public function die():void
		{
			type = "";
			FP.world.remove(this);
		}
		
		override public function getFrame():int { return 0; }
		
		public function resetSurroundingTreeFrames():void
		{
			var trees:Vector.<Entity> = new Vector.<Entity>();
			var c:Entity;
			c = collide("Tree", x - 1, y);
			if (c) { trees.push(c); }
			c = collide("Tree", x + 1, y);
			if (c) { trees.push(c); }
			c = collide("Tree", x, y - 1);
			if (c) { trees.push(c); }
			c = collide("Tree", x, y + 1);
			if (c) { trees.push(c); }
			
			for each(var t:Entity in trees)
			{
				if (t is Tree && t != this)
				{
					(t as Tree).frame = (t as Tree).getFrame();
				}
			}
		}
		
	}

}