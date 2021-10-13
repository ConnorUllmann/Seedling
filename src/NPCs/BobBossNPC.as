package NPCs 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Time
	 */
	public class BobBossNPC extends NPC
	{
		[Embed(source = "../../assets/graphics/NPCs/BobBoss1Pic.png")] private var imgBobBoss1Pic:Class;
		[Embed(source = "../../assets/graphics/NPCs/BobBoss2Pic.png")] private var imgBobBoss2Pic:Class;
		[Embed(source = "../../assets/graphics/NPCs/BobBoss3Pic.png")] private var imgBobBoss3Pic:Class;
		private const pics:Array = new Array(imgBobBoss1Pic, imgBobBoss2Pic, imgBobBoss3Pic);
		
		public function BobBossNPC(_x:int, _y:int, _st:int = 0, _text:String = "", _talkingSpeed:int = 10)  
		{
			super(_x, _y, null, -1, _text, _talkingSpeed);
			myPic = new Image(pics[_st]);
		}
		
		override public function talk():void
		{
			var p:Player = FP.world.nearestToEntity("Player", this) as Player;
			if (p)
			{
				if (talking)
				{
					Game.freezeObjects = true;
				}
				
				var hitKey:Boolean = Input.released(p.keys[6]);
				if (talking && hitKey)
				{
					Music.playSound("Text", 1, 0.3);
					if (Game.currentCharacter >= myText[myCurrentText].length)
					{
						myCurrentText++;
					}
					else
					{
						Game.currentCharacter = myText[myCurrentText].length - 1;
					}
					if (myCurrentText >= myText.length)
					{
						talking = false;
						FP.world.remove(this);
						return;
					}
					Game.talkingText = myText[myCurrentText];
				}
				
				inRange = true;
				if (!Game.talking)
				{
					if (!talked)
					{	
						talking = true;
						talked = true;
					}
				}
			}
		}
		
	}

}