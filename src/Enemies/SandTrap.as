package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class SandTrap extends Enemy
	{
		[Embed(source = "../../assets/graphics/SandTrap.png")] private var imgSandTrap:Class;
		private var sprSandTrap:Spritemap = new Spritemap(imgSandTrap, 14, 14, endAnim);
		
		private const chompAnimSpeed:int = 10;
		private const chompRange:int = 20; // The distance at which the cactus will start chomping from a player
		
		private var tag:int;
		
		public function SandTrap(_x:int, _y:int, _tag:int=-1, _g:Spritemap=null) 
		{
			if (!_g)
			{
				_g = sprSandTrap;
			}
			super(_x + Tile.w/2, _y + Tile.h/2, _g);
			
			(graphic as Spritemap).centerOO();
			//the animation "" will reset it to the world frame speed
			(graphic as Spritemap).add("chomp", [0, 1, 2, 3, 2, 1], chompAnimSpeed);
			(graphic as Spritemap).add("hit", [1]);
			(graphic as Spritemap).add("die", [4, 5, 6, 7, 8, 9], 10);
			
			setHitbox(16, 16, 8, 8);
			
			layer = -(y - originY + height * 4 / 5);
			tag = _tag;
		}
		
		override public function check():void
		{
			super.check();
			if (tag >= 0 && !Game.checkPersistence(tag))
			{
				FP.world.remove(this);
			}
		}
		
		override public function update():void
		{
			super.update();
			if ((graphic as Spritemap).currentAnim == "die")
				return;
				
			var player:Player = FP.world.nearestToEntity("Player", this) as Player;
			if (player)
			{
				var d:int = FP.distance(x, y, player.x, player.y);
				if (d <= chompRange && (graphic as Spritemap).currentAnim != "chomp")
				{
					Music.playSoundDistPlayer(x, y, "Enemy Attack", 3);
					(graphic as Spritemap).play("chomp");
				}
			}
			if ((graphic as Spritemap).currentAnim == "")
			{
				(graphic as Spritemap).frame = Game.worldFrame(2);
			}
		}
		
		override public function layering():void
		{
			
		}
		
		override public function knockback(f:Number = 0, p:Point = null):void
		{
			
		}
		
		override public function removed():void
		{
			super.removed();
			Game.setPersistence(tag, false);
		}
		
		override public function startDeath(t:String=""):void
		{
			(graphic as Spritemap).play("die");
			dieEffects(t);
		}
		
		public function endAnim():void
		{
			switch((graphic as Spritemap).currentAnim)
			{
				case "die":
					FP.world.remove(this);
					break;
				default:
					(graphic as Spritemap).play("");
			}
		}
		
	}

}