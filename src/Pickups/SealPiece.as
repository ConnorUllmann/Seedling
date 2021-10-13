package Pickups
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class SealPiece extends Pickup
	{
		[Embed(source = "../../assets/graphics/Seal.png")] private var imgSeal:Class;
		private var sprSeal:Spritemap = new Spritemap(imgSeal, 4, 4);
		
		private var index:int = -1;
		
		public function SealPiece(_x:int, _y:int, _v:Point=null)
		{
			super(_x, _y, sprSeal, _v);
			sprSeal.centerOO();
			type = "Seal";
			setHitbox(4, 4, 2, 2);
			
			special = true;
			text = "";
			mySound = Music.sndOSealPiece;
			
			//Doesn't work for some reason
			Music.bkgdVolumeMaxExtern = 0; // Shut off background sound. Restored by SealController
			Music.fadeVolumeMaxExtern = 0; // Shut off the fade-in sound.  Restored by SealController
		}
		
		override public function render():void
		{
			sprSeal.frame = Game.worldFrame(sprSeal.frameCount);
			super.render();
		}
		
		
		override public function removed():void
		{
			FP.world.add(new SealController());
			/*while (index < 0 || !SealController.getSealPart(index))
			{
				index = Math.floor(Math.random() * SealController.SEALS);
			}*/
			super.removed();
		}
		
	}

}