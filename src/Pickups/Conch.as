package Pickups
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class Conch extends Pickup
	{
		[Embed(source = "../../assets/graphics/Conch.png")] private var imgConch:Class;
		private var sprConch:Spritemap = new Spritemap(imgConch, 8, 8);
		
		private var tag:int;
		private var doActions:Boolean = true;
		
		public function Conch(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprConch, null, false);
			sprConch.centerOO();
			setHitbox(8, 8, 4, 4);
			
			tag = _tag;
			
			special = true;
			text = "You got the Conch!~Now you can swim in water!";
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
				Player.canSwim = true;
				Game.setPersistence(tag, false);
			}
		}
		override public function update():void
		{
			super.update();
		}
		override public function render():void
		{
			sprConch.frame = Game.worldFrame(3);
			super.render();
		}
		
	}

}