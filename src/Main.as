package 
{
	import com.newgrounds.*;
	import com.newgrounds.components.MedalPopup;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Time
	 */
	public class Main extends Engine 
	{
		public static const SAVE_NAME:String = "shrumsave";
		public static var SAVE_FILE:SharedObject;
		public static var tempPersistence:Array;
		public static const badges:Object = ["The Quest", "Sardol", "Mower", "Lighting the Path",
											 "Health", "Fall of Time", "Fall of the Totem", "Fall of the Tentacled Beast",
											 "Fall of the Shieldspire", "Fall of the Owl", "Fall of the Lights", "Fall of the King of Fire",
											 "Enchantments", "Bloody", "Bloodless"];
		
		public static const FPS:int = 60;
		
		public static var medals:Vector.<MedalPopup> = new Vector.<MedalPopup>();
		
		private static var READY_TO_SUBMIT_BADGES:Boolean = false;
		private static var SUBMITTED_BADGES:Boolean = false;
		
		public function Main():void 
		{
			super(160, 160, FPS);
			begin();
		}
		
		public static function begin():void
		{
			//if (Preloader.CONNORULLMANN || Preloader.NEWGROUNDS)
			//{
			SAVE_FILE = SharedObject.getLocal(SAVE_NAME);
			startSave();
			printItems();
			
			Music.begin();
			
			FP.world = new Splash();// Game(level, playerPositionX, playerPositionY);// Splash();
			
			FP.screen.color = 0x000000;
			FP.screen.scale = 3;
			
			var popup:MedalPopup = new MedalPopup();
			FP.engine.addChild(popup);
			//}
		}
		
		override public function update():void
		{
			super.update();
			Music.update();
			
			if (READY_TO_SUBMIT_BADGES && QuickKong.LOADED && !SUBMITTED_BADGES)
			{
				for (var i:int = 0; i < Main.badges.length; i++)
				{
					if (Main.hasBadge(Main.badges[i]))
					{
						Main.unlockMedal(Main.badges[i]);
					}
					else
					{
						QuickKong.stats.submit(Main.badges[i], 0);
					}
				}
				SUBMITTED_BADGES = true;
			}
		}
		
		public static function printItems():void
		{
			var i:int;
			trace("-------------------------");
			trace("P-Pos:    " + playerPositionX + ", " + playerPositionY);
			trace("Level:    " + level);
			trace("Item <X>: " + primary);
			trace("Item <C>: " + secondary);
			trace("Grass cut:" + grassCut);
			
			/*trace("Sword:    " + hasSword);
			trace("G-Sword:  " + hasGhostSword);
			trace("Shield:   " + hasShield);
			trace("Fire:     " + hasFire);
			trace("Wand:     " + hasWand);
			trace("Fire Wand:" + hasFireWand);
			trace("Swim:     " + canSwim);
			trace("Spear:    " + hasSpear);
			trace("D-Shield: " + hasDarkShield);
			trace("D-Suit:   " + hasDarkSuit);
			trace("D-Sword:  " + hasDarkSword);
			trace("Feather:  " + hasFeather);
			trace("Torch:    " + hasTorch);
			trace("Beam:     " + beam);
			trace("Rock Set: " + rockSet);
			trace("Hits Max: " + hitsMax);
			trace("First Use:" + firstUse); //Inventory first used
			trace("Extended: " + extended); //Inventory all the way out
			
			trace("Totem Parts:");
			for (i = 0; i < SAVE_FILE.data.hasTotemPart.length; i++)
			{
				trace(i + ": " + hasTotemPart(i));
			}
			trace("Keys:");
			for (i = 0; i < SAVE_FILE.data.hasKey.length; i++)
			{
				trace(i + ": " + hasKey(i));
			}
			for (i = 0; i < SAVE_FILE.data.hasSealPart.length; i++)
			{
				trace(i + ": " + hasSealPart(i));
			}
			*/
			var s:String = "";
			for (i = 0; i < Game.tagsPerLevel; i++)
			{
				s += String(int(levelPersistence(Math.max(level, 0), i)));
			}
			trace(level + ": " + s);
		}
		
		public static function get hasSword():Boolean { return SAVE_FILE.data.hasSword; }
		public static function get hasGhostSword():Boolean { return SAVE_FILE.data.hasGhostSword; }
		public static function get hasShield():Boolean {return SAVE_FILE.data.hasShield; }
		public static function get hasFire():Boolean {return SAVE_FILE.data.hasFire; }
		public static function get hasWand():Boolean { return SAVE_FILE.data.hasWand; }
		public static function get hasFireWand():Boolean {return SAVE_FILE.data.hasFireWand; }
		public static function get canSwim():Boolean {return SAVE_FILE.data.canSwim; }
		public static function get hasSpear():Boolean {return SAVE_FILE.data.hasSpear; }
		public static function get hasDarkShield():Boolean {return SAVE_FILE.data.hasDarkShield; }
		public static function get hasDarkSuit():Boolean {return SAVE_FILE.data.hasDarkSuit; }
		public static function get hasDarkSword():Boolean {return SAVE_FILE.data.hasDarkSword; }
		public static function get hasFeather():Boolean { return SAVE_FILE.data.hasFeather; }
		public static function get hasTorch():Boolean { return SAVE_FILE.data.hasTorch; }
		public static function get beam():Boolean { return SAVE_FILE.data.beam; }
		public static function get rockSet():Boolean { return SAVE_FILE.data.rockSet; }
		public static function get hitsMax():int { if (!SAVE_FILE.data.hitsMax) return Player.hitsMaxDef; return SAVE_FILE.data.hitsMax; }
		public static function get firstUse():Boolean { return SAVE_FILE.data.firstUse; }
		public static function get extended():Boolean { return SAVE_FILE.data.extended; }
		public static function get time():Number { if (!SAVE_FILE.data.time) return Game.dayLength / 2; return SAVE_FILE.data.time; }
		public static function get primary():int { if (!SAVE_FILE.data.primary) return 0; return SAVE_FILE.data.primary; }
		public static function get secondary():int { if (!SAVE_FILE.data.secondary) return 0; return SAVE_FILE.data.secondary; }
		public static function get grassCut():int { if (!SAVE_FILE.data.grassCut) return 0; return SAVE_FILE.data.grassCut; }
		public static function hasKey(i:int):Boolean {return SAVE_FILE.data.hasKey[i]; }
		public static function hasTotemPart(i:int):Boolean { return SAVE_FILE.data.hasTotemPart[i]; }
		public static function hasSealPart(i:int):int { return SAVE_FILE.data.hasSealPart[i]; }
		public static function hasBadge(s:String):Boolean { return SAVE_FILE.data.hasBadge[s]; }
		
		public static function set hasSword(_t:Boolean):void { SAVE_FILE.data.hasSword = _t; }
		public static function set hasGhostSword(_t:Boolean):void { SAVE_FILE.data.hasGhostSword = _t; }
		public static function set hasShield(_t:Boolean):void { SAVE_FILE.data.hasShield = _t; }
		public static function set hasFire(_t:Boolean):void { SAVE_FILE.data.hasFire = _t; }
		public static function set hasWand(_t:Boolean):void { SAVE_FILE.data.hasWand = _t; }
		public static function set hasFireWand(_t:Boolean):void { SAVE_FILE.data.hasFireWand = _t; }
		public static function set canSwim(_t:Boolean):void { SAVE_FILE.data.canSwim = _t; }
		public static function set hasSpear(_t:Boolean):void { SAVE_FILE.data.hasSpear = _t; }
		public static function set hasDarkShield(_t:Boolean):void { SAVE_FILE.data.hasDarkShield = _t; }
		public static function set hasDarkSuit(_t:Boolean):void { SAVE_FILE.data.hasDarkSuit = _t; }
		public static function set hasDarkSword(_t:Boolean):void { SAVE_FILE.data.hasDarkSword = _t; }
		public static function set hasFeather(_t:Boolean):void { SAVE_FILE.data.hasFeather = _t; }
		public static function set hasTorch(_t:Boolean):void { SAVE_FILE.data.hasTorch = _t; }
		public static function set beam(_t:Boolean):void { SAVE_FILE.data.beam = _t; }
		public static function set rockSet(_t:Boolean):void { SAVE_FILE.data.rockSet = _t; }
		public static function set hitsMax(_t:int):void { SAVE_FILE.data.hitsMax = _t; }
		public static function set firstUse(_t:Boolean):void { SAVE_FILE.data.firstUse = _t; }
		public static function set extended(_t:Boolean):void { SAVE_FILE.data.extended = _t; }
		public static function set time(_t:Number):void { SAVE_FILE.data.time = _t; }
		public static function set primary(_t:int):void { SAVE_FILE.data.primary = _t; }
		public static function set secondary(_t:int):void { SAVE_FILE.data.secondary = _t; }
		public static function set grassCut(_t:int):void { SAVE_FILE.data.grassCut = _t; if (SAVE_FILE.data.grassCut >= 10000) unlockMedal(Main.badges[2]); }
		public static function hasKeySet(i:int, _t:Boolean):void { SAVE_FILE.data.hasKey[i] = _t;}
		public static function hasTotemPartSet(i:int, _t:Boolean):void { SAVE_FILE.data.hasTotemPart[i] = _t; }
		public static function hasSealPartSet(i:int, _t:int):void { SAVE_FILE.data.hasSealPart[i] = _t; }
		public static function hasBadgeSet(s:String, _t:Boolean):void { SAVE_FILE.data.hasBadge[s] = _t; }
		
		public static function get playerPositionX():int  { if (!SAVE_FILE.data.playerPositionX) return 0; return SAVE_FILE.data.playerPositionX; }
		public static function get playerPositionY():int  { if (!SAVE_FILE.data.playerPositionY) return 0; return SAVE_FILE.data.playerPositionY; }
		public static function set playerPositionX(i:int):void  { SAVE_FILE.data.playerPositionX = i; }
		public static function set playerPositionY(i:int):void  { SAVE_FILE.data.playerPositionY = i; }
		public static function get level():int  { if (SAVE_FILE.data.level == null) return -1; return SAVE_FILE.data.level; }
		public static function set level(i:int):void  { SAVE_FILE.data.level = i; }
		
		public static function levelPersistence(i:int, j:int):Boolean { return SAVE_FILE.data.levelPersistence[i*Game.tagsPerLevel+j]; }
		public static function levelPersistenceSet(i:int, j:int, _t:Boolean):void { SAVE_FILE.data.levelPersistence[i*Game.tagsPerLevel+j] = _t;}
		
		public static function clearSave():void
		{
			SAVE_FILE.clear();
			Inventory.clearItems();
			begin();
		}
		
		public static function unlockMedal(medal:String):void
		{
			if (Preloader.ARMORGAMES)
				return;
			if (Preloader.KONGREGATE)
			{
				QuickKong.stats.submit(medal, 1);
				hasBadgeSet(medal, true);
				return;
			}
			var m:Medal = API.getMedal(medal);
			if (!m || (m && m.unlocked))
				return;
			m.unlock();
		}
		
		/*
		 * Initializes all of the save values to whatever they're saved to be--if null, then it turns to false.
		 */
		public static function startSave():void
		{
			hasSword = hasSword;
			hasGhostSword = hasGhostSword;
			hasShield = hasShield;
			hasFire = hasFire;
			hasWand = hasWand;
			hasFireWand = hasFireWand;
			canSwim = canSwim;
			hasSpear = hasSpear;
			hasDarkShield = hasDarkShield;
			hasDarkSuit = hasDarkSuit;
			hasDarkSword = hasDarkSword;
			hasFeather = hasFeather;
			hasTorch = hasTorch;
			beam = beam;
			rockSet = rockSet;
			hitsMax = hitsMax;
			firstUse = firstUse;
			extended = extended;
			time = time;
			primary = primary;
			secondary = secondary;
			grassCut = grassCut;
			
			if (!SAVE_FILE.data.hasBadge)
			{
				var _hasBadge:Object = new Object;
				for (var i:int = 0; i < badges.length; i++)
				{
					_hasBadge[badges[i]] = false;
				}
				SAVE_FILE.data.hasBadge = _hasBadge;				
			}
			else
			{
				for (i = 0; i < badges.length; i++)
				{
					hasBadgeSet(badges[i], hasBadge(badges[i]));
				}
			}
			if (!SAVE_FILE.data.hasKey)
			{
				var _hasKey:Array = new Array();
				for (i = 0; i < Player.totalKeys; i++)
				{
					_hasKey[i] = false;
				}
				SAVE_FILE.data.hasKey = _hasKey;
			}
			else
			{
				for (i = 0; i < Player.totalKeys; i++)
				{
					hasKeySet(i, hasKey(i));
				}
			}
			if (!SAVE_FILE.data.hasTotemPart)
			{
				var _hasTotemPart:Array = new Array();
				for (i = 0; i < Player.totemParts; i++)
				{
					_hasTotemPart[i] = false;
				}
				SAVE_FILE.data.hasTotemPart = _hasTotemPart;
			}
			else
			{
				for (i = 0; i < Player.totemParts; i++)
				{
					hasTotemPartSet(i, hasTotemPart(i));
				}
			}
			if (!SAVE_FILE.data.hasSealPart)
			{
				var _hasSealPart:Array = new Array();
				for (i = 0; i < SealController.SEALS; i++)
				{
					_hasSealPart[i] = -1;
				}
				SAVE_FILE.data.hasSealPart = _hasSealPart;
			}
			else
			{
				for (i = 0; i < SealController.SEALS; i++)
				{
					hasSealPartSet(i, hasSealPart(i));
				}
			}
			if (!SAVE_FILE.data.levelPersistence)
			{
				var tempPersistence:Array = new Array();
				for (i = 0; i < Game.levels.length; i++)
				{
					for (var j:int = 0; j < Game.tagsPerLevel; j++)
					{
						tempPersistence.push(true);
					}
				}
				SAVE_FILE.data.levelPersistence = tempPersistence;
				trace("NO LEVEL PERSISTENCE:   " + SAVE_FILE.data.levelPersistence.length)
			}
			
			playerPositionX = playerPositionX;
			playerPositionY = playerPositionY;
			level = level;
			
			READY_TO_SUBMIT_BADGES = true;
		}
		
		
	}
	
}