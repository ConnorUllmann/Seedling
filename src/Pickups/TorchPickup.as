package Pickups
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class TorchPickup extends Pickup
	{
		[Embed(source = "../../assets/graphics/TorchPickup.png")] private var imgTorchPickup:Class;
		private var sprTorchPickup:Spritemap = new Spritemap(imgTorchPickup, 12, 12);
		
		private var tag:int;
		private var doActions:Boolean = true;
		
		public function TorchPickup(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprTorchPickup, null, false);
			sprTorchPickup.centerOO();
			setHitbox(8, 8, 4, 4);
			
			tag = _tag;
			
			special = true;
			text = "You got the light!~It lights your path with color.";
			
			layer = Tile.LAYER;
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
				Main.unlockMedal(Main.badges[3]);
				Player.hasTorch = true;
				Game.setPersistence(tag, false);
			}
		}
		override public function update():void
		{
			super.update();
		}
		
		override public function render():void
		{
			super.render();
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
		
		override public function pick_up():void
		{
			sprTorchPickup.frame = 1;
			super.pick_up();
		}
		
	}

}