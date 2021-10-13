package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class LavaTrap extends Enemy
	{
		[Embed(source = "../../assets/graphics/LavaTrap.png")] private var imgLavaTrap:Class;
		private var sprLavaTrap:Spritemap = new Spritemap(imgLavaTrap, 16, 16, endAnim);
		[Embed(source = "../../assets/graphics/LavaTrapTongue.png")] private var imgLavaTrapTongue:Class;
		private var sprLavaTrapTongue:Spritemap = new Spritemap(imgLavaTrapTongue, 32, 6, tongueOut);
		
		private const chompAnimSpeed:int = 10;
		private const tongueAnimSpeed:int = 30;
		private const chompRange:int = 32; // The distance at which the lava trap will launch its tongue.
		
		private const tongueLengths:Array = new Array(32, 29, 22, 15, 10, 7);
		private var tongueAngle:Number = 0;
		private var attached:Player;
		private var wait:Boolean = true;
		
		public function LavaTrap(_x:int, _y:int) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprLavaTrap);
			
			sprLavaTrap.centerOO();
			//the animation "" will reset it to the world frame speed
			sprLavaTrap.add("chomp", [2], chompAnimSpeed);
			sprLavaTrap.add("die", [3, 4, 5, 6, 7, 8], chompAnimSpeed);
			sprLavaTrap.play("");
			
			sprLavaTrapTongue.add("out", [5, 2, 0], tongueAnimSpeed);
			sprLavaTrapTongue.add("in", [0, 1, 2, 3, 4, 5], tongueAnimSpeed);
			sprLavaTrapTongue.originY = sprLavaTrapTongue.height / 2;
			sprLavaTrapTongue.y = -sprLavaTrapTongue.originY;
			
			setHitbox(10, 10, 5, 5);
			
			layer = -(y - originY + height * 4 / 5);
		}
		
		override public function update():void
		{
			super.update();
			if (sprLavaTrap.currentAnim == "die")
			{
				return;
			}
			sprLavaTrapTongue.update();
			if (attached)
			{
				var ind:int = getTongueLength();
				attached.x = x + tongueLengths[ind] * Math.cos(tongueAngle);
				attached.y = y + tongueLengths[ind] * Math.sin(tongueAngle);
				attached.onGround = false;
				if (ind >= tongueLengths.length-1)
				{
					if (Player.hasDarkSuit)
					{
						attached.onGround = true;
						attached = null;
						wait = true;
					}
					else
					{
						attached.die();
					}
				}
			}
			else
			{
				var player:Player = FP.world.nearestToEntity("Player", this) as Player;
				if (player)
				{
					var d:int = FP.distance(x, y, player.x, player.y);
					if (d <= chompRange && !wait)
					{
						if (sprLavaTrap.currentAnim == "")
						{
							tongueAngle = Math.atan2(player.y - y, player.x - x);
						}
						if(!FP.world.collideLine("Solid", x, y, player.x, player.y) && sprLavaTrap.currentAnim != "chomp")
						{
							launch();
							Music.playSoundDistPlayer(x, y, "Enemy Attack", 3);
							sprLavaTrap.play("chomp");
						}
						else
						{
							sprLavaTrap.play("");
						}
					}
					else
					{
						if (d > chompRange)
						{
							wait = false;
						}
						sprLavaTrap.play("");
					}
				}
				else
				{
					sprLavaTrap.play("");
				}
				if (sprLavaTrap.currentAnim == "")
				{
					sprLavaTrap.frame = Game.worldFrame(2);
				}
			}
		}
		
		override public function startDeath(t:String=""):void
		{
			sprLavaTrap.play("die");
		}
		
		override public function render():void
		{
			super.render();
			if (sprLavaTrapTongue.currentAnim != "")
			{
				var ind:int = getTongueLength();
				sprLavaTrapTongue.angle = tongueAngle * FP.DEG;
				sprLavaTrapTongue.render(new Point(x, y), FP.camera);
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				sprLavaTrapTongue.render(new Point(x, y), FP.camera);
				Draw.resetTarget();
			}
		}
		
		private function launch():void
		{
			if (sprLavaTrapTongue.currentAnim == "")
			{
				sprLavaTrapTongue.play("out");
			}
			var ind:int = getTongueLength();
			var pHit:Player = FP.world.collideLine("Player", x, y, x + tongueLengths[ind] * Math.cos(tongueAngle), y + tongueLengths[ind] * Math.sin(tongueAngle)) as Player;
			if (pHit)
			{
				attached = pHit;
			}
		}
		
		public function getTongueLength():int
		{
			return sprLavaTrapTongue.frame / sprLavaTrapTongue.frameCount * tongueLengths.length;
		}
		
		override public function layering():void{}
		override public function knockback(f:Number = 0, p:Point = null):void{}
		override public function hitPlayer():void{}
		
		public function endAnim():void
		{
			switch(sprLavaTrap.currentAnim)
			{
				case "die":
					FP.world.remove(this);
					break;
				default:
			}
		}
		
		public function tongueOut():void
		{
			switch(sprLavaTrapTongue.currentAnim)
			{
				case "out":
					sprLavaTrapTongue.play("in");
					break;
				default:
					sprLavaTrapTongue.play("");
					sprLavaTrap.play("");
			}
		}
		
	}

}