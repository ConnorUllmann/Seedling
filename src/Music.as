package  
{
	import flash.events.Event;
	import net.flashpunk.Sfx;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * ...
	 * @author Time
	 */
	public class Music 
	{
		[Embed(source = "../assets/sound/Sword1.mp3")] private static var sndSword1:Class;
		[Embed(source = "../assets/sound/Sword2.mp3")] private static var sndSword2:Class;
		[Embed(source = "../assets/sound/Sword3.mp3")] private static var sndSword3:Class;	
		[Embed(source = "../assets/sound/Unapproved/stab1.mp3")] private static var sndStab1:Class;
		[Embed(source = "../assets/sound/Unapproved/stab2.mp3")] private static var sndStab2:Class;
		[Embed(source = "../assets/sound/Unapproved/stab3.mp3")] private static var sndStab3:Class;
		[Embed(source = "../assets/sound/splash1.mp3")] private static var sndSplash1:Class;
		[Embed(source = "../assets/sound/splash2.mp3")] private static var sndSplash2:Class;
		[Embed(source = "../assets/sound/swim.mp3")] private static var sndSwim1:Class;
		[Embed(source = "../assets/sound/arrowLaunch.mp3")] private static var sndArrow1:Class;
		[Embed(source = "../assets/sound/arrowHit.mp3")] private static var sndArrow2:Class;
		[Embed(source = "../assets/sound/switch.mp3")] private static var sndSwitch1:Class;
		[Embed(source = "../assets/sound/smallEnemyHit.mp3")] private static var sndEnemyHit1:Class;
		[Embed(source = "../assets/sound/bigEnemyHit.mp3")] private static var sndEnemyHit2:Class;
		[Embed(source = "../assets/sound/metalHit.mp3")] private static var sndMetal1:Class;
		[Embed(source = "../assets/sound/enemyhop.mp3")] private static var sndEnemyHop1:Class;
		[Embed(source = "../assets/sound/bigenemyhop.mp3")] private static var sndEnemyHop2:Class;
		[Embed(source = "../assets/sound/chest.mp3")] private static var sndChest1:Class;
		[Embed(source = "../assets/sound/bigLock.mp3")] private static var sndLock1:Class;
		[Embed(source = "../assets/sound/BigRockHit.mp3")] private static var sndRock1:Class;
		[Embed(source = "../assets/sound/rockcrumble.mp3")] private static var sndRock2:Class;
		[Embed(source = "../assets/sound/drill.mp3")] private static var sndDrill1:Class;
		[Embed(source = "../assets/sound/energyBeam.mp3")] private static var sndEnergyBeam1:Class;
		[Embed(source = "../assets/sound/energyPulse.mp3")] private static var sndEnergyPulse1:Class;
		[Embed(source = "../assets/sound/explosion.mp3")] private static var sndExplosion1:Class;
		[Embed(source = "../assets/sound/enemyfall.mp3")] private static var sndEnemyFall1:Class;
		[Embed(source = "../assets/sound/pushrock.mp3")] private static var sndPushRock1:Class;
		[Embed(source = "../assets/sound/smallenemydie.mp3")] private static var sndEnemyDie1:Class;
		[Embed(source = "../assets/sound/nextroom.mp3")] private static var sndRoom1:Class;
		[Embed(source = "../assets/sound/upstairs.mp3")] private static var sndRoom2:Class;
		[Embed(source = "../assets/sound/downstairs.mp3")] private static var sndRoom3:Class;
		[Embed(source = "../assets/sound/Unapproved/teleport.mp3")] private static var sndRoom4:Class;
		[Embed(source = "../assets/sound/hurt.mp3")] private static var sndHurt1:Class;
		[Embed(source = "../assets/sound/groundhit.mp3")] private static var sndGroundHit1:Class;
		[Embed(source = "../assets/sound/groundhit2.mp3")] private static var sndGroundHit2:Class;
		[Embed(source = "../assets/sound/playerfall.mp3")] private static var sndPlayerFall1:Class;
		[Embed(source = "../assets/sound/Unapproved/boss4die.mp3")] private static var sndBossDie1:Class;
		[Embed(source = "../assets/sound/Unapproved/boss4die2.mp3")] private static var sndBossDie2:Class;
		[Embed(source = "../assets/sound/Unapproved/boss6die.mp3")] private static var sndBossDie3:Class;
		[Embed(source = "../assets/sound/Unapproved/boss5rise.mp3")] private static var sndBossDie4:Class;
		[Embed(source = "../assets/sound/Unapproved/boss5die.mp3")] private static var sndBossDie5:Class;
		[Embed(source = "../assets/sound/Unapproved/boss4beam.mp3")] private static var sndEnemyAttack1:Class;
		[Embed(source = "../assets/sound/Unapproved/boss4beam2.mp3")] private static var sndEnemyAttack2:Class;
		[Embed(source = "../assets/sound/Unapproved/boss4shoot.mp3")] private static var sndEnemyAttack3:Class;
		[Embed(source = "../assets/sound/Unapproved/enemyChomp.mp3")] private static var sndEnemyAttack4:Class;
		[Embed(source = "../assets/sound/Unapproved/boss6move.mp3")] private static var sndBoss6Move1:Class;
		[Embed(source = "../assets/sound/Unapproved/boss6move1.mp3")] private static var sndBoss6Move2:Class;
		[Embed(source = "../assets/sound/Unapproved/boss6move2.mp3")] private static var sndBoss6Move3:Class;
		[Embed(source = "../assets/sound/wandfire.mp3")] private static var sndWandFire1:Class;
		[Embed(source = "../assets/sound/wandfizzle.mp3")] private static var sndWandFizzle1:Class;
		[Embed(source = "../assets/sound/Unapproved/turretFire.mp3")] private static var sndTurretShoot1:Class;
		[Embed(source = "../assets/sound/wind.mp3")] private static var sndWind1:Class;
		[Embed(source = "../assets/sound/ArcticWind.mp3")] private static var sndWind2:Class;
		[Embed(source = "../assets/sound/TreeBurning.mp3")] private static var sndBurn1:Class;
		[Embed(source = "../assets/sound/punch.mp3")] private static var sndPunch1:Class;
		[Embed(source = "../assets/sound/monstersplash.mp3")] private static var sndTentacle1:Class;
		[Embed(source = "../assets/sound/fireattack.mp3")] private static var sndFire1:Class;
		[Embed(source = "../assets/sound/LavaPunch.mp3")] private static var sndLava1:Class;
		[Embed(source = "../assets/sound/LavaClap.mp3")] private static var sndLava2:Class;
		[Embed(source = "../assets/sound/Pop.mp3")] private static var sndLava3:Class;
		[Embed(source = "../assets/sound/Light.mp3")] private static var sndLight1:Class;
		[Embed(source = "../assets/sound/text.mp3")] private static var sndText1:Class;
		[Embed(source = "../assets/sound/Unapproved/textNext.mp3")] private static var sndText2:Class;
		[Embed(source = "../assets/sound/Unapproved/boss4start.mp3")] private static var sndOther1:Class;
		[Embed(source = "../assets/sound/Unapproved/boss4walk.mp3")] private static var sndOther2:Class;
		[Embed(source = "../assets/sound/Unapproved/turretIceFire.mp3")] private static var sndOther3:Class;
		[Embed(source = "../assets/sound/Unapproved/ropeCut.mp3")] private static var sndOther4:Class;
		[Embed(source = "../assets/sound/Unapproved/crusher.mp3")] private static var sndOther5:Class;
		
		private static var currentSet:String = "";
		private static var currentIndex:int = -1;
		
		private static var setNames:Vector.<String> = new Vector.<String>();
		private static var soundsO:Object = { };
		private static var soundSwords:Array = new Array(sndSword1, sndSword2, sndSword3);
		private static var soundStabs:Array = new Array(sndStab1, sndStab2, sndStab3);
		private static var soundSplash:Array = new Array(sndSplash1, sndSplash2);
		private static var soundSwim:Array = new Array(sndSwim1);
		private static var soundArrow:Array = new Array(sndArrow1, sndArrow2);
		private static var soundSwitch:Array = new Array(sndSwitch1);
		private static var soundDrill:Array = new Array(sndDrill1, sndDrill1);
		private static var soundEnemyHit:Array = new Array(sndEnemyHit1, sndEnemyHit2);
		private static var soundMetal:Array = new Array(sndMetal1);
		private static var soundEnemyHop:Array = new Array(sndEnemyHop1, sndEnemyHop2);
		private static var soundChest:Array = new Array(sndChest1);
		private static var soundRock:Array = new Array(sndRock1, sndRock2);
		private static var soundLock:Array = new Array(sndLock1);
		private static var soundEnergyBeam:Array = new Array(sndEnergyBeam1, sndEnergyBeam1, sndEnergyBeam1);
		private static var soundEnergyPulse:Array = new Array(sndEnergyPulse1, sndEnergyPulse1);
		private static var soundExplosion:Array = new Array(sndExplosion1, sndExplosion1, sndExplosion1);
		private static var soundEnemyFall:Array = new Array(sndEnemyFall1, sndEnemyFall1, sndEnemyFall1);
		private static var soundPushRock:Array = new Array(sndPushRock1);
		private static var soundEnemyDie:Array = new Array(sndEnemyDie1, sndEnemyDie1);
		private static var soundRoom:Array = new Array(sndRoom1, sndRoom2, sndRoom3, sndRoom4);
		private static var soundHurt:Array = new Array(sndHurt1);
		private static var soundGroundHit:Array = new Array(sndGroundHit1, sndGroundHit2);
		private static var soundPlayerFall:Array = new Array(sndPlayerFall1);
		private static var soundBossDie:Array = new Array(sndBossDie1, sndBossDie2, sndBossDie3, sndBossDie4, sndBossDie5);
		private static var soundEnemyAttack:Array = new Array(sndEnemyAttack1, sndEnemyAttack2, sndEnemyAttack3, sndEnemyAttack4);
		private static var soundBoss6Move:Array = new Array(sndBoss6Move1, sndBoss6Move2, sndBoss6Move3, sndBoss6Move1, sndBoss6Move2, sndBoss6Move3);
		private static var soundWandFire:Array = new Array(sndWandFire1, sndWandFire1);
		private static var soundWandFizzle:Array = new Array(sndWandFizzle1, sndWandFizzle1);
		private static var soundTurretShoot:Array = new Array(sndTurretShoot1, sndTurretShoot1, sndTurretShoot1);
		private static var soundWind:Array = new Array(sndWind1, sndWind2);
		private static var soundBurn:Array = new Array(sndBurn1);
		private static var soundPunch:Array = new Array(sndPunch1);
		private static var soundTentacle:Array = new Array(sndTentacle1, sndTentacle1, sndTentacle1, sndTentacle1);
		private static var soundFire:Array = new Array(sndFire1);
		private static var soundLava:Array = new Array(sndLava1, sndLava2, sndLava3);
		private static var soundLight:Array = new Array(sndLight1);
		private static var soundText:Array = new Array(sndText1, sndText2);
		private static var soundOther:Array = new Array(sndOther1, sndOther2, sndOther3, sndOther4, sndOther5);
		private static var sounds:Object = { "Sword":soundSwords, 
											 "Stab":soundStabs, 
											 "Splash":soundSplash, 
											 "Swim":soundSwim, 
											 "Arrow":soundArrow, 
											 "Switch":soundSwitch, 
											 "Drill":soundDrill,
											 "Enemy Hit":soundEnemyHit, 
											 "Metal Hit":soundMetal, 
							 				 "Enemy Hop":soundEnemyHop,
											 "Chest":soundChest,
											 "Rock":soundRock,
											 "Lock":soundLock,
											 "Energy Beam":soundEnergyBeam,
											 "Energy Pulse":soundEnergyPulse,
											 "Explosion":soundExplosion,
											 "Enemy Fall":soundEnemyFall,
											 "Push Rock":soundPushRock,
											 "Enemy Die":soundEnemyDie,
											 "Room":soundRoom,
											 "Hurt":soundHurt,
											 "Ground Hit":soundGroundHit,
											 "Player Fall":soundPlayerFall,
											 "Boss Die":soundBossDie,
											 "Enemy Attack":soundEnemyAttack,
											 "Boss 6 Move":soundBoss6Move,
											 "Wand Fire":soundWandFire,
											 "Wand Fizzle":soundWandFizzle,
											 "Turret Shoot":soundTurretShoot,
											 "Wind":soundWind,
											 "Burn":soundBurn,
											 "Punch":soundPunch,
											 "Tentacle":soundTentacle,
											 "Fire":soundFire,
											 "Lava":soundLava,
											 "Light":soundLight,
											 "Text":soundText,
											 "Other":soundOther};
		[Embed(source = "../assets/sound/Yes, Master.mp3")] private static var sndYesMaster:Class;
		public static var sndOYesMaster:Sfx = new Sfx(sndYesMaster);
		
		[Embed(source = "../assets/sound/Found It!.mp3")] private static var sndFoundIt:Class;
		public static var sndOFoundIt:Sfx = new Sfx(sndFoundIt);
		
		[Embed(source = "../assets/sound/One Piece.mp3")] private static var sndSealPiece:Class;
		public static var sndOSealPiece:Sfx = new Sfx(sndSealPiece);
		
		[Embed(source = "../assets/sound/Of The Puzzle.mp3")] private static var sndSeal:Class;
		public static var sndOSeal:Sfx = new Sfx(sndSeal);
		
		[Embed(source = "../assets/sound/The Key.mp3")] private static var sndKey:Class;
		public static var sndOKey:Sfx = new Sfx(sndKey);
		
		[Embed(source = "../assets/sound/In The Beginning.mp3")] private static var sndMenu:Class;
		public static var sndOMenu:Sfx = new Sfx(sndMenu);
		
		[Embed(source = "../assets/sound/A Warrior's Journey.mp3")] private static var sndTheme:Class;
		public static var sndOTheme:Sfx = new Sfx(sndTheme);
		
		[Embed(source = "../assets/sound/Warriors Don't Sleep.mp3")] private static var sndThemeNight:Class;
		public static var sndOThemeNight:Sfx = new Sfx(sndThemeNight);
		
		[Embed(source = "../assets/sound/My Life's Purpose.mp3")] private static var sndMyLifesPurpose:Class;
		public static var sndOMyLifesPurpose:Sfx = new Sfx(sndMyLifesPurpose);
		
		[Embed(source = "../assets/sound/The Watcher.mp3")] private static var sndTheWatcher:Class;
		public static var sndOTheWatcher:Sfx = new Sfx(sndTheWatcher);
		
		[Embed(source = "../assets/sound/My First Dungeon.mp3")] private static var sndMyFirstDungeon:Class;
		public static var sndOMyFirstDungeon:Sfx = new Sfx(sndMyFirstDungeon);
		
		[Embed(source = "../assets/sound/Stuck In The Forest.mp3")] private static var sndStuckInTheForest:Class;
		public static var sndOStuckInTheForest:Sfx = new Sfx(sndStuckInTheForest);
		
		[Embed(source = "../assets/sound/Mysterious Magic.mp3")] private static var sndMysteriousMagic:Class;
		public static var sndOMysteriousMagic:Sfx = new Sfx(sndMysteriousMagic);
		
		[Embed(source = "../assets/sound/Cold Blooded.mp3")] private static var sndColdBlooded:Class;
		public static var sndOColdBlooded:Sfx = new Sfx(sndColdBlooded);
		
		[Embed(source = "../assets/sound/How To Lose Your Shadow 101.mp3")] private static var sndShadow:Class;
		public static var sndOShadow:Sfx = new Sfx(sndShadow);
		
		[Embed(source = "../assets/sound/Lava Is Hot.mp3")] private static var sndLavaIsHot:Class;
		public static var sndOLavaIsHot:Sfx = new Sfx(sndLavaIsHot);
		
		[Embed(source = "../assets/sound/The Sky.mp3")] private static var sndTheSky:Class;
		public static var sndOTheSky:Sfx = new Sfx(sndTheSky);
		
		[Embed(source = "../assets/sound/Fight Me Like A Boss.mp3")] private static var sndBoss:Class;
		public static var sndOBoss:Sfx = new Sfx(sndBoss);
		
		public static var songs:Array = new Array(sndOTheme, sndOThemeNight, sndOMenu, sndOYesMaster, sndOMyLifesPurpose, 
			sndOTheWatcher, sndOMyFirstDungeon, sndOStuckInTheForest, sndOMysteriousMagic, sndOColdBlooded,
			sndOShadow, sndOLavaIsHot, sndOTheSky, sndOBoss);
		
		private static var overSong:Sfx; //The song that gets played over the background song on interruption
		private static var bkgdSong:Sfx; //The song that represents the currently playing background music
		private static var fadeSong:Sfx; //The song that represents the new song that will be played once the background music
										 //		fades out.
		public static var bkgdVolumeDefault:Number = 1; // Value 0-1 for the default volume of bkgdVolume
		public static var bkgdVolumeMaxExtern:Number = 1; // The maximum volume for the background music, as set by outside objects
		public static var bkgdVolumeMax:Number = 0.5; // The maximum volume for the background music
		private static var bkgdVolume:Number = 0; // Value that is used to set the background music's volume
		public static var fadeVolumeDefault:Number = 1; // Value 0-1 for the default volume of fadeVolume
		public static var fadeVolumeMaxExtern:Number = 1; // The maximum volume for the fade-in music, as set by outside objects
		private static var fadeVolumeMax:Number = 0.5; // The maximum volume for the fade-in music
		private static var fadeVolume:Number = 0; // Value that is used to set the fade-in music's volume
		
		private static var fadeRate:Number = 0;
		private static var crossover:Boolean = false;
		
		public function Music() 
		{
		}
		
		public static function begin():void //called by Main
		{
			for(var key:String in sounds)
			{
				setNames.push(key);
				soundsO[key] = {};
				for (var j:int = 0; j < sounds[key].length; j++)
				{
					soundsO[key][j] = new Sfx(sounds[key][j]);
				}
			}
		}
		
		public static function update():void //Updated in Main
		{
			if (bkgdSong && bkgdSong != fadeSong)
			{
				bkgdSong.volume = bkgdVolumeDefault;
				bkgdSong.volume *= bkgdVolumeMax;
				bkgdSong.volume *= bkgdVolumeMaxExtern;
				if (bkgdSong == sndOTheme)
				{
					sndOThemeNight.volume = 1 - bkgdVolumeDefault;
					sndOThemeNight.volume *= bkgdVolumeMax;
					sndOThemeNight.volume *= bkgdVolumeMaxExtern;
					/*if (sndOTheme._channel && sndOThemeNight._channel)
						FP.console.log(Math.floor(sndOTheme._channel.position * 1000) + ", " + Math.floor(sndOThemeNight._channel.position * 1000));*/
				}
				else if (bkgdSong == sndOMenu)
					bkgdSong.volume *= 1.5;
			}
			
			if (fadeSong)
			{
				fadeSong.volume = fadeVolumeDefault;
				fadeSong.volume *= fadeVolumeMax;
				fadeSong.volume *= fadeVolumeMaxExtern;
				if (fadeSong == sndOTheme)
				{
					sndOThemeNight.volume = 1 - fadeVolumeDefault;
					sndOThemeNight.volume *= fadeVolumeMax;
					sndOThemeNight.volume *= fadeVolumeMaxExtern;
				}
			}
			
			if (overSong) //If we have an oversong playing, turn off everything else.
			{
				bkgdVolume = 0;
				fadeVolume = 0;
			}
			
			if (fadeRate > 0)
			{
				if (bkgdSong && bkgdSong != fadeSong)
				{
					bkgdVolume -= fadeRate;
					if (bkgdVolume <= 0)
					{
						bkgdSong.stop();
						if (bkgdSong == sndOTheme)
							sndOThemeNight.stop();
					}
				}
				if (crossover ? true : (bkgdSong ? bkgdVolume <= 0 : true))
				{
					fadeVolume += fadeRate;
				}
				if (fadeVolume >= 1)
				{
					bkgdVolume = 1;
					fadeVolume = 0;
					fadeRate = 0;
					bkgdSong = fadeSong;
					fadeSong = null;
				}
			}
			
			if (bkgdSong && bkgdSong != fadeSong)
			{
				bkgdSong.volume *= bkgdVolume;
				if (bkgdSong == sndOTheme)
					sndOThemeNight.volume *= bkgdVolume;
			}
			
			if (fadeSong)
			{
				fadeSong.volume *= fadeVolume;
				if (fadeSong == sndOTheme)
					sndOThemeNight.volume *= fadeVolume;
			}
		}
		
		/**
		 * Stops all background music.
		 */
		public static function stop(over:Boolean=true, bkgd:Boolean=true, fade:Boolean=true):void
		{
			if (overSong && over)
			{
				overSong.stop();
				overSong = null;
			}
			if (bkgdSong && bkgd)
			{
				bkgdSong.stop();
				if (bkgdSong == sndOTheme)
					sndOThemeNight.stop();
				bkgdSong = null;
			}
			if (fadeSong && fade)
			{
				fadeSong.stop();
				if (fadeSong == sndOTheme)
					sndOThemeNight.stop();
				fadeSong = null;
			}
		}
		
		/**
		 * Only for interruption sounds--does not treat the new sound like a background sound.
		 * @param	s		The new sound to play
		 */
		public static function abruptThenFade(s:Sfx, vol:Number=1):void
		{
			//return; //So that sounds are off!
			if (bkgdSong)
				bkgdVolume = 0;
			if (overSong)
				overSong.stop();
			overSong = s;
			overSong.complete = fadeOnComplete;
			overSong.play(vol);
		}
		public static function fadeOnComplete():void
		{
			if(bkgdSong)
				fadeToLoop(bkgdSong);
			bkgdSong = overSong = null;
		}
		
		/**
		 * Stops the background music and plays the given Sfx
		 * @param	s		Sound to play
		 * @param	vol		Volume
		 * @param	pan		Pan
		 */
		public static function play(s:Sfx, vol:Number=1, pan:Number=0):void
		{
			//return; //So that sounds are off!
			if (bkgdSong)
			{
				bkgdSong.stop();
				if (bkgdSong == sndOTheme)
					sndOThemeNight.stop();
			}
			bkgdSong = s;
			bkgdSong.play(vol, pan);
			if (bkgdSong == sndOTheme)
				sndOThemeNight.play(vol, pan);
			bkgdVolume = vol;
		}
		/**
		 * Stops the background music and plays the given Sfx
		 * @param	s		Sound to loop
		 * @param	vol		Volume
		 * @param	pan		Pan
		 */
		public static function loop(s:Sfx, vol:Number=1, pan:Number=0):void
		{
			//return; //So that sounds are off!
			if (bkgdSong)
			{
				bkgdSong.stop();
				if (bkgdSong == sndOTheme)
					sndOThemeNight.stop();
			}
			bkgdSong = s;
			bkgdSong.loop(vol, pan);
			if (bkgdSong == sndOTheme)
				sndOThemeNight.loop(vol, pan);
			bkgdVolume = vol;
			
		}
		
		/**
		 * Fades from the backgroundMusic into snd1
		 * @param	snd1		The song to fade into
		 * @param	_rate		The speed to fade (0 stays on snd0, 1 goes immediately so snd1)
		 * @param	_crossover	Whether the songs will play at the same time while fading
		 */
		public static function fadeToLoop(snd1:Sfx=null, _rate:Number = 0.1, _crossover:Boolean = false):void
		{
			//return; //So that sounds are off!			
			if (_rate <= 0)
				return;				
			if (_rate >= 1)
			{
				loop(snd1);
				return;
			}
			
			if (fadeSong)
			{
				fadeSong.stop();
				if (fadeSong == sndOTheme)
					sndOThemeNight.stop();
			}
			fadeSong = snd1;
			if (fadeSong)
			{
				if (!fadeSong.playing)
				{
					fadeSong.play();
					if (fadeSong == sndOTheme)
						sndOThemeNight.play();
				}
				fadeSong.complete = playBKGD;
				fadeSong.volume = 0;
			}
			fadeVolume = 0;
			
			
			fadeRate = _rate;
			crossover = _crossover;
		}
		public static function playBKGD():void
		{
			play(bkgdSong);
		}
		
		/**
		 * Plays a sound from a set, such as "Swords", with index intInd (-1 picks a random sound from the set)
		 * @param	strInd	the set to play from
		 * @param	intInd	the index of the sound to play (-1 for random other than the one last played)
		 * @return	the sound that is played
		 */
		public static function playSound(strInd:String, intInd:int=-1, vol:Number=1, pan:Number=0):Sfx
		{
			var cplayIndex:int;
			if (intInd == -1)
			{
				do
				{
					cplayIndex = Math.floor(Math.random() * sounds[strInd].length)
				}
				while (cplayIndex == currentIndex && sounds[strInd].length > 1 &&  currentSet == strInd)
			}
			else
				cplayIndex = Math.min(Math.max(intInd, 0), sounds[strInd].length-1);
			currentSet = strInd;
			currentIndex = cplayIndex;
			soundsO[currentSet][currentIndex].play(vol, pan);
			return soundsO[currentSet][currentIndex];
		}
		
		/**
		 * Plays a sound from a set, such as "Swords", with index intInd (-1 picks a random sound from the set)
		 * @param	x			the x-position of the sound
		 * @param	y			the y-position of the sound
		 * @param	strInd		the set to play from
		 * @param	intInd		the index of the sound to play (-1 for random other than the one last played)
		 * @param	_distance	the distance from the sound at which the volume is zero
		 * @return	the sound that is played
		 */
		public static function playSoundDistPlayer(x:int, y:int, strInd:String, intInd:int=-1, _distance:int=80, volMax:Number=1):Sfx
		{
			var pan:Number = 0;
			var vol:Number = 1;
			var p:Player = FP.world.nearestToPoint("Player", x, y) as Player;
			if (p)
			{
				pan = Math.min(Math.max((x - p.x) / (FP.width / 2), -1), 1);
				vol = Math.max(1 - FP.distance(x, y, p.x, p.y) / _distance, 0);
			}
			vol *= volMax;
			return playSound(strInd, intInd, vol, pan);
		}
		
		/**
		 * Stops a sound from a set, such as "Swords", with index intInd (-1 stops all sounds in the set)
		 * @param	strInd	the set to stop from
		 * @param	intInd	the index of the sound to stop (-1 for all sounds in the set)
		 */
		public static function stopSound(strInd:String, intInd:int=-1):void
		{
			if (intInd == -1)
			{
				for (var i:int = 0; i < sounds[strInd].length; i++)
				{
					soundsO[strInd][i].stop();
				}
			}
			else
				soundsO[strInd][Math.min(Math.max(intInd, 0), sounds[strInd].length - 1)].stop();
		}
		
		/**
		 * Sets the volume of a sound from a set, such as "Swords", with index intInd (-1 sets all sounds in the set)
		 * @param	strInd	the set
		 * @param	intInd	the index of the sound to set the volume for (-1 for all sounds in the set)
		 */
		public static function volumeSound(strInd:String, intInd:int=-1, vol:Number=1):void
		{
			if (intInd == -1)
			{
				for (var i:int = 0; i < sounds[strInd].length; i++)
				{
					soundsO[strInd][i].volume = vol;
				}
			}
			else
				soundsO[strInd][Math.min(Math.max(intInd, 0), sounds[strInd].length - 1)].volume = vol;
		}
		
		/**
		 * Whether or not a sound in a set, or a particular sound, is playing
		 * @param	strInd	the sound set
		 * @param	intInd	the index of the sound (-1 is for the whole set)
		 * @return	whether or not a sound in the set is playing
		 */
		public static function soundIsPlaying(strInd:String, intInd:int = -1):Boolean
		{
			if (intInd == -1)
			{
				for (var i:int = 0; i < sounds[strInd].length; i++)
				{
					if (soundsO[strInd][i].playing)
						return true;
				}
				return false;
			}
			else
				return soundsO[strInd][Math.min(Math.max(intInd, 0), sounds[strInd].length - 1)].playing;
		}
		
		/**
		 * The (maximal) current position of any sound in a set (or a particular sound)
		 * @param	strInd	the sound set
		 * @param	intInd	the index of the sound (-1 is for the whole set)
		 * @return	the maximal position of a sound in the set
		 */
		public static function soundPosition(strInd:String, intInd:int = -1):Number
		{
			if (intInd == -1)
			{
				var soundPos:Number = 0;
				for (var i:int = 0; i < sounds[strInd].length; i++)
				{
					soundPos = Math.max(soundPos, soundsO[strInd][i].position);
				}
				return soundPos;
			}
			else
				return soundsO[strInd][Math.min(Math.max(intInd, 0), sounds[strInd].length - 1)].position;
		}
		
		/**
		 * The (maximal) current percentage position of any sound in a set (or a particular sound)
		 * @param	strInd	the sound set
		 * @param	intInd	the index of the sound (-1 is for the whole set)
		 * @return	the maximal percentage position of a sound in the set
		 */
		public static function soundPercentage(strInd:String, intInd:int = -1):Number
		{
			if (intInd == -1)
			{
				var soundPos:Number = 0;
				for (var i:int = 0; i < sounds[strInd].length; i++)
				{
					soundPos = Math.max(soundPos, soundsO[strInd][i].position / soundsO[strInd][i].length);
				}
				return soundPos;
			}
			else
				return soundsO[strInd][Math.min(Math.max(intInd, 0), sounds[strInd].length - 1)].position / soundsO[strInd][Math.min(Math.max(intInd, 0), sounds[strInd].length - 1)].length;
		}
		
		
	}

}