package Pickups
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class Feather extends Pickup
	{
		[Embed(source = "../../assets/graphics/Feather.png")] private var imgFeather:Class;
		private var sprFeather:Spritemap = new Spritemap(imgFeather, 12, 12);
		
		private var tag:int;
		private var doActions:Boolean = true;
		
		public function Feather(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprFeather, null, false);
			sprFeather.centerOO();
			setHitbox(8, 8, 4, 4);
			
			tag = _tag;
			
			special = true;
			text = "You got the Penguin's Feather!~You can now swim up waterfalls.";
		}
		
		override public function check():void
		{
			super.check();
			if (tag >= 0 && !Game.checkPersistence(tag))
			{
				doActions = false;
				FP.world.remove(this);
			}
		}
		
		override public function removed():void
		{
			if (doActions)
			{
				Player.hasFeather = true;
				Game.setPersistence(tag, false);
			}
		}
		override public function update():void
		{
			super.update();
		}
		override public function render():void
		{
			sprFeather.frame = Game.worldFrame(8);
			super.render();
		}
		
	}

}