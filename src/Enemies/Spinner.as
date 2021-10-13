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
	public class Spinner extends Enemy
	{
		[Embed(source = "../../assets/graphics/Spinner.png")] private var imgSpinner:Class;
		private var sprSpinner:Spritemap = new Spritemap(imgSpinner, 18, 9);
		
		private var tag:int;
		private var doActions:Boolean = true;
		
		public var moveSpeed:Number = 1;
		private const runRange:int = 0; //Range at which the Spinner will run after the character
		private var coins:int = 4 + Math.random() * 4; //The number of coins to throw upon death
		private var hammerAngle:Number = 0;
		
		private const hitForce:Number = 4;
		
		public function Spinner(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprSpinner);
			
			v = new Point(moveSpeed * Math.cos( -Math.PI / 4), moveSpeed * Math.sin( -Math.PI / 4));
			
			sprSpinner.x = -5;
			sprSpinner.originX = -sprSpinner.x;
			sprSpinner.y = -5;
			sprSpinner.originY = -sprSpinner.y;
			
			tag = _tag;
			
			setHitbox(7, 7, 4, 4);
			
			activeOffScreen = true;
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
			if (doActions)
			{
				Game.setPersistence(tag, false);
				//if(!fell) dropCoins();
			}
		}
		
		override public function update():void
		{
			super.update();
			
			const hammerLength:int = sprSpinner.width - sprSpinner.originX;
			hammerAngle = (Game.time % Game.timePerFrame) / Game.timePerFrame * 2 * Math.PI;
			var player:Player = FP.world.collideLine("Player", x, y, x + hammerLength * Math.cos(hammerAngle), y + hammerLength * Math.sin(hammerAngle)) as Player;
			if (player)
			{
				player.hit(this, hitForce, new Point(x, y));
			}
			
			player = FP.world.nearestToPoint("Player", x, y) as Player;
			if (player)
			{
				var d:Number = FP.distance(x, y, player.x, player.y);
				if (d <= runRange && !FP.world.collideLine("Solid", x, y, player.x, player.y))
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
				}
			}
		}
		
		override public function render():void
		{
			var alpha:Number = sprSpinner.alpha;
			if (hits >= hitsMax)
			{
				sprSpinner.scale += 0.1;
				sprSpinner.alpha = Math.max(0, 2 - sprSpinner.scale) * alpha;
				sprSpinner.angle = -hammerAngle / Math.PI * 180;
				sprSpinner.frame = 1;
				sprSpinner.render(new Point(x, y), FP.camera);
				sprSpinner.alpha = alpha;
				sprSpinner.angle = 0;
				sprSpinner.frame = 0;
				sprSpinner.render(new Point(x, y), FP.camera);
			}
			else
			{
				sprSpinner.angle = -hammerAngle / Math.PI * 180;
				sprSpinner.frame = 1;
				sprSpinner.render(new Point(x, y), FP.camera);
				sprSpinner.angle = 0;
				sprSpinner.frame = 0;
				sprSpinner.render(new Point(x, y), FP.camera);
			}
			sprSpinner.alpha = alpha;
		}
		
		override public function friction():void
		{
			v.normalize(Math.max(v.length - f, moveSpeed));
			if (Math.abs(v.x) < 0.05)
			{
				v.x = 0;
			}
			if (Math.abs(v.y) < 0.05)
			{
				v.y = 0;
			}
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
					v.x = -v.x;
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
					v.y = -v.y;
					return c;
				}
			}
			return null;
		}
	}

}