package Enemies 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import Scenery.Tile;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class LavaRunner extends Bob
	{
		[Embed(source = "../../assets/graphics/LavaRunner.png")] private var imgLavaRunner:Class;
		private var sprLavaRunner:Spritemap = new Spritemap(imgLavaRunner, 20, 20, endAnim);
		
		private static const waterFrameAddition:int = 5;
		private static const swimSpeed:Number = 1;
		private static const normalSpeed:Number = 1.5;
		
		private var jumpV:Number = 0;
		private const g:Number = 0.2;
		private var angleSpin:int = 10;
		private var startY:int;
		private var inAir:Boolean = false;
		
		public function LavaRunner(_x:int, _y:int) 
		{
			super(_x, _y, sprLavaRunner);
			startY = y;
			
			sprLavaRunner.centerOO();
			sprLavaRunner.add("walk", [0, 2, 3, 4], 15);
			sprLavaRunner.add("swim", [5, 7, 8, 9], 15);
			sprLavaRunner.add("die", [10, 11, 12, 13, 14, 15, 16, 17, 18], 15);
			sprLavaRunner.play("");
			setHitbox(12, 12, 6, 6);
			
			dieInLava = false;
			
			moveSpeed = normalSpeed;	
			hitsMax = 2;
			
			solids.push("LavaBoss", "Enemy");
		}
		
		override public function update():void
		{
			if (Game.freezeObjects)
				return;
			if (destroy || (graphic as Spritemap).currentAnim == "die")
			{
				super.update();
				return;
			}
			if (inAir)
			{
				collidable = false;
				jumpV += g;
				v.x = 0;
				v.y = jumpV;
				walk();
				sprLavaRunner.angle += angleSpin;
				mobileUpdate();
				if (y >= startY)
				{
					inAir = false;
				}
				layer = -(startY - originY + height + 6);
			}
			else
			{
				sprLavaRunner.angle = 0;
				collidable = true;
				super.update();
				if (v.x > moveSpeed/2)
				{
					(graphic as Spritemap).scaleX = Math.abs((graphic as Spritemap).scaleX);
				}
				else if (v.x < -moveSpeed/2)
				{
					(graphic as Spritemap).scaleX = -Math.abs((graphic as Spritemap).scaleX);
				}
				
				switch(getState())
				{
					case 1:
						swim();
						break;
					case 17:
						swim();
						break;
					default:
						walk();
				}
			}
		}
		
		public function jump(right:Boolean):void
		{
			jumpV = -3;
			startY = y + Tile.h;
			angleSpin *= int(right) * 2 - 1;
			inAir = true;
		}
		
		public function swim():void
		{
			(graphic as Spritemap).play("swim");
			sitFrames = new Array(5, 6);
			moveSpeed = swimSpeed;
			animateNormally = false;
		}
		
		public function walk():void
		{
			sitFrames = new Array(0, 1);
			moveSpeed = normalSpeed;
			animateNormally = true;
		}
		
		override public function render():void
		{
			super.render();
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
		
	}

}