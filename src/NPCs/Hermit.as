package NPCs 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class Hermit extends NPC
	{
		[Embed(source = "../../assets/graphics/NPCs/Hermit.png")] private var imgHermit:Class;
		private var sprHermit:Spritemap = new Spritemap(imgHermit, 10, 12);
		[Embed(source = "../../assets/graphics/NPCs/HermitPic.png")] private var imgHermitPic:Class;
		private var sprHermitPic:Image = new Image(imgHermitPic);
		
		private const standAnimFrames:Array = new Array(0, 2);
		
		public function Hermit(_x:int, _y:int, _tag:int=-1, _text:String="", _talkingSpeed:int=10) 
		{
			super(_x, _y, sprHermit, _tag, _text, _talkingSpeed);
			sprHermit.add("talk", [1, 2, 3, 0, 0], 15);
			myPic = sprHermitPic;
		}
		
		override public function render():void
		{
			if (talking)
			{
				sprHermit.play("talk");
			}
			else
			{
				sprHermit.frame = standAnimFrames[Game.worldFrame(standAnimFrames.length)];
			}
			super.render();
		}
		
	}

}