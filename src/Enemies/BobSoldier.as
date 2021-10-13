package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import Scenery.Tile;
	import Pickups.Coin;
	/**
	 * ...
	 * @author Time
	 */
	
	/*
	 *  The story of how Grace ******* came to michigan.
		The story about grace.  It's like two lines of code if you will.
		Fuck, I forgot how I was going to make fun of her.  I'll stop doing that.
		Can you get Tocata and Fuge on here?
		Eric ******... it was a tuesday, the 17th--friday the 13th was his birthday; OOOOH! Eric was walking the halls of his middle school when his geometry teacher came out--he was taking highschool geometry because he was advanced, but not at Andover, that fabled place.  He was a white person and Eric's parents didn't accept that a white man was teaching him.  Hear that? Racism.  Anyhow, there's this japanese 50 year old guy who looks pretty much like aqualung.  The weather isn't exactly ideal for his nose, and eric is learning geometry from him in a broom closet learning about 3d stuff, like cones and square prisms (as well as cylinders; and domes! HOHOHoooo)  It's going to be about ten years until he discovers porn, and fifteen until he sees a dick that he chooses to see.  Political?  He's going to see plenty of vaginas in his day.  and his girlfriends are going to ask if they are fat--have fat vaginas.  And so the teacher brought models, wooden ones.  But he says "oh I forgot my cylinders and domes!  SO I guess we're going to have to substitute."  So Eric has some trouble, so they try his finger and take measurements.  But Eric says that his finger is too small.  Problem with not using metric units--wrong conversion.  Anyways, so the teacher undid his belt, with that deadly clank (so nice in some situations).  And he pulled it down those hairless legs.  Uh.  To this day, Eric still remembers that it wasn't much bigger than his pinky finger--BUT IT WAS BIGGER!  measurable in inches... 1, 2... 2.25.  But anyways, Eric understood the sensation, as he felt it when he saw the men dancing on the television.  It has affected him to this very day.  Pre-med, anyone?
	*/
	public class BobSoldier extends Enemy
	{
		[Embed(source = "../../assets/graphics/LameSword.png")] private var imgLameSword:Class;
		private var sprLameSword:Spritemap = new Spritemap(imgLameSword, 16, 5);
		
		[Embed(source = "../../assets/graphics/BobSoldier.png")] private var imgBobSoldier:Class;
		private var sprBobSoldier:Spritemap = new Spritemap(imgBobSoldier, 10, 10, endAnim);
		
		public var moveSpeed:Number = 0.8;
		public var walkAnimSpeed:int = 10;
		public const walkFrames:Array = new Array(0, 1, 2, 1);
		private const runRange:int = 80; //Range at which the Bob will run after the character
		public const attackRange:int = 32; //Range at which the Bob will attack the character
		
		public var weapon:Spritemap;
		public var weaponLength:int = sprLameSword.width;
		
		public var swordSpinning:Boolean = false;
		public var swordIndex:int = 0;
		public var swords:int = 1;
		public var swordSpinBegin:Array = new Array(0, 0);
		public var swordSpin:Array = new Array(Math.PI * 3 / 2, Math.PI / 2, Math.PI, 0);
		public var swordSpinRate:Number = Math.PI / 10;
		public var swordSpinResetTimerMax:int = 60;
		public var swordSpinResetTimer:int = 0;
		
		public var hopSoundIndex:int = 0;
		
		public function BobSoldier(_x:int, _y:int, _g:Spritemap=null) 
		{
			if (!_g)
			{
				_g = sprBobSoldier;
			}
			super(_x + Tile.w/2, _y + Tile.h/2, _g);
			
			(graphic as Spritemap).centerOO();
			(graphic as Spritemap).add("walk", walkFrames, walkAnimSpeed, true);
			
			weapon = sprLameSword;
			sprLameSword.y = -3;
			sprLameSword.originY = -sprLameSword.y;
			
			setHitbox(8, 8, 4, 2);
		}
		
		override public function removed():void
		{
			//if(!fell) dropCoins();
		}
		
		override public function update():void
		{
			super.update();
			if (Game.freezeObjects)
				return;
			var player:Player = FP.world.nearestToPoint("Player", x, y) as Player;
			if (player)
			{
				playerActions(player);
			}
			swordSpinningStep(player);
			swordHitting();
			
			standingAnimation();
		}
		
		public function playerActions(player:Player):void
		{
			var d:Number = FP.distance(x, y, player.x, player.y);
			if (d <= runRange)// && !FP.world.collideLine("Solid", x, y, player.x, player.y))
			{
				var a:Number = Math.atan2(player.y - y, player.x - x);
				var toV:Point = new Point(moveSpeed * Math.cos(a), moveSpeed * Math.sin(a));
				var pushed:Boolean = v.length > moveSpeed; //If we're already moving faster than we should...
				v.x += FP.sign(toV.x - v.x) * moveSpeed;
				v.y += FP.sign(toV.y - v.y) * moveSpeed;
				if (!pushed && v.length > moveSpeed)
				{
					v.normalize(moveSpeed); //If we weren't moving to fast, and are now, then reset speed.
				}
				if((graphic as Spritemap).currentAnim != "walk")
				{
					Music.playSoundDistPlayer(x, y, "Enemy Hop", hopSoundIndex);
					(graphic as Spritemap).play("walk");
				}
			}
			swordSpinningBeginCheck(d);
		}
		
		public function swordSpinningBeginCheck(d:int=0):void
		{
			if (d <= attackRange)
			{
				if (!swordSpinning)
				{
					if (swordSpinResetTimer > 0)
					{
						swordSpinResetTimer--;
					}
					else
					{
						swordSpinningBegin();
					}
				}
			}
		}
		
		public function swordSpinningBegin():void
		{
			swordSpinResetTimer = swordSpinResetTimerMax;
			swordSpinning = true;
			swordSpin[swordIndex] = swordSpinBegin[swordIndex] = (swordSpin[swordIndex] + 2 * Math.PI) % (2 * Math.PI);
		}
		
		public function swordSpinningStep(player:Player):void
		{
			if (swordSpinning)
			{				
				swordSpin[swordIndex] += swordSpinRate;
				
				var ang:Number = ( -Math.atan2(player.y - y, player.x - x) + Math.PI * 2) % (Math.PI * 2);
				if (Math.abs(swordSpinBegin[swordIndex] - swordSpin[swordIndex]) >= Math.PI * 2)
				{
					if( Math.abs(FP.angle_difference((swordSpin[swordIndex] + 2 * Math.PI) % (2 * Math.PI), ang)) <= swordSpinRate)
					{
						swordSpinningStop(ang);
					}
				}
			}
		}
		
		public function swordSpinningStop(ang:Number=0):void
		{
			swordSpin[swordIndex] = ang;
			swordSpinning = false;
			swordIndex = (swordIndex + 1) % swords;
		}
		
		public function swordHitting():void
		{
			for (var i:int = 0; i < swords; i++)
			{
				var hitPlayer:Player = FP.world.collideLine("Player", x + weaponLength / 2 * Math.cos(-swordSpin[i]), y + weaponLength / 2 * Math.sin(-swordSpin[i]),
					x + weaponLength * Math.cos(-swordSpin[i]), y + weaponLength * Math.sin(-swordSpin[i])) as Player;
				if (hitPlayer)
				{
					hitPlayer.hit(this, 3 * damage, new Point(x, y), damage);
				}
			}
		}
		
		public function standingAnimation():void
		{
			if ((graphic as Spritemap).currentAnim == "")
			{
				(graphic as Spritemap).frame = walkFrames[Game.worldFrame(walkFrames.length)];
			}
		}
		
		public function endAnim():void
		{
			(graphic as Spritemap).play("");
		}
		
		override public function render():void
		{
			super.render();
			for (var i:int = 0; i < swords; i++)
			{
				(weapon as Image).alpha = (graphic as Spritemap).alpha;
				(weapon as Spritemap).angle = swordSpin[i] / Math.PI * 180;
				(weapon as Spritemap).render(new Point(x, y), FP.camera);
				//Draw.line(x + weaponLength / 2 * Math.cos(-swordSpin[i]), y + weaponLength / 2 * Math.sin(-swordSpin[i]),
				//	x + weaponLength * Math.cos(-swordSpin[i]), y + weaponLength * Math.sin(-swordSpin[i]));
			}
		}
		
	}

}