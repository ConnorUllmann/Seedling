package Scenery 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class BoneTorch extends Entity
	{
		[Embed(source = "../../assets/graphics/BoneTorch.png")] private var imgBoneTorch:Class;
		[Embed(source = "../../assets/graphics/BoneTorch2.png")] private var imgBoneTorch2:Class;
		private var sprBoneTorch:Spritemap;
		
		private const frames:Array = new Array(0, 1, 2, 1);
		private const loops:int = 2;
		
		public function BoneTorch(_x:int, _y:int, _type:int=0, _color:uint=0xFFFFFF, _flipped:Boolean=false) 
		{
			var lightOffset:Point = new Point;
			switch(_type)
			{
				case 0:
					sprBoneTorch = new Spritemap(imgBoneTorch, 16, 24);
					lightOffset = new Point;
					break;
				default:
					sprBoneTorch = new Spritemap(imgBoneTorch2, 16, 24);
					lightOffset = new Point( -1, -11);
			}
			super(_x + Tile.w/2, _y + Tile.h/2, sprBoneTorch);
			sprBoneTorch.originX = 8;
			sprBoneTorch.originY = 16;
			sprBoneTorch.x = -sprBoneTorch.originX;
			sprBoneTorch.y = -sprBoneTorch.originY;
			
			setHitbox(16, 16, 8, 8);
			type = "Solid";
			
			if (_flipped)
				sprBoneTorch.scaleX = -Math.abs(sprBoneTorch.scaleX);
			FP.world.add(new Light(x + lightOffset.x * sprBoneTorch.scaleX, y + lightOffset.y, frames.length, loops, _color, false));
			
			layer = -(y - originY + height);
		}
		
		override public function render():void
		{
			sprBoneTorch.frame = frames[Game.worldFrame(frames.length, loops)];
			super.render();
		}
		
	}

}