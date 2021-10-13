package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import Scenery.Light;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class PlayerLight extends Light
	{
		[Embed(source = "../assets/graphics/PlayerLight.png")] private var imgPlayerLight:Class;
		private var sprPlayerLight:Image = new Image(imgPlayerLight);
		
		private var follow:Player;
		private var colorLoops:int = 12;
		
		private const movementDivisor:int = 5;
		private const colors:Array = new Array(0xFFCC00, 0xFFFFFF, 0xFF0000, 0x00FF00, 0x0000FF);
		
		public function PlayerLight(_x:int, _y:int, _follow:Player) 
		{
			super(_x, _y, 100, 3, colors[0], true, 20);
			alpha = 0.5;
			follow = _follow;
			graphic = sprPlayerLight;
			sprPlayerLight.centerOO();
		}
		
		override public function update():void
		{
			var wf:int = Game.worldFrame(frames, colorLoops);
			color = FP.colorLerp(colors[int(wf / frames * colors.length)], colors[int(wf / frames * colors.length + 1) % colors.length], wf / frames * colors.length - int(wf / frames * colors.length))
			sprPlayerLight.color = color;
			if (follow)
			{
				x += (follow.x + follow.myLightPosition.x - x)/movementDivisor;
				y += (follow.y + follow.myLightPosition.y - y)/movementDivisor;
			}
			super.update();
		}
		
	}

}