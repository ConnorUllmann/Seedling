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
	public class PlantTorch extends Entity
	{
		[Embed(source = "../../assets/graphics/PlantTorch.png")] private var imgPlantTorch:Class;
		private var sprPlantTorch:Spritemap;
		
		private const frames:Array = new Array(0, 1, 2, 1);
		private const loops:Number = 1;
		private var myLight:Light;
		
		private var distance:int; //The maximal distance that any light is shown to the player
								  //(This light turns off when the player gets far away)
		
		public function PlantTorch(_x:int, _y:int, _color:uint=0xFFFFFF, _flipped:Boolean=false, _distance:int=100) 
		{
			sprPlantTorch = new Spritemap(imgPlantTorch, 16, 16);
			super(_x + Tile.w/2, _y + Tile.h/2, sprPlantTorch);
			sprPlantTorch.originX = 8;
			sprPlantTorch.originY = 8;
			sprPlantTorch.x = -sprPlantTorch.originX;
			sprPlantTorch.y = -sprPlantTorch.originY;
			
			distance = _distance;
			
			setHitbox(16, 16, 8, 8);
			type = "Solid";
			
			if (_flipped)
				sprPlantTorch.scaleX = -Math.abs(sprPlantTorch.scaleX);
				
			var lightOffset:Point = new Point(0, -5);
			FP.world.add(myLight = new Light(x + lightOffset.x * sprPlantTorch.scaleX, y + lightOffset.y, 100, loops, _color, true));
		}
		
		override public function render():void
		{
			var p:Player = FP.world.nearestToEntity("Player", this) as Player;
			if (myLight && p)
			{
				myLight.alpha = 0.2 * Math.pow(Math.max(1 - FP.distance(x, y, p.x, p.y) / distance, 0), 2);
			}
			sprPlantTorch.frame = frames[Game.worldFrame(frames.length, loops)];
			super.render();
		}
		
	}

}