package Puzzlements
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class Button extends Activators
	{
		[Embed(source = "../../assets/graphics/Button.png")] private var imgButton:Class;
		private var sprButton:Spritemap = new Spritemap(imgButton, 8, 8);
		
		private var hitables:Object = ["Player", "Enemy", "Solid"]; //Things that push down the button
		
		public function Button(_x:int, _y:int, _t:int) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprButton, _t);
			sprButton.centerOO();
			setHitbox(8, 6, 4, 3);
			type = "Button";
			layer = -y;
		}
		
		override public function update():void
		{
			var v:Vector.<Entity> = new Vector.<Entity>();
			collideTypesInto(hitables, x, y, v);
			var tempCheck:Boolean = false;
			for each (var c:Entity in v)
			{
				if (c && !(c is Cover))
				{
					tempCheck = true;
				}
			}
			activate = tempCheck;
		}
		
		override public function set activate(a:Boolean):void
		{
			if(_active != a) Music.playSoundDistPlayer(x, y, "Switch");
			_active = a;
			activateAll(this, t, activate);
			sprButton.frame = int(_active);
		}
		
		public static function activateAll(_exclude:Activators, _t:int, _activate:Boolean):void
		{
			var v:Vector.<Activators> = new Vector.<Activators>();
			FP.world.getClass(Activators, v);
			for (var i:int = 0; i < v.length; i++)
			{
				if (v[i] != _exclude && v[i].t == _t)
				{
					v[i].activate = _activate;
				}
			}
		}
		
	}

}