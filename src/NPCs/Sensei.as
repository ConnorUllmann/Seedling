package NPCs 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class Sensei extends NPC
	{
		[Embed(source = "../../assets/graphics/NPCs/Sensei.png")] private var imgSensei:Class;
		private var sprSensei:Spritemap = new Spritemap(imgSensei, 8, 8);
		[Embed(source = "../../assets/graphics/NPCs/SenseiPic.png")] private var imgSenseiPic:Class;
		private var sprSenseiPic:Image = new Image(imgSenseiPic);
		
		private const standAnimFrames:Array = new Array(0, 1);
		
		public function Sensei(_x:int, _y:int, _tag:int=-1, _text:String="", _talkingSpeed:int=10) 
		{
			super(_x, _y, sprSensei, _tag, _text, _talkingSpeed);
			sprSensei.add("talk", [1, 2, 1, 0, 0], 15);
			myPic = sprSenseiPic;
		}
		
		override public function render():void
		{
			if (talking)
			{
				sprSensei.play("talk");
			}
			else
			{
				sprSensei.frame = standAnimFrames[Game.worldFrame(standAnimFrames.length)];
			}
			super.render();
		}
		
	}

}