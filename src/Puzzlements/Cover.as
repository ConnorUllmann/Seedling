package Puzzlements 
{
	import Enemies.*;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class Cover extends Activators
	{
		[Embed(source = "../../assets/graphics/Cover.png")] private var imgCover:Class;
		public var sprCover:Spritemap = new Spritemap(imgCover, 16, 16);
		
		private var normType:String = "Solid";
		
		private var hitables:Object = ["Solid", "Player"];
		
		public function Cover(_x:int, _y:int, _t:int, _g:Graphic=null) 
		{
			if (!_g)
			{
				_g = sprCover;
			}
			super(_x + Tile.w/2, _y + Tile.h/2, _g, _t);
			(graphic as Image).centerOO();
			setHitbox(16, 16, 8, 8);
			type = normType;
			
			layer = -(y - originY + height+1);
		}
		
		override public function update():void
		{
			super.update();
			if (activate)
			{
				(graphic as Image).alpha -= 0.1;
				if ((graphic as Image).alpha <= 0)
				{
					type = "";
					(graphic as Image).alpha = 0;
				}
			}
			else 
			{
				var v:Vector.<Entity> = new Vector.<Entity>();
				collideTypesInto(hitables, x, y, v);
				if (v.length > 0)
				{
					for each(var c:Entity in v)
					{
						if (c is Chest) //Anything that can go underneath a cover can go here
						{
							reset();
						}
					}
				}
				else
				{
					reset();
				}
			}
		}
		public function reset():void
		{
			type = normType;
			(graphic as Image).alpha = 1;
		}
		
		override public function render():void
		{
			(graphic as Spritemap).frame = Game.worldFrame((graphic as Spritemap).frameCount);
			super.render();
		}
		
	}

}