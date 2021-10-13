package NPCs
{
	import Enemies.LightBossController;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import Pickups.BossKey;
	import Pickups.Pickup;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class NPC extends Mobile
	{
		[Embed(source = "../../assets/graphics/NPCs/Talk.png")] private var imgTalk:Class;
		private var sprTalk:Spritemap = new Spritemap(imgTalk, 10, 14);
		
		public var talked:Boolean = false; //If the player has already talked to him since he came in range
		private var _talking:Boolean = false;
		public var tag:int;
		
		public var lineLength:int;
		public var talkRange:int = 24;
		public var inRange:Boolean = false;
		public var myPic:Image;
		public var myText:Object = [];
		public var myCurrentText:int = 0;
		
		public var facePlayer:Boolean = true;
		public var charToTalkMargin:int = 2; //The distance from the character image to the prompt
		
		public var talkingSpeed:int; //Matches up with Game.framesPerCharacter; sets the speed of each letter entering the screen.
									 //Measured in frames/character.
									 
		public var temporary:Boolean = false;
		public var showTalk:Boolean = true;
		public var keyNeeded:Boolean = true;
		public var parent:Entity;
		
		public var align:String = "LEFT";
		
		public function NPC(_x:int, _y:int, _g:Image, _tag:int=-1, _text:String="", _talkingSpeed:int=0, _lineLength:int=28) 
		{
			super(_x + Tile.w / 2, _y + Tile.h / 2, _g);
			lineLength = _lineLength;
			if (_talkingSpeed < 0)
			{
				_talkingSpeed = Game.framesPerCharacterDefault;
			}
			if (graphic)
			{
				(graphic as Image).centerOO();
				setHitbox(_g.width, _g.height, _g.width / 2, _g.height / 2);
			}
			type = "Solid";
			
			sprTalk.centerOO();
			sprTalk.y = -sprTalk.height;
			sprTalk.originY = sprTalk.y;
			
			talkingSpeed = _talkingSpeed;
			tag = _tag;
			
			prepNewText(_text);
		}
		
		override public function removed():void
		{
			super.removed();
			if (parent)
			{
				if (parent is Pickup)
				{
					(parent as Pickup).myText = null;
				}
				else if (parent is LightBossController)
				{
					(parent as LightBossController).myText = null;
				}
			}
		}
		
		//Make sure you have your picture set before using!
		public function prepNewText(_text:String):void
		{
			myText = [];
			addText(_text);
			lineWrap();
		}
		
		public function setTemp(_parent:Entity=null, _temp:Boolean=true, _talking:Boolean=true, _showTalk:Boolean=false):void
		{
			temporary = _temp;
			showTalk = _showTalk;
			talking = _talking;
			parent = _parent;
			collidable = false;
		}
		
		public function addText(_text:String):void
		{
			var _indEnd:int = _text.indexOf("~", 0);
			if (_indEnd == -1)
			{
				myText.push(_text.substring(0, _text.length));
				return;
			}
			else
			{
				myText.push(_text.substring(0, _indEnd));
				addText(_text.substring(_indEnd+1, _text.length));
			}
		}
		
		override public function check():void
		{
			super.check();
			if (!Game.menu && tag >= 0 && !Game.checkPersistence(tag))
			{
				FP.world.remove(this);
			}
		}
		
		override public function update():void
		{
			super.update();
			talk();
		}
		
		override public function render():void
		{
			super.render();
			if (inRange && !talked && showTalk && myText[0].length > 0)
			{
				const talkBobsPerLoop:Number = 1.25; //The number of times sprTalk bobs up and down per animation loop
				sprTalk.frame = Game.worldFrame(sprTalk.frameCount, 1 / talkBobsPerLoop);
				sprTalk.render(new Point(x, y - originY - charToTalkMargin), FP.camera);
			}
		}
		
		public function lineWrap():void
		{
			for (var i:int = 0; i < myText.length; i++)
			{
				myText[i] = endlineText(myText[i], lineLength);
			}
		}
		public static function endlineText(s0:String, lineL:int):String
		{
			var s:String = s0.substr(0, s0.length); //So that I'm not going by reference
			
			var pos:int = lineL-1;
			while (pos < s.length)
			{
				var pchar:String = s.substr(pos, 1);
				while (validChar(pchar))
				{
					pos--;
					if (pos % lineL <= 0)
					{
						pos += lineL;
						break;
					}
					pchar = s.substr(pos, 1);
				}
				if (pos < s.length)
				{
					var start:String = s.substring(0, pos);
					var end:String = s.substring(pos + int(pchar == " "), s.length);
					s = start + "\n" + end;
				}
				pos += lineL;
			}
			return s;
		}
		public static function validChar(pchar:String):Boolean
		{
			return pchar != " " && pchar != "-" && pchar != "/";
		}
		
		public function talk():void
		{
			var p:Player = FP.world.nearestToEntity("Player", this) as Player;
			if (p && myText[0].length > 0)
			{
				inRange = FP.distance(x, y, p.x, p.y) <= talkRange;
				var hitKey:Boolean = Input.released(p.keys[6]);
				
				if (talking)
				{
					Game.freezeObjects = true;
					if (hitKey)
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
							if (temporary)
							{
								FP.world.remove(this);
							}
							return;
						}
						Game.talkingText = myText[myCurrentText];
					}
				}
				if(inRange)
				{
					if (facePlayer && graphic)
					{
						(graphic as Image).scaleX = int(x < p.x) * 2 - 1;
					}
					if ((hitKey || !keyNeeded) && !Game.talking && !Game.inventory.open)
					{
						startTalking();
					}
				}
				else
				{
					talked = false;
					if (talking)
					{
						talking = false;
					}
				}
			}
		}
		
		public function startTalking():void
		{
			if (!talked)
			{	
				talking = true;
				talked = true;
			}
		}
		
		public function set talking(_t:Boolean):void
		{
			_talking = _t;
			if (!talking)
			{
				Game.freezeObjects = false;
				Game.talking = false;
				Game.talkingText = "";
				Game.talkingPic = null;
				Game.framesPerCharacter = Game.framesPerCharacterDefault;
				Game.ALIGN = "LEFT";
				myCurrentText = 0;
				doneTalking();
			}
			else
			{
				Game.talking = true;
				Game.talkingText = myText[myCurrentText];
				Game.talkingPic = myPic;
				Game.framesPerCharacter = talkingSpeed;
				Game.ALIGN = align;
			}
			talking_extras();
		}
		
		public function doneTalking():void
		{
			
		}
		
		public function talking_extras():void
		{
		}
		
		public function get talking():Boolean
		{
			return _talking;
		}
		
	}

}