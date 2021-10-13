package Scenery 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import Puzzlements.Activators;
	/**
	 * ...
	 * @author Time
	 */
	public class LightPole extends Activators
	{
		[Embed(source = "../../assets/graphics/LightPole.png")] private var imgLightPole:Class;
		private var sprLightPole:Image = new Image(imgLightPole);
		
		private const loops:Number = 1.5;
		private const lightAlpha:Number = 0.5;
		private const hitsTimerMax:int = 25;
		
		private var hitsTimer:int = 0;
		
		private var myLight:Light;
		private var color:uint;
		private var startY:int;
		private var tag:int;
		private var invert:Boolean;
		
		public function LightPole(_x:int, _y:int, _t:int=0, _tag:int = -1, _color:uint = 0xFFFFFF, _invert:Boolean=false) 
		{
			super(_x + Tile.w / 2, _y + Tile.h / 2, sprLightPole, _t);
			startY = y;
			sprLightPole.centerOO();
			
			tag = _tag;
			layer = -(y - sprLightPole.originY + sprLightPole.height);
			
			color = _color;
			FP.world.add(myLight = new Light(x, y, 100, loops, color, true, 28, 32, lightAlpha));
			myLight.layer = layer - 1;
			myLight.i_radius_factor = 0.8;
			
			type = "LightPole";
			setHitbox(10, 12, 5, 6);
			
			invert = _invert;
			
			activate = !Game.checkPersistence(tag);
		}
		
		override public function update():void
		{
			super.update();
			hitUpdate();
		}
		
		override public function render():void
		{
			y = startY - sprLightPole.originY + 2 * Math.sin(2 * Math.PI * (Game.time % Game.timePerFrame)/Game.timePerFrame);
			var p:Player = FP.world.nearestToEntity("Player", this) as Player;
			if (myLight && p)
			{
				myLight.x = x;
				myLight.y = y;
			}
			super.render();
			if (hitsTimer <= 0 && activate)
			{
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				super.render();
				Draw.resetTarget();
			}
		}
		
		public function hit():void
		{
			if (hitsTimer <= 0)// && tSet == -1) //Can only hit the light if it's not wired to a button.
			{
				activate = !activate;
				hitsTimer = hitsTimerMax;
			}
		}
		
		public function hitUpdate():void
		{
			if (hitsTimer > 0)
			{
				hitsTimer--;
			}
		}
		
		override public function set activate(a:Boolean):void
		{
			_active = a;
			Game.setPersistence(tag, !activate);
			if (myLight)
			{
				var _a:Boolean = _active;
				if (invert)
				{
					_a = !_a;
				}
				if (_a)
				{
					myLight.color = color;
					myLight.alpha = lightAlpha;
					myLight.darkLight = false;
				}
				else
				{
					myLight.color = 0x000000;
					myLight.alpha = 0.8;
					myLight.darkLight = true;
				}
			}
		}
		
	}

}