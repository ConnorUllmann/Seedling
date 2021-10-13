package Pickups
{
	import flash.geom.Point;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Time
	 */
	public class Stick extends Pickup
	{
		[Embed(source = "../../assets/graphics/Stick.png")] private var imgStick:Class;
		private var sprStick:Image = new Image(imgStick);
		
		public function Stick(_x:int, _y:int, _v:Point=null) 
		{
			super(_x, _y, sprStick, _v);
			sprStick.centerOO();
			sprStick.angle = Math.random() * 360;
			type = "Stick";
			setHitbox(4, 4, 2, 2);
			
			solids = ["Solid"];
		}
		
	}

}