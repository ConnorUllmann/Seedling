package NPCs 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class Yeti extends NPC
	{
		[Embed(source = "../../assets/graphics/NPCs/Yeti.png")] private var imgYeti:Class;
		private var sprYeti:Spritemap = new Spritemap(imgYeti, 10, 12);
		[Embed(source = "../../assets/graphics/NPCs/YetiPic.png")] private var imgYetiPic:Class;
		private var sprYetiPic:Image = new Image(imgYetiPic);
		
		private var createdPortal:Boolean = false;
		
		public function Yeti(_x:int, _y:int, _tag:int=-1, _text:String="", _talkingSpeed:int=10) 
		{
			super(_x, _y, sprYeti, _tag, _text, _talkingSpeed);
			sprYeti.add("talk", [0, 1], 5);
			
			myPic = sprYetiPic;
		}
		
		override public function render():void
		{
			if (talking)
			{
				sprYeti.play("talk");
			}
			else
			{
				sprYeti.frame = Game.worldFrame(2);
			}
			super.render();
		}
		
		override public function doneTalking():void
		{
			super.doneTalking();
			if (!createdPortal)
			{
				createdPortal = true;
				Game.setPersistence(tag, false);
				//In order for this to work, the portal in DeadBoss.oel must have tag "1"
				Game.setPersistence(1, false);
			}
		}
		
	}

}