package  
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Pickups.SealPiece;
	import Scenery.Tile;
	import Pickups.Coin;
	/**
	 * ...
	 * @author Time
	 */
	public class Chest extends Entity
	{
		
		[Embed(source = "../assets/graphics/Chest.png")] private var imgChest:Class;
		private var sprChest:Spritemap = new Spritemap(imgChest, 16, 16);
		
		private const openTimerMax:int = 60;
		private var openTimer:int = 0;
		private var coins:int = Math.floor(Math.random() * 4 + 8);
		private var tag:int;
		
		public function Chest(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w / 2, _y + Tile.h / 2, sprChest);
			sprChest.centerOO();
			type = "Solid";
			setHitbox(16, 16, 8, 8);
			layer = -(y - originY);
			
			tag = _tag;
			
			checkBySeal();
		}
		
		override public function check():void
		{
			super.check();
			if (tag >= 0 && !Game.checkPersistence(tag))
			{
				FP.world.remove(this);
			}
		}
		
		public function checkBySeal():void
		{
			if (SealController.hasAllSealParts())
			{
				if (tag >= 0)
				{
					Game.setPersistence(tag, false);
				}
				FP.world.remove(this);
			}
		}
		
		override public function update():void
		{
			checkBySeal();
			var m:int = 2; //The distance to check from the edges of the chest
			if (!collide("Solid", x, y) && FP.world.collideLine("Player", x - originX + m, y - originY + height + 1, x - originX + width - 2 * m, y - originY + height + 1))
			{
				open();
			}
			timerStep();
		}
		
		public function open():void
		{
			if (sprChest.frame == 0)
			{
				Music.playSound("Chest");
				sprChest.frame = 1;
				openTimer = openTimerMax;
				type = "";
				FP.world.add(new SealPiece(x, y));
				/*var m:int = 2; //The margin from each side of the chest to randomly add the object
				for (var i:int = 0; i < coins; i++)
				{
					FP.world.add(new Coin(x - originX + m + Math.random() * (width - m * 2), y - originY + 4 + height/2 * Math.random(), new Point(Math.cos(Math.random()*2*Math.PI), Math.sin(Math.random()*2*Math.PI))));
				}*/
				var index:int = -1;
				while (index < 0 || !SealController.getSealPart(index))
				{
					index = Math.floor(Math.random() * SealController.SEALS);
				}
				Game.setPersistence(tag, false);
			}
		}
		
		public function timerStep():void
		{
			if (openTimer > 0)
			{
				openTimer--;
				sprChest.alpha = Math.min(openTimer / (openTimerMax / 3), 1);
				if (openTimer <= 0)
				{
					FP.world.remove(this);
				}
			}
		}
		
	}

}