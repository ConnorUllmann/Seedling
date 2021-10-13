package Pickups
{
	import flash.geom.Point;
	import net.flashpunk.Graphic;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import NPCs.NPC;
	/**
	 * ...
	 * @author Time
	 */
	public class Pickup extends Mobile
	{
		protected var attract:Boolean;
		private const attractDistance:int = 24;
		private const motionDampener:int = 20; //The divisor for how much the object will accelerate toward the player
		private const minAttraction:Number = 0.3;
		private const minSpeedToPlayer:int = 2;
		
		private const specialOffset:Point = new Point(0, -5);
		private const specialTimerMax:int = 150;
		
		public var playerHit:Player;
		public var special:Boolean = false;
		public var specialTimer:int = specialTimerMax;
		
		private const DEF_TEXT_SPEED:int = 6;
		public var myText:NPC;
		public var text:String = ""; //Won't display text if the string is ""
									 //Won't display text if the pickup isn't special
									 
		private var stopped:Boolean = true;
		
		public var mySound:Sfx = Music.sndOFoundIt;
		public var myVolume:Number = 0.5;
		
		public function Pickup(_x:int, _y:int, _g:Graphic=null, _v:Point=null, _attract:Boolean=true) 
		{
			super(_x, _y, _g);
			if (_v)
			{
				v = _v;
				stopped = false;
			}
			attract = _attract;
		}
		
		
		override public function update():void
		{
			if (v.length <= 0)
			{
				stopped = true;
			}
			
			if (special && specialTimer < specialTimerMax) //Timer is going
			{
				pick_up();
			}
			else
			{
				var player:Player = FP.world.nearestToPoint("Player", x, y) as Player;
				if (player && !player.fallFromCeiling)
				{
					if (attract && stopped)
					{
						var d:Number = FP.distance(x, y, player.x, player.y);
						if (d <= attractDistance)
						{
							var attraction:Point = new Point((player.x - x) / motionDampener, (player.y - y) / motionDampener);
							attraction.normalize(Math.max(attraction.length, minAttraction));
							v.x += attraction.x;
							v.y += attraction.y;
							v.normalize(Math.min(v.length, minSpeedToPlayer));
						}
					}
					playerHit = collide("Player", x, y) as Player;
					if (playerHit)
					{
						Music.abruptThenFade(mySound, myVolume);
						pick_up();
						return;
					}
				}
				super.update();
			}
		}
		
		public function pick_up():void
		{
			var player:Player = FP.world.nearestToPoint("Player", x, y) as Player;
			if (special && player)
			{
				Game.freezeObjects = true;
				if (specialTimer > 0)
				{
					specialTimer--;
					if (specialTimer <= 0 && text != "")
					{
						FP.world.add(myText = new NPC(x, y, null, -1, text, DEF_TEXT_SPEED, 32));
						myText.setTemp(this);
						Game.ALIGN = "CENTER";
					}
				}
				else if(!myText)
				{
					Game.freezeObjects = false;
					player.directionFace = -1;
					Game.ALIGN = "LEFT";
					removeSelf();
					return;
				}
				x = player.x + specialOffset.x;
				var offY:int = Math.min(height - originY, (graphic as Image).height - (graphic as Image).originY);
				y = player.y - player.originY - offY + specialOffset.y * Math.min(2 * (1 - specialTimer / specialTimerMax), 1);
				player.directionFace = 3;
				layer = -FP.height;
			}
			else
			{
				removeSelf();
			}
		}
		
		public function removeSelf():void
		{
			FP.world.remove(this);
		}
		
	}

}