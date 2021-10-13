package Enemies 
{
	import net.flashpunk.Entity;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import Scenery.LightBossTotem;
	import Scenery.Tile;
	import NPCs.NPC;
	/**
	 * ...
	 * @author Time
	 */
	public class LightBossController extends Entity
	{
		private static const moveDiv:int = 10;
		private static var flierNumber:int;
		private static var spinCenter:Point;
		
		private var tag:int;
		
		private var spin:Number = 0;
		private var spinRate:Number = FP.RAD;
		private var radiusCircle:int = 100;
		private const radiusCircleMin:int = 48;
		private const radiusCircleMax:int = 64;
		private const radiusCircleFrames:int = 180;
		private const loopsPerCircle:int = 4;
		
		private const states:int = 3;
		private var state:int = 0; //just circle the enemies, pulsing in and out
		private var myFliers:Vector.<LightBoss> = new Vector.<LightBoss>();
		
		private var madeFliers:Boolean = false;
		private var myTotem:LightBossTotem;
		public var myText:NPC;
		private const text:String = "HOW FAR YOU HAVE COME, BEING OF THE LIGHT.~OUR OWN LIGHT WILL SWALLOW YOU. COME, MEET YOUR FATE.";
		
		public function LightBossController(_x:int, _y:int, _flierNum:int, _tag:int=-1) 
		{
			super();
			
			tag = _tag;
			x = _x;
			y = _y;
			flierNumber = _flierNum;
		}
		
		override public function check():void
		{
			if (Game.checkPersistence(tag))
			{
				spinCenter = new Point(x + Tile.w / 2, y + Tile.h / 2);
				FP.world.add(myText = new NPC(x, y, null, -1, text, 4, 34));
				myText.align = "CENTER";
				myText.setTemp(this, true, false, true);
				FP.world.add(myTotem = new LightBossTotem(x, y));
			}
			else
			{
				endState();
				FP.world.remove(this);
			}
		}
		
		override public function update():void
		{
			if (!Game.freezeObjects)
			{
				if (madeFliers && (FP.world as Game).totalEnemies() <= 0 && !myTotem.die)
				{
					myTotem.die = true;
					endState();
					Main.unlockMedal(Main.badges[10]);
				}
				if(!myText && !madeFliers)
				{
					while (myFliers.length < flierNumber)
					{
						myFliers.push(new LightBoss(spinCenter.x, -32, myFliers.length, this));
						FP.world.add(myFliers[myFliers.length - 1]);
					}
					madeFliers = true;
					Game.levelMusics[(FP.world as Game).level] = Game.bossMusic;
				}
				super.update();
				switch(state)
				{
				case 0: 
					flyCircle();
					break;
				case 1:
					flyCircleInvert();
					break;
				case 2:
					flyCircleDouble();
					break;
				default:
				}
			}
		}
		
		public function endState():void
		{
			FP.world.add(new Teleporter(x, y, 36, 112, 96, true));
			Game.levelMusics[(FP.world as Game).level] = -1;
			Game.setPersistence(tag, false);
		}
		
		public function flyCircle():void
		{
			var cFrame:int = Game.worldFrame(radiusCircleFrames, loopsPerCircle);
			radiusCircle = radiusCircleMin + (radiusCircleMax - radiusCircleMin) * (Math.sin(cFrame / radiusCircleFrames * 2 * Math.PI) + 1) / 2;
			for (var i:int = 0; i < myFliers.length; i++)
			{
				var a:Number = i / myFliers.length * 2 * Math.PI + spin;
				myFliers[i].goto = new Point(spinCenter.x + radiusCircle * Math.cos(a), spinCenter.y + radiusCircle * Math.sin(a));
				if (cFrame == Math.floor(radiusCircleFrames * 3 / 4) || 
					cFrame == Math.floor(radiusCircleFrames / 2) || 
					cFrame == Math.floor(radiusCircleFrames / 4) || 
					cFrame == 0)
				{
					myFliers[i].shoot();
				}
			}
			spin += spinRate * (2 - (radiusCircle - radiusCircleMin) / (radiusCircleMax - radiusCircleMin));
		}
		public function flyCircleInvert():void
		{
			var cFrame:int = Game.worldFrame(radiusCircleFrames, loopsPerCircle);
			radiusCircle = radiusCircleMin + (radiusCircleMax - radiusCircleMin) * (Math.sin(cFrame / radiusCircleFrames * 2 * Math.PI) + 1) / 2;
			for (var i:int = 0; i < myFliers.length; i++)
			{
				var a:Number = i / myFliers.length * 2 * Math.PI + spin;
				if (i % 2 == 0)
				{
					myFliers[i].goto = new Point(spinCenter.x + radiusCircle / 2 * Math.cos(a), spinCenter.y + radiusCircle / 2 * Math.sin(a));
				}
				else
				{
					myFliers[i].goto = new Point(spinCenter.x + radiusCircle * Math.cos(a), spinCenter.y + radiusCircle * Math.sin(a));
				}
				if (cFrame == Math.floor(radiusCircleFrames * 3 / 4) || 
					cFrame == Math.floor(radiusCircleFrames / 2) || 
					cFrame == Math.floor(radiusCircleFrames / 4) || 
					cFrame == 0)
				{
					myFliers[i].shoot();
				}
			}
			spin += spinRate * (2 - (radiusCircle - radiusCircleMin) / (radiusCircleMax - radiusCircleMin));
		}
		
		public function flyCircleDouble():void
		{
			var cFrame:int = Game.worldFrame(radiusCircleFrames, loopsPerCircle);
			radiusCircle = radiusCircleMin + (radiusCircleMax - radiusCircleMin) * (Math.sin(cFrame / radiusCircleFrames * 2 * Math.PI) + 1) / 2;
			for (var i:int = 0; i < myFliers.length; i++)
			{
				var a:Number = i / myFliers.length * 2 * Math.PI + spin;
				if (i % 2 == 0)
				{
					a = i / myFliers.length * 2 * Math.PI + spin*2;
				}
				myFliers[i].goto = new Point(spinCenter.x + radiusCircle * Math.cos(a), spinCenter.y + radiusCircle * Math.sin(a));
				if (cFrame == Math.floor(radiusCircleFrames * 5 / 6) || 
					cFrame == Math.floor(radiusCircleFrames * 2 / 3) || 
					cFrame == Math.floor(radiusCircleFrames / 2) || 
					cFrame == Math.floor(radiusCircleFrames / 3) ||
					cFrame == Math.floor(radiusCircleFrames / 6) || 
					cFrame == 0)
				{
					myFliers[i].shoot();
				}
			}
			spin += spinRate * (2 - (radiusCircle - radiusCircleMin) / (radiusCircleMax - radiusCircleMin));
		}
		
		public function removeFlier(_id:int):void
		{
			if (_id >= 0 && _id < myFliers.length)
			{
				myFliers.splice(_id, 1);
				for (var i:int = _id; i < myFliers.length; i++)
				{
					myFliers[i].id--;
				}
				state = Math.min(state + 1, states - 1);
			}
		}
		
	}

}