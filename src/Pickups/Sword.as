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
	public class Sword extends Pickup
	{
		[Embed(source = "../../assets/graphics/Sword.png")] private var imgSword:Class;
		private var sprSword:Spritemap = new Spritemap(imgSword, 16, 16);
		
		private var tag:int;
		private var doActions:Boolean = true;
		
		public function Sword(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprSword, null, false);
			sprSword.centerOO();
			setHitbox(8, 8, 4, 4);
			
			tag = _tag;
			
			special = true;
			text = "You got the sword!~Double tap to dash and swing.";
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
				Player.hasSword = true;
				Game.setPersistence(tag, false);
				FP.world.add(new Help(3));
			}
		}
		override public function update():void
		{
			super.update();
		}
		override public function render():void
		{
			sprSword.frame = Game.worldFrame(3);
			super.render();
		}
		
	}

}