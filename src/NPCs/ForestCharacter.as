package NPCs 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class ForestCharacter extends NPC
	{
		[Embed(source = "../../assets/graphics/NPCs/ForestCharacter.png")] private var imgForestChar:Class;
		private var sprForestChar:Spritemap = new Spritemap(imgForestChar, 8, 9);
		[Embed(source = "../../assets/graphics/NPCs/ForestCharacterPic.png")] private var imgForestCharPic:Class;
		private var sprForestCharPic:Image = new Image(imgForestCharPic);
		
		public function ForestCharacter(_x:int, _y:int, _tag:int=-1, _text:String="", _talkingSpeed:int=10) 
		{
			super(_x, _y, sprForestChar, _tag, _text, _talkingSpeed);
			sprForestChar.add("talk", [0, 1], 5);
			myPic = sprForestCharPic;
		}
		
		override public function render():void
		{
			if (talking)
			{
				sprForestChar.play("talk");
			}
			else
			{
				sprForestChar.frame = Game.worldFrame(2);
			}
			super.render();
		}
		
	}

}