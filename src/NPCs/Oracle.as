package NPCs 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class Oracle extends NPC
	{
		[Embed(source = "../../assets/graphics/NPCs/Oracle.png")] private var imgOracle:Class;
		private var sprOracle:Spritemap = new Spritemap(imgOracle, 16, 24, animEnd);
		[Embed(source = "../../assets/graphics/NPCs/OraclePic.png")] private var imgOraclePic:Class;
		private var sprOraclePic:Image = new Image(imgOraclePic);
		
		private const wakenDistance:int = 48;
		
		private var text:String;
		private var text1:String;
		
		private const text2:String = "You have brought the seed. Good work.~Your purpose is fulfilled, but now you are not needed.~Goodbye.";
		
		public function Oracle(_x:int, _y:int, _tag:int=-1, _text:String="", _text1:String = "", _talkingSpeed:int=10) 
		{
			super(_x, _y, sprOracle, _tag, Game.cutscene[1] ? text2 : (Game.checkPersistence(_tag) ? _text : _text1), _talkingSpeed);
			if (Game.cutscene[1])
			{
				text = text1 = text2;
			}
			else
			{
				text = _text;
				text1 = _text1;
			}
			
			sprOracle.y = -16;
			sprOracle.originY = -sprOracle.y;
			setHitbox(16, 16, 8, 8);
			
			sprOracle.add("waken", [0, 1, 2], 5);
			sprOracle.add("fallAsleep", [2, 1, 0], 5);
			sprOracle.add("sleep", [0]);
			sprOracle.add("awake", [3]);
			sprOracle.add("talk", [3, 4, 5], 5);
			
			sprOracle.play("sleep");
			
			facePlayer = false;
			charToTalkMargin = 10;
			
			myPic = sprOraclePic;
		}
		
		override public function render():void
		{
			if (talking)
			{
				sprOracle.play("talk");
			}
			else
			{
				var player:Player = FP.world.nearestToPoint("Player", x, y) as Player;
				if (player)
				{
					var d:int = FP.distance(x, y, player.x, player.y);
					if (d <= wakenDistance)
					{
						if (sprOracle.currentAnim != "awake")
						{
							sprOracle.play("waken");
						}
					}
					else
					{
						if (sprOracle.currentAnim != "sleep")
						{
							sprOracle.play("fallAsleep");
						}
					}
				}
			}
			super.render();
		}
		
		override public function check():void
		{
			
		}
		
		override public function talking_extras():void
		{
		}
		
		override public function doneTalking():void
		{
			super.doneTalking();
			if (Game.cutscene[1])
			{
				var p:Player = FP.world.nearestToPoint("Player", x, y) as Player;
				if (!p || p.graphic != p.sprShrumDark)
				{
					exitToMenu();
				}
				else
				{
					p.sprShrumDark.play("die");
				}
			}
			else if (Game.checkPersistence(tag))
			{
				Game.setPersistence(tag, false);
				Main.unlockMedal(Main.badges[0]);
			}
			prepNewText(text1);
		}
		
		private function exitToMenu():void
		{
			Game.menu = true;
			FP.world = new Game((FP.world as Game).level, Game.currentPlayerPosition.x, Game.currentPlayerPosition.y);
		}
		
		public function animEnd():void
		{
			switch(sprOracle.currentAnim)
			{
				case "waken": sprOracle.play("awake"); break;
				case "fallAsleep": sprOracle.play("sleep"); break;
				default:
			}
		}
		
	}

}