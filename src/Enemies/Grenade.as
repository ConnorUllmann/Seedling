package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Light;
	import Scenery.Tile;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class Grenade extends Enemy 
	{
		[Embed(source = "../../assets/graphics/Grenade.png")] private var imgGrenade:Class;
		private var sprGrenade:Spritemap = new Spritemap(imgGrenade, 16, 16, animEnd);
		
		private const hitRadius:int = 20;
		private const fallHeight:int = 48;
		private const fallTriggerDistance:int = 32;
		private const g:Number = 0.1;
		private const force:int = 2;
		private const hitFrames:Array = new Array(5, 6, 7);
		
		private var explodeTime:int;
		private var myLight:Light;
		private var startY:int;
		private var endY:int;
		private var activated:Boolean;
		
		public function Grenade(_x:int, _y:int, _active:Boolean=false, _exTime:int=60) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2 - fallHeight, sprGrenade);
			endY = _y + Tile.h/2;
			startY = y;
			
			hitsMax = 1;
			
			setHitbox(6, 6, 3, 3);
			type = "Enemy";
			
			sprGrenade.centerOO();
			sprGrenade.add("explode", [0, 1, 0, 2, 0, 3, 4, 3], 12);
			sprGrenade.add("hit", hitFrames, 12);
			sprGrenade.add("sit", [0, 4], 5);
			sprGrenade.play("sit");
			
			f = 0;
			damage = 1;
			
			activated = _active;
			if (activated)
			{
				y = endY;
			}
			
			explodeTime = _exTime;
		}
		
		override public function removed():void
		{
			super.removed();
			if (myLight)
			{
				FP.world.remove(myLight);
			}
		}
		
		override public function hit(f:Number=0, p:Point=null, d:Number=1, t:String=""):void
		{		}
		
		override public function update():void
		{
			var p:Player = FP.world.nearestToPoint("Player", x, endY) as Player;
			if (y >= endY)
			{
				collidable = true;
				if (v.y > 0)
				{
					v.y = -v.y+1;
				}
				else
				{
					v.y = 0;
					if (explodeTime > 0)
					{
						explodeTime--;
					}
					else if(explodeTime == 0)
					{
						explodeTime = -1;
						sprGrenade.play("explode");
					}
				}
				if (myLight && sprGrenade.currentAnim == "hit")
				{
					myLight.alpha = 1 - sprGrenade.index / (hitFrames.length - 1);
				}
				mobileUpdate();
			}
			else if(p && FP.distance(x, endY, p.x, p.y) <= fallTriggerDistance)
			{
				activated = true;
			}
			
			if (y < endY && activated)
			{
				collidable = false;
				v.y += g;
				mobileUpdate();
			}
		}
		
		override public function render():void
		{
			sprGrenade.alpha = (y - startY) / (endY - startY);
			super.render();
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			sprGrenade.alpha *= 0.5;
			super.render();
			Draw.resetTarget();
		}
		
		public function animEnd():void
		{
			var p:Player = FP.world.nearestToPoint("Player", x, endY) as Player;
			switch(sprGrenade.currentAnim)
			{
				case "explode":
					if (p && FP.distance(x, endY, p.x, p.y) <= hitRadius)
					{
						p.hit(null, force, new Point(x, endY), damage);
					}
					Music.playSoundDistPlayer(x, y, "Explosion", -1, 120);
					FP.world.add(myLight = new Light(x, endY, 2, 1, 0xFFFF00, false, hitRadius, hitRadius, 1));
					sprGrenade.play("hit");
					break;
				case "hit":
					FP.world.remove(this);
					break;
				default:
			}
		}
		
		override public function knockback(f:Number=0,p:Point=null):void{}
		
	}

}