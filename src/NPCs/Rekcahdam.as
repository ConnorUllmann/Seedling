package NPCs 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class Rekcahdam extends NPC
	{
		[Embed(source = "../../assets/graphics/NPCs/Rekcahdam.png")] private var imgRekcahdam:Class;
		private var sprRekcahdam:Spritemap = new Spritemap(imgRekcahdam, 9, 10);
		[Embed(source = "../../assets/graphics/NPCs/RekcahdamPic.png")] private var imgRekcahdamPic:Class;
		private var sprRekcahdamPic:Image = new Image(imgRekcahdamPic);
		
		public function Rekcahdam(_x:int, _y:int, _tag:int=-1, _text:String="", _talkingSpeed:int=10) 
		{
			super(_x, _y, sprRekcahdam, _tag, _text, _talkingSpeed);
			sprRekcahdam.add("talk", [0, 1, 0], 5);
			
			myPic = sprRekcahdamPic;
		}
		
		override public function render():void
		{
			if (talking)
			{
				sprRekcahdam.play("talk");
			}
			else
			{
				sprRekcahdam.frame = Game.worldFrame(2);
			}
			super.render();
		}
		
	}

}