package Pickups
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import NPCs.Help;
	import Scenery.Tile;
	import Scenery.Moonrock;
	/**
	 * ...
	 * @author Time
	 */
	public class DarkSword extends Pickup
	{
		[Embed(source = "../../assets/graphics/SwordDark.png")] private var imgDarkSword:Class;
		private var sprDarkSword:Spritemap = new Spritemap(imgDarkSword, 16, 16);
		
		private var tag:int;
		private var doActions:Boolean = true;
		
		public function DarkSword(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprDarkSword, null, false);
			sprDarkSword.centerOO();
			setHitbox(8, 8, 4, 4);
			
			tag = _tag;
			
			special = true;
			text = "You got the dark sword!~It does more damage.";
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
				Player.hasDarkSword = true;
				if (Game.checkPersistence(tag))
				{
					Game.setPersistence(tag, false);
					Main.unlockMedal(Main.badges[12]);
				}
			}
		}
		override public function update():void
		{
			super.update();
		}
		override public function render():void
		{
			sprDarkSword.frame = Game.worldFrame(3);
			super.render();
		}
		
	}

}