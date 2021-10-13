package  
{
	import Enemies.Enemy;
	import Enemies.Flyer;
	import Enemies.IceTurret;
	import Enemies.LavaBoss;
	import Enemies.ShieldBoss;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	import NPCs.Watcher;
	import Projectiles.LavaBall;
	import Projectiles.WandShot;
	import Scenery.BurnableTree;
	import Scenery.Light;
	import Scenery.LightPole;
	import Scenery.Tile;
	import Scenery.Grass;
	import Scenery.Tree;
	import Puzzlements.*;
	import Scenery.Moonrock;
	import Projectiles.RayShot;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class Player extends Mobile
	{
		[Embed(source = "../assets/graphics/ShrumBlue.png")] private var imgShrum:Class;
		//[Embed(source = "../assets/graphics/ShrumBlue.png")] private var imgShrumBlue:Class;
		private var sprShrum:Spritemap = new Spritemap(imgShrum, 16, 16);
		[Embed(source = "../assets/graphics/ShrumDark.png")] private var imgShrumDark:Class;
		public var sprShrumDark:Spritemap = new Spritemap(imgShrumDark, 16, 16, endAnim);
		[Embed(source = "../assets/graphics/Slash.png")] private var imgSlash:Class;
		private var sprSlash:Spritemap = new Spritemap(imgSlash, 16, 32, slashEnd);
		[Embed(source = "../assets/graphics/SlashDark.png")] private var imgSlashDark:Class;
		private var sprSlashDark:Spritemap = new Spritemap(imgSlashDark, 16, 32, slashEnd);
		[Embed(source = "../assets/graphics/GhostSword.png")] private var imgGhostSword:Class;
		private var sprGhostSword:Spritemap = new Spritemap(imgGhostSword, 24, 7, slashEnd);
		[Embed(source = "../assets/graphics/GhostSpearStab.png")] private var imgSpear:Class;
		private var sprSpear:Spritemap = new Spritemap(imgSpear, 36, 7, spearEnd);
		[Embed(source = "../assets/graphics/Wand.png")] private var imgWand:Class;
		private var sprWand:Spritemap = new Spritemap(imgWand, 16, 10, wandEnd);
		[Embed(source = "../assets/graphics/FireWand.png")] private var imgFireWand:Class;
		private var sprFireWand:Spritemap = new Spritemap(imgFireWand, 17, 10, wandEnd);
		[Embed(source = "../assets/graphics/Fire.png")] private var imgFire:Class;
		private var sprFire:Spritemap = new Spritemap(imgFire, 32, 32, fireEnd);
		[Embed(source = "../assets/graphics/DeathRay.png")] private var imgDeathRay:Class;
		private var sprDeathRay:Spritemap = new Spritemap(imgDeathRay, 10,5, deathRayEnd);
		[Embed(source = "../assets/graphics/Shield.png")] private var imgShield:Class;
		private var sprShield:Spritemap = new Spritemap(imgShield, 7, 7);
		//Right, Up, Left, Down, Primary, Secondary, Talk, Inventory, Inventory 1
		public const keys:Array = new Array(Key.RIGHT, Key.UP, Key.LEFT, Key.DOWN, Key.X, Key.C, Key.X, Key.V, Key.I);
		
		private var direction:int = 3; //last direction moved in 0,1,2,3 = right, up, left down
		public var directionFace:int = -1; //a direction for the player to face with his sprite.  -1 to act normally.
		private var prev:Point = new Point(); // The last position of the player
		public var moveSpeed:Number = 0.5;
		public const slidingSpeed:Number = 1;
		public const waterfallAcceleration:Number = 0.8;
		private var onIce:Boolean = false;
		private var onWaterfall:Boolean = false;
		private var inWater:Boolean = false;
		private var inLava:Boolean = false;
		private var checkOffsetY:int; //Set in the constructor--determines the relative position at which the state is checked.
		
		private const dMS:Number = 0.8; //Walking speed
		private const dMSstair:Number = 0.4; //Walking speed on stairs
		private const dwASstair:int = 12;	//Walking animation speed on stairs
		private const dwAS:int = 15; //Walking animation speed
		private const dsAS:int = 1; //Standing animation speed
		private const dMSwater:Number = 0.45;
		private const dwASwater:int = 5;
		private const slidingFriction:Number = 0.025;
		
		private const states:Array = new Array("", "swim-", "", "", "", "", "", "", "", "",
											   "", "", "", "", "", "", "", "swim-", "", "", 
											   "", "", "", "", "", "swim-", "", "", "", "",
											   "", "", "", "", "", "", "", ""); //whether the player is on the ground, swimming, etc.
		private const moveSpeeds:Array = new Array(dMS, dMSwater, dMS, dMS, dMS, dMS, dMS, dMS, dMS, dMS,
												   dMSstair, dMS, dMS, dMS, dMS, dMS, dMS, dMSwater, dMS, dMS,
												   dMS, dMS, dMS, dMS, dMS, dMSwater/2, dMS, dMS, dMS, dMS,
												   dMSstair, dMS, dMS, dMS, dMS, dMS, dMS, dMS);
		private const walkAnimSpeeds:Array = new Array(dwAS, dwASwater, dwAS, dwAS, dwAS, dwAS, dwAS, dwAS, dwAS, dwAS, 
													   dwASstair, dwAS, dwAS, dwAS, dwAS, dwAS, dwAS, dwASwater, dwAS, dwAS,
													   dwAS, dwAS, dwAS, dwAS, dwAS, dwASwater, dwAS, dwAS, dwAS, dwAS,
													   dwASstair, dwAS, dwAS, dwAS, dwAS, dwAS, dwAS, dwAS);
		private const standAnimSpeeds:Array = new Array(dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS,
														dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS,
														dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS,
														dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS, dsAS);
		
		private var hitables:Object = ["Enemy", "Grass", "Tree", "Rock", "Rope", "ShieldBoss", "Solid", "LightPole", "LavaBall", "LavaBoss", "Watcher" ]; //Solid added so that you can hit burnable trees.
		private var enemies:Object = ["Enemy", "ShieldBoss"];
		
		public static function get hasSword():Boolean
		{
			return Main.hasSword;
		}
		public static function set hasSword(_hs:Boolean):void
		{
			Main.hasSword = _hs;
		}
		private var slashingSprite:Spritemap;
		private var _slashing:Boolean = false;
		private var slashDirection:int = -1;
		private const ghostSwordDamage:int = 2;
		private const darkSwordDamage:int = 2;
		private const swordDamage:int = 1;
		private const swordForce:int = 5; //The amount of push when an object is hit by a sword.
		private const slashDelayMax:int = 0; //The amount of time between slashes
		private var slashDelay:int = 0;
		private const slashTimerMax:int = 20; //The amount of time for which you can double-press to dash
		private var slashTimer:int = 0;
		private var slashDashed:Boolean = false;
		public static function get hasGhostSword():Boolean
		{
			return Main.hasGhostSword;
		}
		public static function set hasGhostSword(_hgs:Boolean):void
		{
			Main.hasGhostSword = _hgs;
		}
		private var ghostSwordAnimFrames:Object;
		private const swordSpeed:int = 30;
		private const swordSpeedDash:int = 20;
		
		public static function get hasSpear():Boolean
		{
			return Main.hasSpear;
		}
		public static function set hasSpear(_hs:Boolean):void
		{
			Main.hasSpear = _hs;
		}
		private var _spearing:Boolean = false;
		private var spearDirection:int = -1;
		private const spearDamage:int = 2;
		private const spearForce:int = 7; //The amount of push when an object is hit by a sword.
		private const spearDelayMax:int = 1;
		private var spearDelay:int = 0;
		private const spearOffset:Point = new Point( -1, 2);
		
		public static function get hasWand():Boolean
		{
			return Main.hasWand;
		}
		public static function set hasWand(_hw:Boolean):void
		{
			Main.hasWand = _hw;
		}
		public static function get hasFireWand():Boolean
		{
			return Main.hasFireWand;
		}
		public static function set hasFireWand(_hfw:Boolean):void
		{
			Main.hasFireWand = _hfw;
		}
		private var _wanding:Boolean = false;
		private const wandSpeed:int = 3;
		
		public static function get hasFire():Boolean
		{
			return Main.hasFire;
		}
		public static function set hasFire(_hf:Boolean):void
		{
			Main.hasFire = _hf;
		}
		private var _firing:Boolean = false;
		private const fireDamage:Number = 0;// .5;
		private const fireForce:Number = 0.325; //The amount of push when an object is hit by fire (done every step of collision).
		private var fireTimer:int = 0;
		private const fireTimerMax:int = 180;
		private const fireIncrement:int = 60;
		
		
		public static var _hasTorch:Boolean = false;
		private var myLight:PlayerLight;
		public var myLightPosition:Point = new Point();
		public static function get hasTorch():Boolean
		{
			return Main.hasTorch;
		}
		public static function set hasTorch(_ht:Boolean):void
		{
			Main.hasTorch = _ht;
		}
		
		public static var _hasFeather:Boolean = false;
		public static function get hasFeather():Boolean
		{
			return Main.hasFeather;
		}
		public static function set hasFeather(_hf:Boolean):void
		{
			Main.hasFeather = _hf;
		}
		
		public static var hasDeathRay:Boolean = false;
		private var _deathRaying:Boolean = false;
		private const deathRaySpeed:int = 8;
		
		private const darkShieldDamage:Number = 0.5;
		public static function get hasDarkShield():Boolean
		{
			return Main.hasDarkShield;
		}
		public static function set hasDarkShield(_hf:Boolean):void
		{
			Main.hasDarkShield = _hf;
		}
		
		public static var _hasDarkSword:Boolean = false;
		public static function get hasDarkSword():Boolean
		{
			return Main.hasDarkSword;
		}
		public static function set hasDarkSword(_hf:Boolean):void
		{
			Main.hasDarkSword = _hf;
		}
		
		public static var _hasShield:Boolean = false;
		public static function get hasShield():Boolean
		{
			return Main.hasShield;
		}
		public static function set hasShield(_hf:Boolean):void
		{
			Main.hasShield = _hf;
		}
		private const shieldOffset:Point = new Point(2, 3);
		private const shieldSideOffset:Point = new Point(4, 0);
		private const shieldForce:Number = 5;
		private var shieldRange:Number = Math.PI / 2; //The angular range the shield covers in the direction of movement.
		private var shieldObj:Entity;
		
		public static var _hasDarkSuit:Boolean = false;
		public static function get hasDarkSuit():Boolean
		{
			return Main.hasDarkSuit;
		}
		public static function set hasDarkSuit(_hf:Boolean):void
		{
			Main.hasDarkSuit = _hf;
		}
		private var darkSuitDamage:Number = 1;
		private var darkSuitForce:Number = 1;
		
		public static const totalKeys:int = 5;
		public static function hasKeySet(i:int, _t:Boolean):void
		{
			Main.hasKeySet(i, _t);
		}
		public static function hasKey(i:int):Boolean
		{
			return Main.hasKey(i);
		}
		public static function hasKeyNumber():int
		{
			var n:int = 0;
			for (var i:int = 0; i < totalKeys; i++)
			{
				n += int(hasKey(i));
			}
			return n;
		}
		public static const totemParts:int = 5;
		public static function hasTotemPartSet(i:int, _t:Boolean):void
		{
			Main.hasTotemPartSet(i, _t);
		}
		public static function hasTotemPart(i:int):Boolean
		{
			return Main.hasTotemPart(i);
		}
		public static function hasTotemPartNumber():int
		{
			var n:int = 0;
			for (var i:int = 0; i < totemParts; i++)
			{
				n += int(hasTotemPart(i));
			}
			return n;
		}
		
		private var normalHitbox:Rectangle = new Rectangle(2, 2, 4, 5);
		
		private var _state:int = 0;
		private var lastState:int = 0; //The last type of block touched.
		private var lastPosition:Point = new Point(); // The last position before changing to a new kind of block
		
		private var knocked:Boolean = false;
		
		public static var _canSwim:Boolean = false;
		public static function get canSwim():Boolean
		{
			return Main.canSwim;
		}
		public static function set canSwim(_cs:Boolean):void
		{
			Main.canSwim = _cs;
		}
		private const drownTimerMax:int = 10;
		public var drownTimer:Number = 0;
		
		private var dying:Boolean = false;
		private var drowning:Boolean = false;
		
		public var fallFromCeiling:Boolean = false;
		private var yStart:int;
		private var bouncedFromCeiling:Boolean = false;
		
		public var receiveInput:Boolean = true;
		
		public var hits:Number = 0;
		public static const hitsMaxDef:int = 3; //The default number of hits to kill the player.
		public static function set hitsMax(_ht:int):void
		{
			Main.hitsMax = _ht;
		}
		public static function get hitsMax():int
		{
			return Main.hitsMax;
		}
		
		public var hitsTimer:int = 0;
		public const hitsTimerMax:int = 20;
		public const hitsTimerInt:int = 10;
		public const hitsColor:uint = 0xFF0000;
		public const normalColor:uint = 0xFFFFFF;
		public const frozenColor:uint = 0x0000FF;
		
		public var fallInPit:Boolean = false;
		public var fallInPitPos:Point = new Point();
		public const fallSpinSpeed:int = 8 * FP.choose(-1, 1);
		public const fallAlphaSpeed:Number = 0.05;
		
		private var frozenTimer:int = 0;
		private const frozenTimerMax:int = 90;
		
		public var onGround:Boolean = true;
		
		private var coverAlpha:Number = 0;
		private var coverAlphaRate:Number = 0.005;
		
		public function Player(_x:int, _y:int) 
		{
			super(_x + Tile.w / 2, _y + Tile.h / 2);
			yStart = y;
			solids.push("LavaBoss");
			
			sprShrum.centerOO();
			sprShrumDark.centerOO();
			
			addAnimations(sprShrum);
			addAnimations(sprShrumDark);
			
			graphic = getSuit();
			slashingSprite = getSword();
			
			(graphic as Spritemap).play("down-stand");
			
			sprSlash.centerOO();
			sprSlash.x = sprSlash.originX = 0;
			sprSlash.add("slash", [0, 1, 2, 3, 4], swordSpeed, true);
			sprSlash.add("slashnarrow", [1, 2, 3], swordSpeedDash, true);
			sprSlashDark.centerOO();
			sprSlashDark.x = sprSlashDark.originX = 0;
			sprSlashDark.add("slash", [0, 1, 2, 3, 4], swordSpeed, true);
			sprSlashDark.add("slashnarrow", [1, 2, 3], swordSpeedDash, true);
			
			const ghostSwordFrames:Array = new Array(0, 1, 2, 2, 3, 3, 4);
			const ghostSwordFramesNarrow:Array = new Array(0, 1, 2, 3);
			sprGhostSword.centerOO();
			sprGhostSword.x = sprGhostSword.originX = 0;
			sprGhostSword.add("slash", ghostSwordFrames, swordSpeed, true);
			sprGhostSword.add("slashnarrow", ghostSwordFramesNarrow, swordSpeedDash, true);
			ghostSwordAnimFrames = {"slash":ghostSwordFrames.length, "slashnarrow":ghostSwordFramesNarrow.length * 2};
			
			sprSpear.centerOO();
			sprSpear.originX = 4;
			sprSpear.x = -sprSpear.originX;
			sprSpear.add("spear", [0, 1, 2, 3, 4, 5, 6, 7], 45, true);
			
			sprShield.centerOO();
			
			sprWand.x = sprWand.originX = 0;
			sprWand.y = -8;
			sprWand.originY = 8;
			sprWand.add("wand", [0, 1, 2, 3, 4], 20, true);
			
			sprFireWand.x = sprFireWand.originX = 0;
			sprFireWand.y = -8;
			sprFireWand.originY = 8;
			sprFireWand.add("wand", [0, 1, 2, 3, 4], 20, true);
			
			sprFire.centerOO();
			sprFire.add("fire", [0, 1, 2, 3, 4, 5, 6, 7, 8], 25, true);
			
			sprDeathRay.y = -1;
			sprDeathRay.originY = 1;
			sprDeathRay.add("ray", [0, 1, 2, 3], 10, true);
			
			type = "Player";
			setHitbox(normalHitbox.width, normalHitbox.height, normalHitbox.x, normalHitbox.y);
			
			checkOffsetY = -originY + height - 2;
		}
		
		override public function check():void
		{
			super.check();
			if (fallFromCeiling)
			{
				y = FP.camera.y-(height - originY);
			}
			if (Game.cheats)
			{
				hasSword = true;
				hasFire = true;
				hasShield = true;
				hasWand = true;
				hasDarkSword = true;
				hasDarkShield = true;
				hasDarkSuit = true;
				canSwim = true;
				hasFeather = true;
				hasSpear = true;
				hasFireWand = true;
				hasGhostSword = true;
				hasTorch = true;
				
				Main.rockSet = true;
				
				hasTotemPartSet(0, true);
				hasTotemPartSet(1, true);
				hasTotemPartSet(2, true);
				hasTotemPartSet(3, true);
				hasTotemPartSet(4, true);
				
				hasKeySet(0, true);
				hasKeySet(1, true);
				hasKeySet(2, true);
				hasKeySet(3, true);
				hasKeySet(4, true);
			}
		}
		
		override public function update():void
		{
			graphic = getSuit();
			slashingSprite = getSword();
			
			if (sprShrumDark.currentAnim == "dead")
			{
				(FP.world as Game).drawCover(0, coverAlpha);
				coverAlpha += coverAlphaRate;
				if (coverAlpha >= 1)
				{
					coverAlpha = 1;
					Main.unlockMedal(Main.badges[13]);
					Game.menu = true;
					Game.cutscene[1] = false;
					FP.world = new Game(114, 72, 128, false, 2);
				}
			}
			
			if (!myLight && hasTorch)
			{
				FP.world.add(myLight = new PlayerLight(x, y, this));
			}
			if (fallFromCeiling)
			{
				v.y += 0.1;
				v.y = Math.min(v.y, 5);
				y += v.y;
				layer = -yStart;
				(graphic as Spritemap).angle += 10;
				if (y >= yStart)
				{
					if (bouncedFromCeiling || getStatePos(x, yStart) == 6 /* PIT */ || getStatePos(x, yStart) == 1 /* WATER */ || getStatePos(x, yStart) == 17 /* Lava */)
					{
						fallFromCeiling = false;
						directionFace = -1;
						(graphic as Spritemap).angle = 0;
						v.y = 0;
						direction = 3;
						Music.playSound("Ground Hit", 1);
					}
					else
					{
						y = yStart;
						v.y = -2;
						Music.playSound("Ground Hit", 0);
						bouncedFromCeiling = true;
					}
				}
			}
			else
			{
				getState();
				addShield();
				shieldBump();
				checkDrowning();
				freezeStep();
				
				if (onIce) // Ice
				{
					f = slidingFriction;
					moveSpeed = slidingSpeed;
				}
				else
				{
					moveSpeed = moveSpeeds[state];
					if (inWater || inLava)
					{
						f = WATER_FRICTION;
						moveSpeed = moveSpeeds[state] + 0.25 * int(Music.soundPosition("Swim") < 0.1);
						if(v.length > 0 && !Music.soundIsPlaying("Swim"))
						{
							Music.playSound("Swim");
						}
					}
					else
					{
						f = DEFAULT_FRICTION;
					}
				}
				
				if (hasSword)
				{
					slash();
				}
				if (hasSpear)
				{
					spear();
				}
				if (hasFire)
				{
					fire();
				}
				prev = new Point(x, y);
				if (!dying)
				{
					super.update();
				}
				sprites();
				hitUpdate();
				checkFallingInPit();
				
				x = Math.min(Math.max(x, originX), FP.width + originX - width)
				y = Math.min(Math.max(y, originY), FP.height + originY - height);
			}
		}
		
		public function freeze(frozenTime:int=frozenTimerMax):void
		{
			frozenTimer = frozenTime;
		}
		
		public function freezeStep():void
		{
			if (frozenTimer > 0)
			{
				frozenTimer--;
				(graphic as Spritemap).color = frozenColor;
				if (frozenTimer <= 0)
				{
					(graphic as Spritemap).color = normalColor;
				}
			}
		}
		
		public function getSuit():Spritemap
		{
			if (hasDarkSuit)
			{
				return sprShrumDark;
			}
			else
			{
				return sprShrum;
			}
		}
		
		public function getSword():Spritemap
		{
			if (hasGhostSword)
			{
				return sprGhostSword;
			}
			else
			{
				if (hasDarkSword)
				{
					return sprSlashDark;
				}
				else
				{
					return sprSlash;
				}
			}
		}
		
		public function addAnimations(g:Spritemap):void
		{
			const colW:int = 9; //columns per row
			for (var row:int = 0; row <= states.length; row++)
			{
				var next:Boolean = false;
				for (var i:int = 0; i < row; i++)
				{
					if (states[i] == states[row])
					{
						next = true;
						break;
					}
				}
				if (next)
				{
					continue;
				}
				g.add(states[row]+"down-walk", [row*colW, row*colW+1, row*colW+2, row*colW+1], walkAnimSpeeds[row], true);
				g.add(states[row]+"down-stand", [row*colW, row*colW+1], standAnimSpeeds[state], true);
				g.add(states[row]+"side-walk", [row*colW+3, row*colW+4, row*colW+5, row*colW+4], walkAnimSpeeds[row], true);
				g.add(states[row]+"side-stand", [row*colW+3, row*colW+4], standAnimSpeeds[state], true);
				g.add(states[row]+"up-walk", [row*colW+6, row*colW+7, row*colW+8, row*colW+7], walkAnimSpeeds[row], true);
				g.add(states[row]+"up-stand", [row * colW + 6, row * colW + 7], standAnimSpeeds[row], true);
			}
			//Sloppy hacky code for making the death animation in the final (bad) scene work.
			if (g == sprShrumDark)
			{
				var s:int = 2*colW;
				g.add("die", [s,s,s,s,s,s, s, s + 1, s + 2, s + 3, s + 4, s + 5, s + 6, s + 7, s + 8], 3.5); 
				g.add("dead", [s + 8], 0);
			}
		}
		
		private function endAnim():void
		{
			if (graphic == sprShrumDark && sprShrumDark.currentAnim == "die")
			{
				sprShrumDark.play("dead");
			}
		}
		
		public function getState():void
		{
			var tile:Tile = FP.world.nearestToPoint("Tile", x, y + checkOffsetY) as Tile;
			//Check if there's a tile, and if you're hitting it
			if (tile && (new Rectangle(tile.x-tile.originX,tile.y-tile.originY,tile.width,tile.height)).intersects(new Rectangle(x-originX, y-originY+checkOffsetY, width, height)))
			{
				if (state != tile.t && (tile.t == 1 /* WATER */ || tile.t == 17 /* LAVA */))
				{
					Music.playSound("Splash");
				}
				state = tile.t;
			}
		}
		
		public function getStatePos(_x:int, _y:int):int
		{
			var tile:Tile = FP.world.nearestToPoint("Tile", _x, _y) as Tile;
			if (tile)
			{
				return tile.t;
			}
			else return -1;
		}
		
		public function get state():int
		{
			return _state;
		}
		
		public function set state(_s:int):void
		{
			if (_s != _state)
			{
				lastState = _state;
				var tile:Tile = FP.world.nearestToPoint("Tile", prev.x, prev.y + checkOffsetY) as Tile;
				if (onGround)
				{
					if (_s == 6 /* Pit */)
					{
						var tile_test:Tile = FP.world.nearestToPoint("Tile", x, y + checkOffsetY) as Tile;
						fallInPitPos = new Point(tile_test.x, tile_test.y);
						fallInPit = true;
						Music.playSound("Player Fall");
					}
					onIce = _s == 22; /* Ice */
					onWaterfall = _s == 25; /* Waterfall */
					inWater = _s == 1 || _s == 25; /* Water */
					inLava = _s == 17;
				}
				else
				{
					onIce = false;
					onWaterfall = false;
					inWater = false;
					inLava = false;
				}
				lastPosition = new Point(tile.x, tile.y);
			}
			_state = _s;
			moveSpeed = moveSpeeds[state];
		}
		
		public function checkFallingInPit():void
		{
			if (fallInPit)
			{
				receiveInput = false;
				directionFace = 3;
				const divisor:int = 10;
				x += (Math.floor(fallInPitPos.x / Tile.w) * Tile.w + Tile.w / 2 - x) / divisor;
				y += (Math.floor(fallInPitPos.y / Tile.h) * Tile.h + Tile.h / 2 - y) / divisor;
				(graphic as Image).angle += fallSpinSpeed;
				(graphic as Image).alpha -= fallAlphaSpeed;
				if ((graphic as Image).alpha <= 0)
				{
					if (Game.fallthroughLevel > -1)
					{
						x = Math.floor(Math.max(fallInPitPos.x - Game.fallthroughOffset.x, 0) / Tile.w) * Tile.w;
						y = Math.floor(Math.max(fallInPitPos.y - Game.fallthroughOffset.y, 0) / Tile.h) * Tile.h;
						Game.setFallFromCeiling = true;
						Game.sign = Game.fallthroughSign;
						FP.world = new Game(Game.fallthroughLevel, x, y);
					}
					else
					{
						die();
					}
				}
			}
		}
		
		public function get slashing():Boolean
		{
			return _slashing;
		}
		
		public function set slashing(_s:Boolean):void
		{
			//slashDirection = -1;
			if ((hasSword || hasGhostSword) && !wanding && !firing && !deathRaying && !spearing)
			{
				if (slashTimer > 0 && _s && !slashDashed)
				{
					slashDashed = true;
					slashingSprite.play("slashnarrow", true);
					knockback(2, new Point(x - v.x, y - v.y));
					slashDirection = direction;
					Music.playSound("Sword");
				}
				else if (!slashing && _s)
				{
					slashingSprite.play("slash", true);
					slashDirection = direction;
					slashTimer = slashTimerMax;
					Music.playSound("Sword");
				}
				if (!_s)
				{
					slashDashed = false;
				}
				_slashing = _s;
			}
		}
		
		public function get spearing():Boolean
		{
			return _spearing;
		}
		
		public function set spearing(_s:Boolean):void
		{
			spearDirection = -1;
			if (hasSpear && !wanding && !firing && !deathRaying && !slashing)
			{
				if (!spearing && _s)
				{
					sprSpear.play("spear", true);
					spearDirection = direction;
					Music.playSound("Stab");
				}
				_spearing = _s;
			}
		}
		
		public function get wanding():Boolean
		{
			return _wanding;
		}
		
		public function set wanding(_w:Boolean):void
		{
			if ((hasWand || hasFireWand) && !slashing && (!firing || hasFireWand) && !deathRaying && !spearing)
			{
				if (!wanding && _w)
				{
					if (hasFireWand)
					{
						sprFireWand.play("wand", true);
					}
					else
					{
						sprWand.play("wand", true);
					}
				}
				_wanding = _w;
			}
		}
		
		public function get firing():Boolean
		{
			return _firing;
		}
		
		public function set firing(_f:Boolean):void
		{
			if ((hasFire || hasFireWand) && !slashing && (!wanding || hasFireWand) && !deathRaying && !spearing)
			{
				if (!firing && _f)
				{
					sprFire.play("fire", true);
					Music.playSound("Fire", -1, 0.4);
					fireTimer += fireIncrement;
					if (fireTimer >= fireTimerMax)
					{
						//hit();
						fireTimer = fireTimerMax;
					}
				}
				_firing = _f;
			}
		}
		
		public function get deathRaying():Boolean
		{
			return _deathRaying;
		}
		
		public function set deathRaying(_d:Boolean):void
		{
			if (hasDeathRay && !slashing && !wanding && !firing && !spearing)
			{
				if (!deathRaying && _d)
				{
					sprDeathRay.play("ray", true);
				}
				_deathRaying = _d;
			}
		}
		
		public function slash():void
		{
			if (slashTimer > 0)
			{
				slashTimer--;
			}
			if (slashDelay > 0)
			{
				slashDelay--;
			}
			else if(slashing)
			{
				slashDelay = slashDelayMax;
				var v:Vector.<Entity> = new Vector.<Entity>();
				for (var i:int = 0; i < hitables.length; i++)
				{
					var rect:Rectangle = getSlashRect();
					FP.world.collideRectInto(hitables[i], rect.x, rect.y, rect.width, rect.height, v);
				}
				for (i = 0; i < v.length; i++)
				{
					if ((FP.distance(x, y, v[i].x, v[i].y) <= slashingSprite.width * slashingSprite.scaleX && v[i] is Grass) ||
						(FP.distanceRectPoint(x, y, v[i].x - v[i].originX, v[i].y - v[i].originY, v[i].width, v[i].height) <= slashingSprite.width * slashingSprite.scaleX && !(v[i] is Grass)))
					{
						if (!FP.world.collideLine("Solid", x, y, v[i].x, v[i].y) || hasGhostSword || v[i].type == "Solid" || v[i].type == "Rope" || v[i] is Flyer)
						{
							if (hasGhostSword)
							{
								spearDirection = direction;
							}
							genericHit(v[i], hasGhostSword ? "Spear" : "Sword", swordForce, hasGhostSword ? ghostSwordDamage : (hasDarkSword ? darkSwordDamage : swordDamage));
						}
					}
				}
			}
		}
		
		public function getSlashRect():Rectangle
		{
			var rect:Rectangle = new Rectangle();
			const h:int = hasGhostSword ? slashingSprite.width*2 : slashingSprite.height;
			switch(slashDirection)
			{
				case 0: rect.x = x; rect.y = y - h / 2 * slashingSprite.scaleY;
						rect.width = slashingSprite.width * slashingSprite.scaleX; rect.height = h * slashingSprite.scaleY;
						break;
				case 1: rect.x = x - h / 2 * slashingSprite.scaleY; rect.y = y - slashingSprite.width * slashingSprite.scaleX;
						rect.width = h * slashingSprite.scaleY; rect.height = slashingSprite.width * slashingSprite.scaleX;
						break;
				case 2: rect.x = x - slashingSprite.width * slashingSprite.scaleX; rect.y = y - h / 2 * slashingSprite.scaleY;
						rect.width = slashingSprite.width * slashingSprite.scaleX; rect.height = h * slashingSprite.scaleY;
						break;
				case 3: rect.x = x - h / 2 * slashingSprite.scaleY; rect.y = y;
						rect.width = h * slashingSprite.scaleY; rect.height = slashingSprite.width * slashingSprite.scaleX;
						break;
				default:
			}
			return rect;
		}
		
		public function spear():void
		{
			if (spearDelay > 0)
			{
				spearDelay--;
			}
			else if(spearing)
			{
				spearDelay = spearDelayMax;
				var v:Vector.<Entity> = new Vector.<Entity>();
				for (var i:int = 0; i < hitables.length; i++)
				{
					const length:int = 32;
					const thick:int = 5;
					var rect:Rectangle = new Rectangle();
					switch(spearDirection)
					{
						case 0: rect.x = spearX; rect.y = spearY - thick/2 + 1;
								rect.width = length; rect.height = thick;
								break;
						case 1: rect.x = spearX - thick/2 + 1; rect.y = spearY - length;
								rect.width = thick; rect.height = length;
								break;
						case 2: rect.x = spearX - length; rect.y = spearY - thick/2;
								rect.width = length; rect.height = thick;
								break;
						case 3: rect.x = spearX - thick/2; rect.y = spearY;
								rect.width = thick; rect.height = length;
								break;
						default:
					}
					FP.world.collideRectInto(hitables[i], rect.x, rect.y, rect.width, rect.height, v);
				}
				for (i = 0; i < v.length; i++)
				{
					genericHit(v[i], "Spear", spearForce, spearDamage);
				}
			}
		}
		
		public function wand():void
		{
			if (wanding)
			{
				var a:Number = direction * Math.PI / 2;
				var pos:Point = new Point(x + sprWand.width * Math.cos(a), y - sprWand.width * Math.sin(a));
				var v:Point = new Point(wandSpeed * Math.cos(a), -wandSpeed * Math.sin(a));
				FP.world.add(new WandShot(pos.x, pos.y, v, hasFireWand));
			}
		}
		
		public function deathRay():void
		{
			if (deathRaying)
			{
				var a:Number = direction * Math.PI / 2;
				FP.world.add(new RayShot(x + sprDeathRay.width * Math.cos(a), y - sprDeathRay.width * Math.sin(a), new Point(deathRaySpeed * Math.cos(a), -deathRaySpeed * Math.sin(a))));
			}
		}
		
		public function fire():void
		{
			if (firing)
			{
				var fireHitFrameStart:int = 3; // The first frame in the fire animation to hit enemies with.
				var fireHitFrameEnd:int = 6; // The last frame in the fire animation to hit enemies with.
				if (sprFire.frame >= fireHitFrameStart && sprFire.frame <= fireHitFrameEnd)
				{
					var vc:Vector.<Entity> = new Vector.<Entity>();
					for (var i:int = 0; i < hitables.length; i++)
					{
						FP.world.collideRectInto(hitables[i], x - sprFire.originX, y - sprFire.originY, sprFire.width, sprFire.height, vc);
						for each (var e:Entity in vc)
						{
							if (FP.distanceRects(x - originX, y - originY, width, height, e.x - e.originX, e.y - originY, e.width, e.height) > sprFire.width / 2) //Only take those in a radius around the player, to cut off corners.
							{
								continue;
							}
							genericHit(e, "Fire", fireForce, fireDamage);
						}
					}
				}
			}
			else
			{
				if (fireTimer > 0)
				{
					fireTimer--;
				}
			}
		}
		
		public function slashEnd():void
		{
			slashing = false;
		}
		
		public function spearEnd():void
		{
			spearing = false;
		}
		
		public function wandEnd():void
		{
			wand();
			wanding = false;
		}
		
		public function fireEnd():void
		{
			firing = false;
		}
		
		public function deathRayEnd():void
		{
			deathRay();
			deathRaying = false;
		}
		
		public function genericHit(e:Entity, t:String="", f:Number=swordForce, d:Number=swordDamage):void
		{
			if (Game.freezeObjects)
			{
				return;
			}
			if (e is Enemy)
			{
				if (e is IceTurret)
				{
					(e as IceTurret).bump(new Point(x, y), t);
				}
				(e as Enemy).hit(f, new Point(x, y), d, t);
			}
			else if (e is Grass)
			{
				(e as Grass).cut(t);
			}
			else if (e is BreakableRock)
			{
				(e as BreakableRock).hit(hasGhostSword ? 1 : 0);
			}
			else if (e is RopeStart)
			{
				(e as RopeStart).hit();
			}
			else if (e is ShieldBoss)
			{
				(e as ShieldBoss).hit(0, null, d);
			}
			else if (e is LightPole)
			{
				if (t == "Spear")
				{
					(e as LightPole).hit();
				}
			}
			else if (e is Tree)
			{
				(e as Tree).hit(t);
			}
			else if (e is Tile)
			{
				if (t == "Spear")
				{
					(e as Tile).bridgeOpeningTimer--;
				}
			}
			else if (e is PushableBlockSpear)
			{
				(e as PushableBlockSpear).hit(new Point(int(spearDirection % 2 == 0) * (spearDirection - 1), int(spearDirection % 2 == 1) * (2 - spearDirection)), t, true);
			}
			else if (e is PushableBlockFire)
			{
				(e as PushableBlockFire).hit(new Point(x, y), t);
			}
			else if (e is LavaBall)
			{
				(e as LavaBall).hit();
			}
			else if (e is Watcher)
			{
				(e as Watcher).hit();
			}
		}
		
		public function addShield():void
		{
			if (!shieldObj && hasShield)
			{
				shieldObj = new Entity();
				shieldObj.type = "Shield";
				FP.world.add(shieldObj);
			}
		}
		
		override public function render():void
		{
			if (directionFace >= 0)
			{
				if (direction == 2)
				{
					(graphic as Spritemap).scaleX = -Math.abs((graphic as Spritemap).scaleX);
				}
				else
				{
					(graphic as Spritemap).scaleX = Math.abs((graphic as Spritemap).scaleX);
				}
			}
			else
			{
				if (v.x < 0)
				{
					(graphic as Spritemap).scaleX = -Math.abs((graphic as Spritemap).scaleX);
				}
				else if(v.x > 0)
				{
					(graphic as Spritemap).scaleX = Math.abs((graphic as Spritemap).scaleX);
				}
			}
			if (direction == 1 || direction == 2)
			{
				sprShield.scaleX = -Math.abs(sprShield.scaleX);
			}
			else
			{
				sprShield.scaleX = Math.abs(sprShield.scaleX);
			}
			var shieldDraw:Boolean = sprShrumDark.currentAnim != "dead" && sprShrumDark.currentAnim != "die";
			if (hasShield && shieldObj && shieldDraw)
			{
				if (direction == 1 && v.x == 0)
				{
					shieldObj.setHitbox(sprShield.width, sprShield.height, sprShield.width / 2, sprShield.height / 2);
					shieldObj.x = x - shieldOffset.x;
					shieldObj.y = y - shieldOffset.y + int(slashing);
					sprShield.frame = 2 * int(hasDarkShield);
					sprShield.alpha = (graphic as Image).alpha;
					sprShield.render(new Point(shieldObj.x, shieldObj.y), FP.camera);
				}
			}
			if (spearing && spearDirection == 1)
			{
				renderSpear();
			}
			if (slashing && slashingSprite.currentAnim == "slashnarrow")
			{
				var tempAlpha:Number = (graphic as Image).alpha;
				var numBlurs:int = 4;
				for (var i:int = numBlurs; i > 0; i--)
				{
					(graphic as Image).alpha = (numBlurs - i - 1) / numBlurs + 0.5;
					(graphic as Image).render(new Point(x - i * v.x, y - i * v.y), FP.camera);
					if (hasDarkSuit)
					{
						Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
						(graphic as Image).render(new Point(x - i * v.x, y - i * v.y), FP.camera);
						Draw.resetTarget();
					}
				}
				(graphic as Image).alpha = tempAlpha;
			}
			super.render();
			if (hasDarkSuit)
			{
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				super.render();
				Draw.resetTarget();
			}
			if (hasDarkShield && hasShield && shieldObj && shieldDraw)
			{
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				sprShield.render(new Point(shieldObj.x, shieldObj.y), FP.camera);
				Draw.resetTarget();
			}
			if (hasShield && shieldObj && shieldDraw)
			{
				if (direction == 3 && v.x == 0)
				{
					shieldObj.setHitbox(sprShield.width, sprShield.height, sprShield.width / 2, sprShield.height / 2);
					shieldObj.x = x + shieldOffset.x;
					shieldObj.y = y + shieldOffset.y - int(slashing);
					sprShield.frame = 2 * int(hasDarkShield);
					sprShield.alpha = (graphic as Image).alpha;
					sprShield.render(new Point(shieldObj.x, shieldObj.y), FP.camera);
				}
				else if (v.x < 0 || (v.x == 0 && direction == 2))
				{
					shieldObj.setHitbox(3, sprShield.height, 2, sprShield.height / 2);
					shieldObj.x = x - shieldSideOffset.x;
					shieldObj.y = y + shieldSideOffset.y;
					sprShield.alpha = (graphic as Image).alpha;
					sprShield.frame = 1 + 2 * int(hasDarkShield);
					sprShield.render(new Point(shieldObj.x, shieldObj.y), FP.camera);
				}
				else if (v.x > 0 || (v.x == 0 && direction == 0))
				{
					shieldObj.setHitbox(3, sprShield.height, 2, sprShield.height / 2);
					shieldObj.x = x + shieldSideOffset.x;
					shieldObj.y = y + shieldSideOffset.y;
					sprShield.alpha = (graphic as Image).alpha;
					sprShield.frame = 1 + 2 * int(hasDarkShield);
					sprShield.render(new Point(shieldObj.x, shieldObj.y), FP.camera);
				}
			}
			if (slashing)
			{
				if (slashingSprite.currentAnim == "slashnarrow" && !hasGhostSword)
				{
					slashingSprite.scaleX = 1.5;
					slashingSprite.scaleY = 0.65;
				}
				else
				{
					slashingSprite.scaleX = slashingSprite.scaleY = 1;
				}
				
				slashingSprite.angle = 90 * slashDirection;
				if (hasGhostSword)
				{
					var animFrames:int = ghostSwordAnimFrames[slashingSprite.currentAnim];
					slashingSprite.angle += 90 - 180 * slashingSprite.index / (animFrames - 1);
					slashingSprite.angle -= 45 * int(slashingSprite.currentAnim == "slashnarrow");
				}
				slashingSprite.render(new Point(x, y), FP.camera);
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				slashingSprite.alpha = 0.25;
				slashingSprite.render(new Point(x, y), FP.camera);
				slashingSprite.alpha = 1;
				Draw.resetTarget();
			}
			if (spearing && spearDirection != 1)
			{
				renderSpear();
			}
			if (wanding)
			{
				if (hasFireWand)
				{
					sprFireWand.angle = 90 * direction;
					sprFireWand.render(new Point(x, y), FP.camera);
				}
				else
				{
					sprWand.angle = 90 * direction;
					sprWand.render(new Point(x, y), FP.camera);
				}
			}
			if (deathRaying)
			{
				sprDeathRay.angle = 90 * direction;
				sprDeathRay.render(new Point(x, y), FP.camera);
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				sprDeathRay.render(new Point(x, y), FP.camera);
				Draw.resetTarget();
			}
			if (firing)
			{
				sprFire.render(new Point(x, y), FP.camera);
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				sprFire.render(new Point(x, y), FP.camera);
				var scChange:Number = 0.25;
				sprFire.scale += scChange;
				sprFire.render(new Point(x, y), FP.camera);
				sprFire.scale -= 2 * scChange;
				sprFire.render(new Point(x, y), FP.camera);
				sprFire.scale += scChange;
				Draw.resetTarget();
			}
			
			if (fireTimer > 0)
			{
				/*
				drawFireOver(0.2);
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				drawFireOver(0.8);
				Draw.resetTarget();
				*/
			}
			
			/*if (slashing)
			{
				var rect:Rectangle = getSlashRect();
				Draw.rect(rect.x, rect.y, rect.width, rect.height, 0xFFFFFF, 0.5);
			}*/
			
		}
		
		public function get spearX():int
		{
			return x + spearOffset.x * (spearDirection % 2) * (spearDirection - 2);
		}
		public function get spearY():int
		{
			return y + spearOffset.y * (spearDirection % 2) + (1 - (spearDirection % 2)) + int(spearDirection == 2);
		}
		
		public function renderSpear():void
		{
			const divisor:Number = 1.5;
			sprSpear.angle += FP.DEG * FP.angle_difference(90 * spearDirection * FP.RAD, sprSpear.angle * FP.RAD) / divisor;
			sprSpear.render(new Point(spearX, spearY), FP.camera);
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			sprSpear.render(new Point(spearX, spearY), FP.camera);
			Draw.resetTarget();
		}
		
		public function drawFireOver(a:Number=1):void
		{
			const rMin:int = 4;
			const rMax:int = 20;
			const extra:int = 4;
			const r:int = rMin + fireTimer / fireTimerMax * (rMax - rMin);// + Game.worldFrame(2) * extra;
			
			Draw.circlePlus(x, y, r, 0xFF0000, fireTimer / fireTimerMax * a);
			Draw.circlePlus(x, y, r * 2 / 3, 0xFF8800, fireTimer / fireTimerMax * a);
			Draw.circlePlus(x, y, r / 3, 0xFFFF00, fireTimer / fireTimerMax * a);
			
			(FP.world as Game).drawCover(0xFF0000, fireTimer / fireTimerMax / 3);
		}
		
		public function hit(e:Enemy=null, f:Number=0, p:Point=null, d:Number=1):void
		{
			if (hitsTimer <= 0 && hits < hitsMax && !Game.freezeObjects)
			{
				if (e && hasDarkSuit)
				{
					e.hit(darkSuitForce, new Point(x, y), darkSuitDamage, "Suit");
				}
				Music.playSound("Hurt");
				hits += d;
				hitsTimer = hitsTimerMax;
				Game.shake += 5;
				if (hits >= hitsMax)
				{
					die();
				}
				else
				{
					knockback(f, p);
				}
			}
		}
		
		public function hitUpdate():void
		{
			Game.health(hits, hitsMax);
			if (hitsTimer > 0)
			{				
				if (hitsTimer % hitsTimerInt == 0)
				{
					if ((graphic as Image).color != hitsColor)
					{
						(graphic as Image).color = hitsColor;
					}
					else
					{
						(graphic as Image).color = normalColor;
					}
				}
				hitsTimer--;
				if (hitsTimer <= 0)
				{
					(graphic as Image).color = normalColor;
					//watch out--this is a color resetter
					direction = directionFace;
					directionFace = -1; //After you've recovered from being hit, stopp resetting the direction
									//*NOTE* Override directionFace if the player is in the middle of text
				}
			}
		}
		
		public function drown():void
		{
			drownTimer = (drownTimer - 0.5 + drownTimerMax) % drownTimerMax;
			v.x = Math.cos(drownTimer / drownTimerMax * 2 * Math.PI);
			v.y = Math.sin(drownTimer / drownTimerMax * 2 * Math.PI) * 2;
			dying = true;
			if (drownTimer <= 0)
			{
				//x = lastPosition.x;
				//y = lastPosition.y;
				//(FP.world as Game).playerPosition = new Point(Math.floor(x/Tile.w)*Tile.w, Math.floor(y/Tile.h)*Tile.h); 
				die();
			}
		}
		
		public function checkDrowning():void
		{
			if (drowning)
			{
				drown();
			}
			else
			{
				var v:int = 0;
				if (state == 1 && !canSwim /*Water*/)
				{
					v = 1;
				}
				else if (state == 17 && !hasDarkSuit /*Lava*/)
				{
					v = 2;
				}
				if (v > 0)
				{
					if (v == 2)
					{
						hit(null, 0, null, 0);
					}
					if (drownTimer <= 0)
					{
						drownTimer = drownTimerMax;
					}
					else
					{
						drownTimer--;
						if (drownTimer <= 0)
						{
							drownTimer = 0;
							drowning = true;
						}
					}
				}
			}
		}
		
		public function die():void
		{
			dying = true;
			(FP.world as Game).restartLevel();
		}
		
		public function knockback(f:Number=0, p:Point=null):void
		{
			if (p)
			{				
				//If the player is bumped, make him face the direction he's facing until input
				if (hitsTimer > 0)
				{
					directionFace = direction;
				}
				var center:Point = new Point(x - p.x, y - p.y);
				center.normalize(1);
				if (Math.abs(center.x) >= 0.5)
				{
					v.x += f * center.x;
				}
				if (Math.abs(center.y) > 0.5)
				{
					v.y += f * center.y;
				}
			}
		}
		
		override public function input():void
		{
			if(Preloader.sponsorVersion)
				extraInputs();
			
			
			if (!receiveInput || frozenTimer > 0 || fallFromCeiling)
			{
				return;
			}
			const accel:Number = moveSpeed;
			if (hitsTimer <= 0)
			{
				if (Input.check(keys[1]))
				{
					if (v.y > -moveSpeed)
					{
						v.y -= accel;
					}
				}
				if (Input.check(keys[0]))
				{
					if (v.x < moveSpeed)
					{
						v.x += accel;
					}
				}
				if (Input.check(keys[3]))
				{
					if (v.y < moveSpeed)
					{
						v.y += accel;
					}
				}
				if (Input.check(keys[2]))
				{
					if (v.x > -moveSpeed)
					{
						v.x -= accel;
					}
				}
			}
			if (onWaterfall && (!hasFeather || v.y >= 0))
			{
				v.y += waterfallAcceleration;
			}
			if (Input.pressed(keys[4]))
			{
				useItem(Main.primary);
			}
			if (Input.pressed(keys[5]))
			{
				useItem(Main.secondary);
			}
			if (Input.pressed(Key.W))
			{
				new GetURL("http://rekcahdam.bandcamp.com/album/seedling-ost");
			}
		}
		
		public function useItem(i:int):void
		{
			switch(Inventory.getItem(i))
			{
				case 0:
				case 4:
					if (slashDelay <= 0)
					{
						slashing = true;
					}
					break;
				case 1:
					if (!firing)
					{
						firing = true;
					}
					break;
				case 2:
					if (!wanding)
					{
						wanding = true;
					}
					break;
				case 5:
					if (!wanding)
					{
						wanding = true;
					}
					if (!firing)
					{
						firing = true;
					}
					break;
				case 3:
					if (!spearing)
					{
						spearing = true;
					}
				default:
			}
		}
		
		public function sprites():void
		{
			slashingSprite.update();
			sprSpear.update();
			sprWand.update();
			sprDeathRay.update();
			sprFire.update();
			sprFireWand.update();
			if (directionFace >= 0)
			{
				direction = directionFace;
			}
			else
			{
				if (v.x < 0)
				{
					direction = 2;
				}
				else if (v.x > 0)
				{
					direction = 0;
				}	
				else if (v.y < 0)
				{
					direction = 1;
				}
				else if (v.y > 0)
				{
					direction = 3;
				}
			}
			
			switch(direction)
			{
				case 0:
					myLightPosition = new Point( -6, -5); break;
				case 1:
					myLightPosition = new Point(0, 5); break;
				case 2:
					myLightPosition = new Point(6, -5); break;
				case 3:
					myLightPosition = new Point(0, -6); break;
				default:
					myLightPosition = new Point();
			}
			
			if (sprShrumDark.currentAnim == "dead" || sprShrumDark.currentAnim == "die")
			{
				return;
			}
			if ((v.x != 0 && directionFace != 1 && directionFace != 3) || directionFace == 0 || directionFace == 2)
			{
				(graphic as Spritemap).play(states[state] + "side-walk");
			}
			else if ((v.y < 0 && directionFace != 3) || directionFace == 1)
			{
				(graphic as Spritemap).play(states[state] + "up-walk");
			}
			else if (v.y > 0 || directionFace == 3)
			{
				(graphic as Spritemap).play(states[state] + "down-walk");
			}
			
			if ((v.x == 0 && v.y == 0) || Game.freezeObjects)
			{
				switch(direction)
				{
					case 1: (graphic as Spritemap).play(states[state] + "up-stand"); break;
					case 3: (graphic as Spritemap).play(states[state] + "down-stand"); break;
					default: (graphic as Spritemap).play(states[state] + "side-stand");
				}
			}
		}
		
		public function shieldBump():void
		{
			if (shieldObj && v.length > 0)
			{
				var c_s_pos:Vector.<Entity> = new Vector.<Entity>();
				shieldObj.collideTypesInto(enemies, shieldObj.x, shieldObj.y, c_s_pos);
				for each (var o:Enemy in c_s_pos)
				{
					if (hasDarkShield && o.hitsTimer <= 0) //Hit enemy if he's not already hit, so that he'll at least bounce
					{
						o.hit(shieldForce, new Point(x, y), darkShieldDamage, "Shield");
					}
					else
					{
						o.knockback(shieldForce, new Point(x, y));
					}
				}
			}
		}
		
		public static function hasAllTotemParts():Boolean
		{
			for (var i:int = 0; i < totemParts; i++)
			{
				if (!hasTotemPart(i))
				{
					return false;
				}
			}
			return true;
		}
		
		override public function moveX(_xrel:Number):Entity
		{
			for (var i:int = 0; i < Math.abs(_xrel); i++)
			{
				var d:Number = Math.min(1, (Math.abs(_xrel) - i)) * FP.sign(_xrel);
				var c_s:Entity = null;
				if (shieldObj)
				{
					c_s = null;// shieldObj.collideTypes(enemies, shieldObj.x + d, shieldObj.y);
				}
				var c:Entity = collideTypes(solids, x + d, y);
				if (!c && (!c_s || hitsTimer > 0))
				{
					x += d;
				}
				else
				{
					if(c)
					{
						return c;
					}
					else
					{
						return c_s;
					}
				}
			}
			return null;
		}
		
		override public function moveY(_yrel:Number):Entity
		{
			for (var i:int = 0; i < Math.abs(_yrel); i++)
			{
				var d:Number = Math.min(1, Math.abs(_yrel) - i) * FP.sign(_yrel);
				var c_s:Entity = null;
				if (shieldObj)
				{
					c_s = null;// shieldObj.collideTypes(enemies, shieldObj.x, shieldObj.y + d);
				}
				var c:Entity = collideTypes(solids, x, y + d);
				if (!c && (!c_s || hitsTimer > 0))
				{
					y += d;
				}
				else
				{
					if(c)
					{
						return c;
					}
					else
					{
						return c_s;
					}
				}
			}
			return null;
		}
		
		public function extraInputs():void
		{
			/* 
			 * For the love of god, please make sure you remove this.
			*/
			
			/*if (Input.released(Key.T))
			{
				Main.printItems();
			}
			if (Input.released(Key.E))
			{
				//FP.world = new Game(68, 16, 64); //Health
				//FP.world = new Game(30, 64, 128); //Lighting the Path
				//FP.world = new Game(19, 16, 144); //Fall of the Shieldspire
				//FP.world = new Game(32, 72, 128); //Fall of Time
				//FP.world = new Game(40, 400, 432); //Fall of the Totem
				//FP.world = new Game(56, 96, 32); //Fall of the Tentacled Beast
				//FP.world = new Game(69, 32, 32); //Fall of the Lights
				//FP.world = new Game(71, 208, 224); //Fall of the King of Fire
				//FP.world = new Game(111, 128, 64); //Fall of the Owl
				//FP.world = new Game(113, 64, 80); //Bloody
				//FP.world = new Game(11, 32, 64);// 115, 64, 128); //Bloodless
			}*/
			
			
			
			if (Input.released(Key.DIGIT_1))
			{
				Main.clearSave();
				Main.primary = Main.secondary = 0;
				hasSword = hasFire = hasShield = hasWand = hasDarkSword = hasDarkShield = hasDarkSuit = canSwim = hasFeather = hasSpear = hasFireWand = hasGhostSword = hasTorch = Main.beam = Main.rockSet = false;
				
				hasTotemPartSet(0, false);
				hasTotemPartSet(1, false);
				hasTotemPartSet(2, false);
				hasTotemPartSet(3, false);
				hasTotemPartSet(4, false);
				
				hasKeySet(0, false);
				hasKeySet(1, false);
				hasKeySet(2, false);
				hasKeySet(3, false);
				hasKeySet(4, false);
				FP.world = new Game(2, 48, 32);
			}
			else if (Input.released(Key.DIGIT_2))
			{
				Main.clearSave();
				Main.primary = Main.secondary = 0;
				hasSword = true;
				hasFire = hasShield = hasWand = hasDarkSword = hasDarkShield = hasDarkSuit = canSwim = hasFeather = hasSpear = hasFireWand = hasGhostSword = hasTorch = Main.beam = Main.rockSet = false;
				
				hasTotemPartSet(0, false);
				hasTotemPartSet(1, false);
				hasTotemPartSet(2, false);
				hasTotemPartSet(3, false);
				hasTotemPartSet(4, false);
				
				hasKeySet(0, false);
				hasKeySet(1, false);
				hasKeySet(2, false);
				hasKeySet(3, false);
				hasKeySet(4, false);
				FP.world = new Game(13, 64, 128);
			}
			else if (Input.released(Key.DIGIT_3))
			{
				Main.clearSave();
				Main.primary = Main.secondary = 0;
				hasSword = hasShield = true;
				hasFire = hasWand = hasDarkSword = hasDarkShield = hasDarkSuit = canSwim = hasFeather = hasSpear = hasFireWand = hasGhostSword = hasTorch = Main.beam = false;
				Main.rockSet = true;
				
				hasTotemPartSet(0, false);
				hasTotemPartSet(1, false);
				hasTotemPartSet(2, false);
				hasTotemPartSet(3, false);
				hasTotemPartSet(4, false);
				
				hasKeySet(0, true);
				hasKeySet(1, false);
				hasKeySet(2, false);
				hasKeySet(3, false);
				hasKeySet(4, false);
				FP.world = new Game(12, 576, 624);
			}
			else if (Input.released(Key.DIGIT_4))
			{
				Main.clearSave();
				Main.primary = Main.secondary = 0;
				hasSword = hasShield = hasFire = hasTorch = true;
				hasWand = hasDarkSword = hasDarkShield = hasDarkSuit = canSwim = hasFeather = hasSpear = hasFireWand = hasGhostSword = Main.beam = false;
				Main.rockSet = true;
				
				hasTotemPartSet(0, false);
				hasTotemPartSet(1, false);
				hasTotemPartSet(2, false);
				hasTotemPartSet(3, false);
				hasTotemPartSet(4, false);
				
				hasKeySet(0, true);
				hasKeySet(1, true);
				hasKeySet(2, false);
				hasKeySet(3, false);
				hasKeySet(4, false);
				FP.world = new Game(37, 288, 176);
			}
			else if (Input.released(Key.DIGIT_5))
			{
				Main.clearSave();
				Main.primary = Main.secondary = 0;
				Inventory.help = false;
				hasSword = hasShield = hasFire = hasTorch = hasWand = true;
				hasDarkSword = hasDarkShield = hasDarkSuit = canSwim = hasFeather = hasSpear = hasFireWand = hasGhostSword = Main.beam = false;
				Main.rockSet = true;
				
				hasTotemPartSet(0, true);
				hasTotemPartSet(1, true);
				hasTotemPartSet(2, true);
				hasTotemPartSet(3, true);
				hasTotemPartSet(4, true);
				
				hasKeySet(0, true);
				hasKeySet(1, true);
				hasKeySet(2, true);
				hasKeySet(3, false);
				hasKeySet(4, false);
				FP.world = new Game(45, 112, 288);
			}
			else if (Input.released(Key.DIGIT_6))
			{
				Main.clearSave();
				Main.primary = Main.secondary = 0;
				Inventory.help = false;
				hasSword = hasShield = hasFire = hasTorch = hasWand = canSwim = true;
				hasDarkSword = hasDarkShield = hasDarkSuit = hasFeather = hasSpear = hasFireWand = hasGhostSword = Main.beam = false;
				Main.rockSet = true;
				
				hasTotemPartSet(0, true);
				hasTotemPartSet(1, true);
				hasTotemPartSet(2, true);
				hasTotemPartSet(3, true);
				hasTotemPartSet(4, true);
				
				hasKeySet(0, true);
				hasKeySet(1, true);
				hasKeySet(2, true);
				hasKeySet(3, true);
				hasKeySet(4, false);
				FP.world = new Game(95, 560, 80);
			}
			else if (Input.released(Key.DIGIT_7))
			{
				Main.clearSave();
				Main.primary = Main.secondary = 0;
				Inventory.help = false;
				hasSword = hasShield = hasFire = hasTorch = hasWand = canSwim = hasSpear = true;
				hasDarkSword = hasDarkShield = hasDarkSuit = hasFeather = hasFireWand = hasGhostSword = Main.beam = false;
				Main.rockSet = true;
				
				hasTotemPartSet(0, true);
				hasTotemPartSet(1, true);
				hasTotemPartSet(2, true);
				hasTotemPartSet(3, true);
				hasTotemPartSet(4, true);
				
				hasKeySet(0, true);
				hasKeySet(1, true);
				hasKeySet(2, true);
				hasKeySet(3, true);
				hasKeySet(4, true);
				FP.world = new Game(12, 32, 896);
			}
			else if (Input.released(Key.DIGIT_8))
			{
				Main.clearSave();
				Main.primary = Main.secondary = 0;
				Inventory.help = false;
				hasSword = hasShield = hasFire = hasTorch = hasWand = canSwim = hasSpear = hasDarkShield = hasDarkSuit = hasFeather = true;
				hasDarkSword = hasFireWand = hasGhostSword = Main.beam = false;
				Main.rockSet = true;
				
				hasTotemPartSet(0, true);
				hasTotemPartSet(1, true);
				hasTotemPartSet(2, true);
				hasTotemPartSet(3, true);
				hasTotemPartSet(4, true);
				
				hasKeySet(0, true);
				hasKeySet(1, true);
				hasKeySet(2, true);
				hasKeySet(3, true);
				hasKeySet(4, true);
				FP.world = new Game(93, 112, 256);
			}
			else if (Input.released(Key.DIGIT_9))
			{
				Main.clearSave();
				Main.primary = Main.secondary = 0;
				Inventory.help = false;
				hasSword = hasShield = hasFire = hasTorch = hasWand = canSwim = hasSpear = hasDarkShield = hasDarkSuit = hasFeather = hasFireWand = hasGhostSword = true;
				hasDarkSword = Main.beam = false;
				Main.rockSet = true;
				
				hasTotemPartSet(0, true);
				hasTotemPartSet(1, true);
				hasTotemPartSet(2, true);
				hasTotemPartSet(3, true);
				hasTotemPartSet(4, true);
				
				hasKeySet(0, true);
				hasKeySet(1, true);
				hasKeySet(2, true);
				hasKeySet(3, true);
				hasKeySet(4, true);
				FP.world = new Game(110, 64, 48);
			}
		}
	}

}