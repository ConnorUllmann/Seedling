package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	import Pickups.Coin;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class WallFlyer extends Enemy
	{
		[Embed(source = "../../assets/graphics/WallFlyer.png")] private var imgWallFlyer:Class;
		private var sprWallFlyer:Spritemap = new Spritemap(imgWallFlyer, 20, 16, endAnim);
		
		public var moveSpeed:Number = 4;
		private var coins:int = 4 + Math.random() * 4; //The number of coins to throw upon death
		private var attackRange:int = FP.screen.width; //The range at which the wall flyer will jump if the player is intersecting.
		private var vTriggered:Point = new Point(); // The vector of motion of the wall flyer when it is triggered by the player.
		
		public function WallFlyer(_x:int, _y:int) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprWallFlyer);
			
			v = new Point();
			sprWallFlyer.centerOO();
			sprWallFlyer.x = -12;
			sprWallFlyer.originX = -sprWallFlyer.x;
			sprWallFlyer.add("jump", [0, 1, 2, 3], 15);
			sprWallFlyer.add("jumping", [3, 4], 7);
			sprWallFlyer.add("die", [5, 6, 7, 8], 10);
			
			f = 0;
			
			setHitbox(14, 14, 7, 7);
		}
		
		override public function check():void
		{
			super.check();
			v = decideMotion( -moveSpeed);
		}
		
		override public function startDeath(t:String=""):void
		{
			(graphic as Spritemap).play("die");
			dieEffects(t);
		}
		
		override public function update():void
		{
			super.update();
			if (destroy || sprWallFlyer.currentAnim == "die")
				return;
			
			vTriggered = decideMotion(moveSpeed);
			if (vTriggered.length > 0)
			{
				var player:Player = FP.world.collideLine("Player", x, y, x + attackRange * (vTriggered.x / vTriggered.length), y + attackRange * (vTriggered.y / vTriggered.length)) as Player;
				if (player)
				{
					v = vTriggered;
					sprWallFlyer.play("jump");
				}
			}
			if (v.length > 0)
			{
				activeOffScreen = true;
			}
			else
			{
				activeOffScreen = false;
			}
		}
		
		override public function render():void
		{
			if (!destroy && sprWallFlyer.currentAnim != "die")
			{
				if (vTriggered.length > 0)
				{
					sprWallFlyer.angle = -Math.atan2(vTriggered.y, vTriggered.x) * 180 / Math.PI;
				}
				else if(v.length > 0)
				{
					sprWallFlyer.angle = -Math.atan2(v.y, v.x) * 180 / Math.PI;
				}
				if (v.length == 0)
				{
					sprWallFlyer.frame = Game.worldFrame(2);
				}
			}
			super.render();
		}
		
		public function endAnim():void
		{
			if (sprWallFlyer.currentAnim == "jump")
			{
				sprWallFlyer.play("jumping");
			}
			else if (sprWallFlyer.currentAnim == "die")
			{
				destroy = true;
				sprWallFlyer.play("");
				sprWallFlyer.frame = sprWallFlyer.frameCount - 1;
			}
		}
		
		public function decideMotion(speed:Number):Point
		{
			var ang:Number = 0;
			var d:int = 0;
			var types:Object = ["Solid", "Tree"];
			if (collideTypes(types, x + width, y)) { d += 1; }
			if (collideTypes(types, x, y - height)) { d += 2; }
			if (collideTypes(types, x - width, y)) { d += 4; }
			if (collideTypes(types, x, y + height)) { d += 8; }
			switch(d)
			{
				case 1:
					ang = Math.PI;
					break;
				case 2:
					ang = Math.PI * 3 / 2;
					break;
				case 3:
					ang = Math.PI * 5 / 4;
					break;
				case 4:
					ang = 0;
					break;
				case 5:
					ang = 0;
					break;
				case 6:
					ang = Math.PI * 7 / 4;
					break;
				case 7:
					ang = Math.PI * 3 / 2;
					break;
				case 8:
					ang = Math.PI / 2;
					break;
				case 9:
					ang = Math.PI * 3 / 4;
					break;
				case 10:
					ang = Math.PI / 2;
					break;
				case 11:
					ang = Math.PI;
					break;
				case 12:
					ang = Math.PI / 4;
					break;
				case 13:
					ang = Math.PI / 2;
					break;
				case 14:
					ang = 0;
					break;
				default:
					return new Point();
			}
			return new Point(speed * Math.cos(ang), -speed * Math.sin(ang));
		}
		
		override public function knockback(f:Number=0,p:Point=null):void
		{
			v.x = -v.x;
			v.y = -v.y;
		}
		
		override public function moveX(_xrel:Number):Entity //returns the object that is hit
		{
			for (var i:int = 0; i < Math.abs(_xrel); i++)
			{
				var c:Entity = collideTypes(solids, x + Math.min(1, (Math.abs(_xrel) - i)) * FP.sign(_xrel), y);
				if (!c)
				{
					x += Math.min(1, (Math.abs(_xrel) - i)) * FP.sign(_xrel);
				}
				else
				{
					if (c.type == "Player")
					{
						v.x = -v.x;
						v.y = -v.y;
					}
					else
					{
						v.x = 0;
						v.y = 0;
					}
					return c;
				}
			}
			return null;
		}
		
		override public function moveY(_yrel:Number):Entity //returns the object that is hit
		{
			for (var i:int = 0; i < Math.abs(_yrel); i++)
			{
				var c:Entity = collideTypes(solids, x, y + Math.min(1, Math.abs(_yrel) - i) * FP.sign(_yrel));
				if (!c)
				{
					y += Math.min(1, Math.abs(_yrel) - i) * FP.sign(_yrel);
				}
				else
				{
					if (c.type == "Player")
					{
						v.x = -v.x;
						v.y = -v.y;
					}
					else
					{
						v.x = 0;
						v.y = 0;
					}
					return c;
				}
			}
			return null;
		}
	}

}