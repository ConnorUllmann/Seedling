package Puzzlements
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import Scenery.Tile;
	import Projectiles.Arrow;
	/**
	 * ...
	 * @author Time
	 */
	public class ArrowTrap extends Activators
	{
		[Embed(source = "../../assets/graphics/ArrowTrap.png")] private var imgArrowTrap:Class;
		private var sprArrowTrap:Spritemap = new Spritemap(imgArrowTrap, 16, 5);
		
		private var shootTimer:int = 0;
		private const shootTimerMax:int = 10;
		private var shootDefault:Boolean; //Whether it should default to shooting when not activated or vice versa
		
		public function ArrowTrap(_x:int, _y:int, _t:int=0, _shoot:Boolean=false) 
		{
			super(_x + Tile.w/2, _y + sprArrowTrap.height/2, sprArrowTrap, _t);
			sprArrowTrap.centerOO();
			layer = -(y - originY + height);
			shootDefault = _shoot;
		}
		
		override public function update():void
		{
			if ((activate && !shootDefault) || (!activate && shootDefault))
			{
				shoot();
			}
			else
			{
				shootTimer = 0;
			}
		}
		
		override public function render():void
		{
			sprArrowTrap.frame = Game.worldFrame(sprArrowTrap.frameCount);
			super.render();
		}
		
		public function shoot():void
		{
			if (shootTimer > 0)
			{
				shootTimer--;
			}
			else
			{
				Music.playSoundDistPlayer(x, y, "Arrow", 0);
				FP.world.add(new Arrow(x - sprArrowTrap.width / 4, y - 2, new Point(0, 5)));
				FP.world.add(new Arrow(x, y - 2, new Point(0, 5)));
				FP.world.add(new Arrow(x + sprArrowTrap.width / 4, y-2, new Point(0, 5)));
				shootTimer = shootTimerMax;
			}
		}
	}

}