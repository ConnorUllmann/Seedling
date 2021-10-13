package Enemies 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import Pickups.Wand;
	import flash.display.BlendMode;
	import Projectiles.BossTotemShot;
	/**
	 * ...
	 * @author Time
	 */
	public class BossTotem extends Enemy
	{
		[Embed(source = "../../assets/graphics/BossTotem.png")] private var imgBossTotem:Class;
		private var sprBossTotem:Spritemap = new Spritemap(imgBossTotem, 32, 48);
		
		//General rules for arrays: arms then legs.
		//"Pos" constants are points for the positions of arms and legs relative to the head depending
		//on the frame of the animation.
		private const headBase:Point = new Point();
		private const headRestingAng:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0);
		private const headRestingPos:Array = new Array(
												new Point(0, 0),
												new Point(0, 0),
												new Point(0, 1),
												new Point(0, 1),
												new Point(0, 2),
												new Point(0, 1),
												new Point(0, 1),
												new Point(0, 0));
		private const headWalkingAng:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0);
		private const headWalkingPos:Array = new Array(
												new Point(0, 0),
												new Point(0, 1),
												new Point(0, 2),
												new Point(0, 3),
												new Point(0, 4),
												new Point(0, 3),
												new Point(0, 2),
												new Point(0, 1));
		private const headJumpingAng:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0);
		private const headJumpingPos:Array = new Array(
												new Point(0, 0),
												new Point(0, -1),
												new Point(0, -2),
												new Point(0, -3),
												new Point(0, -4),
												new Point(0, -5),
												new Point(0, -6),
												new Point(0, -7));
		private const headAttacksAng:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0);
		private const headAttacksPos:Array = new Array(
												new Point(0, 0),
												new Point(0, 1),
												new Point(0, 1),
												new Point(0, 2),
												new Point(0, 2),
												new Point(0, 4),
												new Point(0, 4),
												new Point(0, 8),
												new Point(0, 6),
												new Point(0, 4),
												new Point(0, 2),
												new Point(0, 1),
												new Point(0, 1),
												new Point(0, 0));
		
		private const armsBase:Point = new Point(23, 0);
		private const armsRestingAng:Array = new Array(0, 2, 4, 8, 9, 8, 4, 2);
		private static const armsRestingPos:Array = new Array(
												new Point(0, 0), 
												new Point(0, 1), 
												new Point(0, 2), 
												new Point(0, 4),
												new Point(0, 5),
												new Point(0, 4),
												new Point(0, 2),
												new Point(0, 1));
		private const armsWalkingAng:Array = new Array(0, 2, 4, 8, 9, 8, 4, 2);
		private const armsWalkingPos:Array = new Array(
												new Point(0, 0), 
												new Point(1, 1), 
												new Point(1, 2), 
												new Point(2, 4),
												new Point(2, 5),
												new Point(1, 4),
												new Point(1, 2),
												new Point(0, 1));
		private const armsJumpingAng:Array = new Array(0, 3, 6, 9, 12, 15, 18, 21, 24);
		private const armsJumpingPos:Array = new Array(
												new Point(0, 0), 
												new Point(-2, -1), 
												new Point(-6, -2), 
												new Point(-10, -4),
												new Point(-13, -5),
												new Point(-16, -6),
												new Point(-18, -7),
												new Point(-18, -8));
		/*private const armsAttacksAng:Array = new Array(0, 5, 10, 15, 20, 25, 31, 38, 31, 25, 20, 15, 10, 5);
		private const armsAttacksPos:Array = new Array(
												new Point(0, 0),
												new Point(-1, 4),
												new Point(-3, 9),
												new Point(-6, 13),
												new Point(-10, 17),
												new Point(-11, 30),
												new Point(-12, 40),
												new Point(-14, 44),
												new Point(-12, 40),
												new Point(-11, 30),
												new Point(-10, 20),
												new Point(-6, 13),
												new Point(-3, 9),
												new Point(-1, 4));*/
		private const armsAttacksAng:Array = new Array(0, 5, 10,10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 5);
		private const armsAttacksPos:Array = new Array(
												new Point(0, 0),
												new Point(-1, 4),
												new Point(-1, 9),
												new Point(-1, 13),
												new Point(-1, 17),
												new Point(-1, 30),
												new Point(-1, 40),
												new Point(-1, 44),
												new Point(-1, 40),
												new Point(-1, 30),
												new Point(-1, 20),
												new Point(-1, 13),
												new Point(-1, 9),
												new Point(-1, 4));
		
		private const legsBase:Point = new Point(6, 16);
		private const legsRestingAng:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0);
		private const legsRestingPos:Array = new Array(
												new Point(0, 0),
												new Point(0, 0),
												new Point(1, 0),
												new Point(1, 0),
												new Point(1, 0),
												new Point(1, 0),
												new Point(0, 0),
												new Point(0, 0));
		private const legsWalkingAng:Array = new Array(0, -5, -10, -5, 0, -5, -10, -5);
		private const legsWalkingPos:Array = new Array(
												new Point(0, 0),
												new Point(0, 2),
												new Point(1, 4),
												new Point(1, 2),
												new Point(1, 0),
												new Point(1, -2),
												new Point(1, -4),
												new Point(0, -2));
		private const legsJumpingAng:Array = new Array(0, -1, -2, -3, -4, -5, -6, -7, -8);
		private const legsJumpingPos:Array = new Array(
												new Point(0, 0),
												new Point(1, 0),
												new Point(2, 0),
												new Point(3, 0),
												new Point(4, 0),
												new Point(5, 0),
												new Point(6, 0),
												new Point(7, 0));
		private const legsAttacksAng:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
		private const legsAttacksPos:Array = new Array(
												new Point(0, 0),
												new Point(1, 0),
												new Point(1, 0),
												new Point(1, 0),
												new Point(2, 0),
												new Point(2, 0),
												new Point(1, 0),
												new Point(0, 0),
												new Point(0, 0),
												new Point(0, 0),
												new Point(0, 0),
												new Point(0, 0),
												new Point(0, 0),
												new Point(0, 0));
		private const headOrigin:Point = new Point(16, 47);
		private var bodyAng:int = 0; //Rotates all body components.
		
		private var headPos:Point = new Point;
		private var laserPos:Point = new Point( -8, -11);
		private const laserWidthDef:int = 6;
		private const laserColDef:uint = 0xFFFFFF;
		private const laserColHit:uint = 0xFF0000;
		private const laserColMax:uint = 0xFFFF00;
		private var laserWidth:Number = laserWidthDef;
		private var laserCol:uint = laserColDef;
		
		private const shootFrame:int = 7;
		private var shot:Boolean = false;
		
		private const playerPosSet:Point = new Point(144, 352);
												
		//Number of frames per animation.
		private var animate:Boolean = true; //Whether or not the animations for all of the body parts will proceed
		private var animateFrames:Object = new Object();
		private const animateRate:Object = new Object();
		
		private var currentFrame:Number = 0;
		private var currentAnimation:String = "rest";
		
		private var _state:int = 0; //0 = resting, 1 = walking, 2 = attacking, 3 = jumping, 4 = special
		private var stateAnimations:Array = new Array("rest", "walk", "attack", "jump", "special");
		
		private const attackDistance:int = 60;
		private const maxYPosition:int = 352; //maxYPosition is the location at which the boss will teleport back to the top.
		private var startY:int = 0;
		
		private const rumbleDistMax:int = 3;
		private const rumbleAngleMax:int = 20;
		private const rumblingTimeMax:int = 240;
		private var rumblingTime:int = rumblingTimeMax;
		public var activated:Boolean = false;
		private var activationRate:Number = 0.02;
		public var activationStage:Number = 0;
		public var fullyActivated:Boolean = false;
		private const bodyAngMax:int = 10; // The rotation of the body components.
		private const activationRestTimeMax:int = 120;
		public var activationRestTime:int = activationRestTimeMax;
		
		private var rate:Number = 0; //a scale for the boss's movement and animation speed.
		private const rateRate:Number = 0.025;
		
		private const force:int = 10;
		
		private const laserHitTimeMax:int = 15;
		private var laserHitTime:int = 0;
		
		private const waitAtTopTimeMax:int = 30;
		private var waitAtTopTime:int = 0;
		
		private var tag:int;
		private var doActions:Boolean = true;
		
		private var playedSound:Boolean = false;
		
		public function BossTotem(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x, _y, sprBossTotem);
			startY = _y;
			
			animateFrames["attack"] = 14;
			animateFrames["rest"] = 8;
			animateFrames["walk"] = 8;
			animateFrames["jump"] = 8;
			
			animateRate["attack"] = 0.3;
			animateRate["rest"] = 0.1;
			animateRate["walk"] = 0.2;
			animateRate["jump"] = 0.5;
			setHitbox(80, 32, 40, -12);
			
			activeOffScreen = true;
			hitsMax = 5;
			hitsTimerMax = 20;
			onlyHitBy = "Wand";
			
			tag = _tag;
			
			hitSoundIndex = 1; //Big hit sound
			
			dieSound = "Boss Die";
			dieSoundIndex = 0;
		}
		
		override public function update():void
		{
			if (destroy)
			{
				return;
			}
			
			var p:Player = FP.world.nearestToPoint("Player", x, y) as Player;
			if (p && fullyActivated)
			{
				if (p.y < y - originY + height)
				{
					p.y = y - originY + height;
				}
			}
			if (FP.world.classCount(Wand) <= 0 && !activated)
			{
				activated = true;
				Music.playSound("Other", 0);
				Game.levelMusics[(FP.world as Game).level] = Game.bossMusic;
				(FP.world as Game).playerPosition = playerPosSet.clone();
			}
			if (activated)
			{
				type = "Enemy";
				super.update();
				if (rumblingTime > 0)
				{
					rumblingTime--;
				}
				if (rumblingTime <= rumblingTimeMax / 2 && activationStage < 1)
				{
					const n:int = 8;
					activationStage += activationRate * (n-1)/n * Math.sin(activationStage * Math.PI) + activationRate / n;
					if (activationStage >= 1)
					{
						activationStage = 1;
						fullyActivated = true;
					}
				}
			}
			else
			{
				type = "Solid";
			}
			if (waitAtTopTime > 0)
			{
				waitAtTopTime--;
			}
			else if (fullyActivated && !Game.freezeObjects)
			{
				if(activationRestTime > 0)
				{
					activationRestTime--;
				}
				else
				{
					if (rate < 1)
					{
						rate = Math.min(rate + rateRate, 1);
					}
					if (p)
					{
						if (state == 3)
						{
							v.y = -5 * rate;
							collidable = false;
							laserWidth = laserWidthDef;
							laserCol = laserColDef;
							laserHitTime = 0;
							if (currentFrame + animateRate[currentAnimation] * rate >= animateFrames[currentAnimation])
							{
								currentFrame = animateFrames[currentAnimation] - 1;
								animate = false;
							}
							if (y <= startY - 32)
							{
								y = startY - 32;
								v.y = 0;
								state = 0;
								waitAtTopTime = waitAtTopTimeMax;
							}
						}
						else if (state == 2)
						{
							animate = true;
							collidable = true;
							v.y = 0;
							if (Math.floor(currentFrame) == shootFrame && !shot)
							{
								shot = true;
								var shotPosition:Point = new Point(30, 75);
								var shotSpeed:Point = new Point(0, 2);
								Music.playSound("Enemy Attack", 2, 0.2);
								FP.world.add(new BossTotemShot(x + shotPosition.x, y + shotPosition.y, shotSpeed));
								FP.world.add(new BossTotemShot(x - shotPosition.x, y + shotPosition.y, new Point(-shotSpeed.x, shotSpeed.y)));
								
							}
							if (currentFrame + animateRate[currentAnimation] * rate >= animateFrames[currentAnimation])
							{
								state = 1;
							}
						}
						else
						{
							shot = false;
							animate = true;
							collidable = true;
							state = 1; //walk
							v.y = rate;
							laserStep();
							
							if (Math.floor(currentFrame) == 2 || Math.floor(currentFrame) == 6)
							{
								if(!playedSound)
								{
									playedSound = true;
									Music.playSound("Other", 1);
								}
							}
							else
								playedSound = false;
							if (y - originY + height >= maxYPosition)
							{
								state = 3;
							}
						}
					}
					if (animate)
					{
						currentFrame = (currentFrame + animateRate[currentAnimation] * rate) % animateFrames[currentAnimation];
					}
				}
			}
			if (p && (Math.abs(y - p.y) <= FP.screen.height * 3 / 4 && Math.abs(x - p.x) <= FP.screen.width * 3 / 4))
			{
				Game.cameraTarget = new Point((x + p.x)/2 - FP.screen.width/2, (y + p.y) / 2 - FP.screen.height/2);
			}
			else
			{
				Game.resetCamera();
			}
		}
		
		public function laserStep():void
		{
			if (laserWidth < laserWidthDef*2)
			{
				const divisor:int = 4;
				const minIncrease:Number = 0.01;
				laserWidth+=Math.max((laserWidth-laserWidthDef)/laserWidthDef/divisor, minIncrease);
				laserCol = FP.colorLerp(laserColDef, laserColHit, (laserWidth - laserWidthDef) / laserWidthDef / 2 + 0.5);
			}
			else
			{
				if (laserHitTime > 0)
				{
					laserHitTime--;
					if (laserHitTime <= 0)
					{
						laserWidth = laserWidthDef;
						laserCol = laserColDef;
						state = 2; //attack
						v.y = 0;
					}
				}
				else					
				{
					laserWidth = laserWidthDef * 3;
					laserHitTime = laserHitTimeMax;
					
					laserCol = laserColMax;
					var players:Vector.<Player> = new Vector.<Player>();
					var rect:Rectangle = getLaserRect(1, headPos, laserPos);
					FP.world.collideRectInto("Player", rect.x, rect.y, rect.width, rect.height, players);
					rect = getLaserRect( -1, headPos, laserPos);
					FP.world.collideRectInto("Player", rect.x, rect.y, rect.width, rect.height, players);
					hitPlayers(players);
					Game.shake = laserHitTimeMax * 2;
					Music.playSound("Enemy Attack", 0, 0.15);
					Music.playSound("Enemy Attack", 1, 0.15);
				}
			}
		}
		
		override public function check():void
		{
			super.check();
			if (tag >= 0 && !Game.checkPersistence(tag))
			{
				doActions = false;
				FP.world.remove(this);
			}
		}
		
		override public function removed():void
		{
			super.removed();
			if (doActions)
			{
				Game.resetCamera();
				(FP.world as Game).undrawCover();
				Music.playSound("Boss Die", 1, 0.8);
				Game.levelMusics[(FP.world as Game).level] = -1;
				Main.unlockMedal(Main.badges[6]);
				Game.shake = 60;
				Game.setPersistence(tag, false);
			}
		}
		
		public function hitPlayers(p:Vector.<Player>):void
		{
			for each(var player:Player in p)
			{
				player.hit(null, force, new Point(player.x, y), damage);
			}
		}
		
		public function set state(i:int):void
		{
			_state = i;
			changeAnimation(stateAnimations[state]);
		}
		
		public function get state():int
		{
			return _state;
		}
		
		override public function render():void
		{
			const frame:int = Math.floor(currentFrame);
			const frameUp:int = Math.ceil(currentFrame) % animateFrames[currentAnimation];
			var armsPos:Point = new Point();
			var armsAng:int = 0;
			headPos = new Point();
			var headAng:int = 0;
			var legsPos:Point = new Point();
			var legsAng:int = 0;
			
			const defLegsPos:Point = new Point(12, -8);
			const defLegsAng:int = 45;
			const defArmsPos:Point = new Point(-20, 4);
			const defArmsAng:int = -45;
			const defHeadPos:Point = new Point(0, 36);
			const defHeadAng:int = 0;
			
			switch(currentAnimation)
			{
				case "attack":
					armsPos = armsAttacksPos[frameUp].clone().add(armsAttacksPos[frame].clone());
					armsPos.normalize(armsPos.length / 2);
					armsAng = (armsAttacksAng[frameUp] + armsAttacksAng[frame]) / 2;
					headPos = headAttacksPos[frameUp].clone().add(headAttacksPos[frame].clone());
					headPos.normalize(headPos.length / 2);
					headAng = (headAttacksAng[frameUp] + headAttacksAng[frame]) / 2;
					legsPos = legsAttacksPos[frameUp].clone().add(legsAttacksPos[frame].clone());
					legsPos.normalize(legsPos.length / 2);
					legsAng = (legsAttacksAng[frameUp] + legsAttacksAng[frame]) / 2;
					break;
				case "rest":
					armsPos = armsRestingPos[frameUp].clone().add(armsRestingPos[frame].clone());
					armsPos.normalize(armsPos.length / 2);
					armsAng = (armsRestingAng[frameUp] + armsRestingAng[frame]) / 2;
					headPos = headRestingPos[frameUp].clone().add(headRestingPos[frame].clone());
					headPos.normalize(headPos.length / 2);
					headAng = (headRestingAng[frameUp] + headRestingAng[frame]) / 2;
					legsPos = legsRestingPos[frameUp].clone().add(legsRestingPos[frame].clone());
					legsPos.normalize(legsPos.length / 2);
					legsAng = (legsRestingAng[frameUp] + legsRestingAng[frame]) / 2;
					break;
				case "walk":
					armsPos = armsWalkingPos[frameUp].clone().add(armsWalkingPos[frame].clone());
					armsPos.normalize(armsPos.length / 2);
					armsAng = (armsWalkingAng[frameUp] + armsWalkingAng[frame]) / 2;
					headPos = headWalkingPos[frameUp].clone().add(headWalkingPos[frame].clone());
					headPos.normalize(headPos.length / 2);
					headAng = (headWalkingAng[frameUp] + headWalkingAng[frame]) / 2;
					legsPos = legsWalkingPos[frameUp].clone().add(legsWalkingPos[frame].clone());
					legsPos.normalize(legsPos.length / 2);
					legsAng = (legsWalkingAng[frameUp] + legsWalkingAng[frame]) / 2;
					break;
				case "jump":
					armsPos = armsJumpingPos[frameUp].clone().add(armsJumpingPos[frame].clone());
					armsPos.normalize(armsPos.length / 2);
					armsAng = (armsJumpingAng[frameUp] + armsJumpingAng[frame]) / 2;
					headPos = headJumpingPos[frameUp].clone().add(headJumpingPos[frame].clone());
					headPos.normalize(headPos.length / 2);
					headAng = (headJumpingAng[frameUp] + headJumpingAng[frame]) / 2;
					legsPos = legsJumpingPos[frameUp].clone().add(legsJumpingPos[frame].clone());
					legsPos.normalize(legsPos.length / 2);
					legsAng = (legsJumpingAng[frameUp] + legsJumpingAng[frame]) / 2;
					break;
				default:
					armsPos = armsRestingPos[0].clone();
					armsAng = 0;
					headPos = headRestingPos[0].clone();
					headAng = 0;
					legsPos = legsRestingPos[0].clone();
					legsAng = 0;
			}
			if (destroy)
			{
				rumblingTime++;
				(FP.world as Game).drawCover(0xFFFFFF, rumblingTime / rumblingTimeMax * 2);
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				Draw.rect(FP.camera.x, FP.camera.y, FP.screen.width, FP.screen.height, 0xFFFFFF, rumblingTime / rumblingTimeMax * 2);
				Draw.resetTarget();
				if (rumblingTime >= rumblingTimeMax)
				{
					FP.world.remove(this);
				}
			}
			const val:Number = activationStage;
			const rumble:Number = (1 - Math.cos(rumblingTime / rumblingTimeMax * 2 * Math.PI)) / 2;
			const rumbleRandAngle:Number = Math.random() * rumble * rumbleAngleMax;
			const rumbleRandDist:Number =  (Math.random() - 0.5) * rumbleDistMax * rumble;
			armsPos.x = (armsPos.x - defArmsPos.x) * val + defArmsPos.x + rumbleRandDist;
			armsPos.y = (armsPos.y - defArmsPos.y) * val + defArmsPos.y + rumbleRandDist;
			armsAng = (armsAng - defArmsAng) * val + defArmsAng + rumbleRandAngle;
			headPos.x = (headPos.x - defHeadPos.x) * val + defHeadPos.x + rumbleRandDist;
			headPos.y = (headPos.y - defHeadPos.y) * val + defHeadPos.y + rumbleRandDist;
			headAng = (headAng - defHeadAng) * val + defHeadAng + rumbleRandAngle;
			legsPos.x = (legsPos.x - defLegsPos.x) * val + defLegsPos.x + rumbleRandDist;
			legsPos.y = (legsPos.y - defLegsPos.y) * val + defLegsPos.y + rumbleRandDist;
			legsAng = (legsAng - defLegsAng) * val + defLegsAng + rumbleRandAngle;
			bodyAng = bodyAngMax * (1 - val);
			
			//Legs
			sprBossTotem.frame = 2;
			setOrigin(sprBossTotem,  new Point(0, 0));
			sprBossTotem.angle = legsAng + bodyAng;
			renderPart(new Point(x - legsPos.x + legsBase.x * sprBossTotem.scaleX, y + legsPos.y + legsBase.y));
			sprBossTotem.scaleX = -Math.abs(sprBossTotem.scaleX);
			sprBossTotem.angle = -legsAng + bodyAng;
			renderPart(new Point(x + legsPos.x + legsBase.x * sprBossTotem.scaleX, y - legsPos.y + legsBase.y));
			sprBossTotem.scaleX = Math.abs(sprBossTotem.scaleX);
			sprBossTotem.angle = 0;
			
			//Arms
			sprBossTotem.frame = 1;
			setOrigin(sprBossTotem, new Point(armsBase.x * sprBossTotem.scaleX, 0));
			sprBossTotem.angle = armsAng + bodyAng;
			renderPart(new Point(x - armsPos.x - armsBase.x * sprBossTotem.scaleX, y + armsPos.y + armsBase.y));
			sprBossTotem.scaleX = -Math.abs(sprBossTotem.scaleX);
			sprBossTotem.angle = -armsAng + bodyAng;
			renderPart(new Point(x + armsPos.x - armsBase.x * sprBossTotem.scaleX, y + armsPos.y + armsBase.y));
			sprBossTotem.scaleX = Math.abs(sprBossTotem.scaleX);
			sprBossTotem.angle = 0;
			
			//Head
			if (activated)
			{
				sprBossTotem.color = laserCol;
				
				sprBossTotem.frame = 0;
				setOrigin(sprBossTotem, headOrigin);
				sprBossTotem.angle = headAng;
				if (activationStage < 1)
				{
					sprBossTotem.alpha = activationStage;
				}
				renderPart(new Point(x + headPos.x, y + headPos.y));
				sprBossTotem.alpha = 1;
				sprBossTotem.angle = 0;
				
				sprBossTotem.color = 0xFFFFFF;
			}
			
			//Laser
			if (activated && headAng == 0)
			{				
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				var rect:Rectangle = getLaserRect(1, headPos, laserPos);
				Draw.rect(rect.x, rect.y, rect.width, rect.height, laserCol, activationStage);
				rect = getLaserRect( -1, headPos, laserPos);
				Draw.rect(rect.x, rect.y, rect.width, rect.height, laserCol, activationStage);
				Draw.resetTarget();
			}
		}
		
		public function getLaserRect(dir:int, headPos:Point, laserPos:Point):Rectangle
		{
			var laserStart:Point = new Point(headPos.x + laserPos.x, headPos.y + laserPos.y);
			var laserTo:Point = new Point();
			for (var i:int = 0; i < FP.width; i += 1)
			{
				laserTo = new Point(laserStart.x, laserStart.y + i);
				if (FP.world.collideRect("Solid", x + laserTo.x*dir - int(dir<0)*laserWidth, y + laserTo.y, laserWidth, 1))
				{
					break;
				}
			}
			return new Rectangle(x + laserStart.x*dir - laserWidth / 2, y + laserStart.y, laserTo.x - laserStart.x + laserWidth, laserTo.y - laserStart.y);
		}
		
		public function renderPart(renderPos:Point):void
		{
			graphic = sprBossTotem;
			var temp:Point = new Point(x, y);
			x = renderPos.x;
			y = renderPos.y;
			
			const r:Number = 0.1;
			(graphic as Image).blend = BlendMode.SCREEN;
			(graphic as Image).scale += r;
			
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			var tempAlpha:Number = (graphic as Image).alpha;
			if (activationStage < 1)
			{
				(graphic as Image).alpha = activationStage;
			}
			super.render();
			(graphic as Image).alpha = tempAlpha;
			Draw.resetTarget();
			
			(graphic as Image).blend = BlendMode.NORMAL;
			(graphic as Image).scale -= r;
			
			super.render();
			
			x = temp.x;
			y = temp.y;
		}
		
		public function setOrigin(_s:Image, _p:Point):void
		{
			_s.originX = _p.x;
			_s.originY = _p.y;
			_s.x = -_s.originX;
			_s.y = -_s.originY;
		}
		
		public function changeAnimation(str:String, restart:Boolean = false):void
		{
			if (currentAnimation != str || restart)
			{
				currentFrame = 0;
			}
			currentAnimation = str;
		}
		
		override public function hit(f:Number=0, p:Point=null, d:Number=1, t:String=""):void
		{
			if (fullyActivated && activationRestTime <= 0)
			{
				super.hit(f, p, d, t);
			}
		}
		
		override public function knockback(f:Number = 0, p:Point = null):void { }
		
	}

}