package NPCs 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class Karlore extends NPC
	{
		[Embed(source = "../../assets/graphics/NPCs/Karlore.png")] private var imgKarlore:Class;
		private var sprKarlore:Spritemap = new Spritemap(imgKarlore, 20, 20);
		[Embed(source = "../../assets/graphics/NPCs/KarlorePic.png")] private var imgKarlorePic:Class;
		private var sprKarlorePic:Image = new Image(imgKarlorePic);
		
		public function Karlore(_x:int, _y:int, _tag:int=-1, _text:String="", _talkingSpeed:int=10) 
		{
			super(_x, _y, sprKarlore, _tag, _text, _talkingSpeed);
			sprKarlore.add("talk", [0, 1], 5);
			myPic = sprKarlorePic;
			
			setHitbox(16, 16, 8, 8);
		}
		
		override public function added():void
		{
			super.added();
			if (Player.hasFire)
			{
				FP.world.remove(this);
			}
		}
		
		override public function doneTalking():void
		{
			super.doneTalking();
			Main.unlockMedal(Main.badges[1]);
		}
		
		override public function render():void
		{
			if (talking)
			{
				sprKarlore.play("talk");
			}
			else
			{
				sprKarlore.frame = Game.worldFrame(2);
			}
			super.render();
		}
		
	}

}