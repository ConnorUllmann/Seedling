package NPCs 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class AdnanCharacter extends NPC
	{
		[Embed(source = "../../assets/graphics/NPCs/AdnanCharacter.png")] private var imgAdnanCharacter:Class;
		private var sprAdnanCharacter:Spritemap = new Spritemap(imgAdnanCharacter, 8, 8);
		[Embed(source = "../../assets/graphics/NPCs/AdnanCharacterPic.png")] private var imgAdnanCharacterPic:Class;
		private var sprAdnanCharacterPic:Image = new Image(imgAdnanCharacterPic);
		
		public function AdnanCharacter(_x:int, _y:int, _tag:int=-1, _text:String="", _talkingSpeed:int=10) 
		{
			super(_x, _y, sprAdnanCharacter, _tag, _text, _talkingSpeed);
			sprAdnanCharacter.add("talk", [0, 1, 0, 2], 5);
			myPic = sprAdnanCharacterPic;
		}
		
		override public function render():void
		{
			if (talking)
			{
				sprAdnanCharacter.play("talk");
			}
			else
			{
				sprAdnanCharacter.frame = Game.worldFrame(2);
			}
			super.render();
		}
		
	}

}