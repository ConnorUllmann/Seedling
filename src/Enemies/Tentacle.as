package Enemies 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Time
	 */
	public class Tentacle extends Enemy
	{
		[Embed(source = "../../assets/graphics/Tentacle.png")] private var imgTentacle:Class;
		private var sprTentacle:Spritemap = new Spritemap(imgTentacle, 80, 49, animEnd);
		
		private var right:Boolean;
		private var hitRect:Rectangle;
		private var parent:TentacleBeast;
		
		private const force:int = 2;
		
		public function Tentacle(_x:int, _y:int, _parent:TentacleBeast=null, _right:Boolean=true) 
		{
			super(_x, _y, sprTentacle);
			
			parent = _parent;
			right = _right;
			
			sprTentacle.originX = 8;
			sprTentacle.originY = 47;
			sprTentacle.x = -sprTentacle.originX;
			sprTentacle.y = -sprTentacle.originY;
			
			const dAnimSpeed:int = 10;
			const dSitAnimSpeed:int = 5;
			sprTentacle.add("rise", [0, 1, 2, 3, 4], dAnimSpeed);
			sprTentacle.add("sit", [5, 6, 5, 6, 5, 6], dSitAnimSpeed);
			sprTentacle.add("hit", [7, 8, 9, 10, 11], dAnimSpeed);
			sprTentacle.add("hitting", [12], dAnimSpeed);
			sprTentacle.add("sink", [13, 14, 15, 16], dAnimSpeed);
			sprTentacle.add("cut", [17, 18, 19, 20], dAnimSpeed);
			sprTentacle.play("rise");
			
			hitRect = new Rectangle(66 * int(!right), 6, 66, 8);
			
			setHitbox(16, 4, 8, 2);
			
			sprTentacle.scaleX = 2 * int(right) - 1;
			type = "Enemy";
			
			hitsMax = 1;
			
			layer = -(y - originY + height);
		}
		
		override public function update():void
		{
			if (Game.freezeObjects)
			{
				sprTentacle.rate = 0;
				return;
			}
			sprTentacle.rate = 1;
			
			canHit = sprTentacle.currentAnim == "sit";
			
			if (sprTentacle.currentAnim == "hitting")
			{
				var p:Player = FP.world.collideRect("Player", x - hitRect.x, y - hitRect.y, hitRect.width, hitRect.height) as Player;
				if (p)
				{
					p.hit(this, force, new Point(x, y), damage);
				}
			}
			hitUpdate();
			if (destroy)
			{
				sprTentacle.play("cut");
				sprTentacle.alpha -= 0.01;
				if (sprTentacle.alpha <= 0)
				{
					if (parent)
					{
						parent.maxTentacles--;
						parent.maxWhirlpools++;
					}
					FP.world.remove(this);
				}
			}
		}
		
		override public function knockback(f:Number = 0, p:Point = null):void { }
		
		public function animEnd():void
		{
			switch(sprTentacle.currentAnim)
			{
				case "rise":
					sprTentacle.play("sit"); break;
				case "sit":
					sprTentacle.play("hit"); break;
				case "hit":
					sprTentacle.play("hitting"); 
					Music.playSoundDistPlayer(x, y, "Tentacle");
					break;
				case "hitting":
					sprTentacle.play("sink"); break;
				case "sink":
					FP.world.remove(this); break;
				default:
					sprTentacle.play("cut");
			}
		}
		
		override public function startDeath(t:String=""):void
		{
			destroy = true;
			dieEffects(t, 24, sprTentacle.scaleX * 8, -8);
		}
		
	}

}