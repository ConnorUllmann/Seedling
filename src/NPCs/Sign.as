package NPCs 
{
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Time
	 */
	public class Sign extends NPC
	{
		[Embed(source = "../../assets/graphics/Sign.png")] private var imgSign:Class;
		private var sprSign:Spritemap = new Spritemap(imgSign, 16, 16);
		
		public function Sign(_x:int, _y:int, _tag:int=-1, _text:String="", _talkingSpeed:int=10) 
		{
			super(_x, _y, sprSign, _tag, _text, _talkingSpeed);
			facePlayer = false;
		}
		
	}

}