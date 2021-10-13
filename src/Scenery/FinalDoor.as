package Scenery 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class FinalDoor extends Entity
	{
		[Embed(source = "../../assets/graphics/FinalDoor.png")] private var imgFinalDoor:Class;
		private var sprFinalDoor:Spritemap = new Spritemap(imgFinalDoor, 32, 32, animEnd);
		
		private const seeDistance:int = 32;
		private var seenSeal:Boolean = false;
		public var mySealController:SealController;
		private var tag:int;
		
		public function FinalDoor(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w, _y + Tile.h, sprFinalDoor);
			sprFinalDoor.centerOO();
			setHitbox(32, 32, 16, 16);
			type = "Solid";
			layer = -(y - originY + height);
			tag = _tag;
			
			sprFinalDoor.add("open", [1, 1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25], 15);
		}
		
		override public function check():void
		{
			super.check();
			if (tag >= 0 && !Game.checkPersistence(tag))
			{
				FP.world.remove(this);
			}
		}
		
		override public function removed():void
		{
			super.removed();
			Game.setPersistence(tag, false);
		}
		
		override public function update():void
		{
			var talkedToWatcher:Boolean = !Game.checkPersistence(0, 114); //0 is the tag for the Watcher's text, while 114 is the room that it refers to.
			var p:Player = FP.world.nearestToEntity("Player", this) as Player;
			if (p)
			{
				if (FP.distance(x, y, p.x, p.y) <= seeDistance)
				{
					if (!seenSeal)
					{
						seenSeal = true;
						FP.world.add(mySealController = new SealController(false, this, talkedToWatcher ? "Your path to redemption lies here" : "Face the Watcher and return"));
					}
					else if (!mySealController && SealController.hasAllSealParts() && talkedToWatcher)
					{
						sprFinalDoor.play("open");
					}
				}
				else
				{
					seenSeal = false;
				}
			}
		}
		
		override public function render():void
		{
			super.render();
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
		
		public function animEnd():void
		{
			switch(sprFinalDoor.currentAnim)
			{
				case "open":
					FP.world.remove(this);
					break;
				default:
			}
		}
		
	}

}