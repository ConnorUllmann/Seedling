package NPCs 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	import Pickups.Seed;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class Watcher extends NPC
	{
		[Embed(source = "../../assets/graphics/NPCs/Watcher.png")] private var imgWatcher:Class;
		private var sprWatcher:Spritemap = new Spritemap(imgWatcher, 12, 15);
		[Embed(source = "../../assets/graphics/NPCs/WatcherPic.png")] private var imgWatcherPic:Class;
		private var sprWatcherPic:Image = new Image(imgWatcherPic);
		
		private const seedIndexMin:int = 9; //The minimum index of talking at which the seed is shown
		private const seedIndexMax:int = 19; //The maximum index of talking at which the seed is shown
		private const seedFrame:int = 6; //The frame of the animation where he holds out the seed.
		private const normalFrames:int = 6;
		private const dieFrames:Object = [7, 8, 9];
		
		private var hits:int = 0;
		private const hitsTimerMax:int = 25;
		private var hitsTimer:int = 0;
		
		private var seed:Seed;
		private var createdSeed:Boolean = false; //For the final seed
		
		private var text:String;
		private var text1:String;
		
		public function Watcher(_x:int, _y:int, _tag:int=-1, _text:String="", _text1:String = "", _talkingSpeed:int=4) 
		{
			super(_x, _y, sprWatcher, _tag, Game.checkPersistence(_tag) ? _text : _text1, _talkingSpeed);
			text = _text;
			text1 = _text1;
			
			myPic = sprWatcherPic;
			facePlayer = false;
			keyNeeded = !Game.checkPersistence(tag);
			
			type = "Watcher";
			setHitbox(16, 16, 8, 8);
		}
		
		override public function check():void
		{
		}
		/*
			if (tag1 >= 0 && !Game.checkPersistence(tag1))
			{
				FP.world.remove(this);
			}
		}*/
		
		override public function update():void
		{
			if (Game.checkPersistence(tag))
			{
				super.update();
			}
			if (text != "" && talking && Game.checkPersistence(tag) && myCurrentText >= seedIndexMin && myCurrentText <= seedIndexMax)
			{
				sprWatcher.frame = seedFrame;
				if (!seed)
				{
					FP.world.add(seed = new Seed(x - 18, y - 8, false));
				}
			}
			else
			{
				var p:Player = FP.world.nearestToEntity("Player", this) as Player;
				if (p)
				{
					sprWatcher.frame = ((Math.atan2(y - p.y, p.x - x) + 2 * Math.PI) / (2 * Math.PI) * normalFrames + normalFrames) % normalFrames;
				}
				if (seed)
				{
					seed.destroySilently();
					seed = null;
				}
			}
			if (hitsTimer > 0)
			{
				hitsTimer--;
			}
			if (hits > 0)
			{
				if (hits > dieFrames.length)
				{
					if (!createdSeed)
					{
						p = FP.world.nearestToEntity("Player", this) as Player;
						if (p)
						{
							FP.world.add(new Seed(p.x - 8, p.y - 8, true, "The seed, covered in the blood of the Watcher, seems almost to cower from your grasp.~This was supposed to be a triumph..."));
							createdSeed = true;
						}
					}
					sprWatcher.frame = sprWatcher.frameCount - 1;
				}
				else
				{
					sprWatcher.frame = dieFrames[hits - 1];
				}
			}
			text == "" ? layer = -(y + Tile.h*8) : layer = -(y-originY+height*2/3);
			visible = Player.hasShield;
		}
		
		public function hit():void
		{
			if (!Game.checkPersistence(tag) && hitsTimer <= 0 && text != "")
			{
				hits++;
				hitsTimer = hitsTimerMax;
			}
		}
		
		override public function doneTalking():void
		{
			super.doneTalking();
			if (Game.checkPersistence(tag))
			{
				Game.setPersistence(tag, false);
				//talked = false;
				//keyNeeded = !Game.checkPersistence(tag);			
				//prepNewText(text1);
			}
		}
		
	}

}