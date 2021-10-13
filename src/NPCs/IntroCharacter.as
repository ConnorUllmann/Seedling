package NPCs 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class IntroCharacter extends NPC
	{
		[Embed(source = "../../assets/graphics/NPCs/IntroCharacter.png")] private var imgIntroChar:Class;
		private var sprIntroChar:Spritemap = new Spritemap(imgIntroChar, 8, 8);
		[Embed(source = "../../assets/graphics/NPCs/IntroCharacterPic.png")] private var imgIntroCharPic:Class;
		private var sprIntroCharPic:Image = new Image(imgIntroCharPic);
		
		public function IntroCharacter(_x:int, _y:int, _tag:int=-1, _text:String="", _talkingSpeed:int=10) 
		{
			super(_x, _y, sprIntroChar, _tag, _text, _talkingSpeed);
			sprIntroChar.add("talk", [0, 1, 0, 2], 5);
			
			myPic = sprIntroCharPic;
		}
		
		override public function render():void
		{
			if (talking)
			{
				sprIntroChar.play("talk");
			}
			else
			{
				sprIntroChar.frame = Game.worldFrame(2);
			}
			super.render();
		}
		
	}

}