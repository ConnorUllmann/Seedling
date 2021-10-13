package Scenery 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class RockFall extends Mobile
	{
		[Embed(source = "../../assets/graphics/RockFall.png")] private var imgRockFall:Class;
		private var sprRockFall:Spritemap = new Spritemap(imgRockFall, 64, 32, endAnim);
		
		private const fallHeight:int = 96;
		private var g:Number = 0.05;
		private const force:int = 3;
		private const damage:int = 1;
		private var angleRate:int = 5;
		private var goto:int;
		private var startingSpeed:Number = 6;
		
		public function RockFall(_x:int, _y:int) 
		{
			super(_x, _y - fallHeight, sprRockFall);
			goto = _y;
			
			angleRate *= FP.choose(1, -1);
			
			sprRockFall.centerOO();
			sprRockFall.scale = Math.random() / 2 + 0.25;
			sprRockFall.scaleX = FP.choose(1, -1);
			sprRockFall.add("break", [0, 1, 2, 3, 4, 5, 6, 7], 15);
			
			setHitbox(32 * sprRockFall.scale, 16 * sprRockFall.scale);
			setHitbox(width, height, width / 2, -sprRockFall.scale * sprRockFall.height / 2 + height);
			
			v.y = startingSpeed;
			f = 0;
			
			type = "";
		}
		
		override public function added():void
		{
			super.added();
			solids = [];// "Enemy", "Pod", "Solid"];
			if (collideTypes(solids, x, y))
			{
				active = false;
				visible = false;
				FP.world.remove(this);
			}
			solids = [];
		}
		
		override public function update():void
		{
			v.y += g;
			super.update();
			
			if (y > goto)
			{
				v.y = 0;
				g = 0;
				y = goto;
				Game.shake += sprRockFall.scale + 1;
				var p:Player = collide("Player", x, y) as Player;
				if (p)
				{
					p.hit(null, force, new Point(x, y), damage);
				}
				sprRockFall.play("break");
				Music.playSound("Rock", 0);
			}
		}
		
		override public function layering():void
		{
			layer = -goto;
		}
		
		override public function render():void
		{
			//Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			const m:int = 4;
			Draw.rect(x - originX + m, goto - 1 - m/2 + height*2/3, width - m * 2, height / 2 + m, 0x000000, 0.5);
			Draw.rect(x - originX, goto - 1 + height*2/3, width, height/2, 0x000000, 0.5);
			//Draw.resetTarget();
			if (!Game.freezeObjects)
			{
				if (sprRockFall.currentAnim == "break")
				{
					sprRockFall.alpha = 1;
					sprRockFall.angle = 0;
				}
				else
				{
					sprRockFall.angle += angleRate;
					sprRockFall.alpha = Math.min(1, 1 - (goto - y) / fallHeight);
				}
			}
			super.render();
		}
		
		public function endAnim():void
		{
			FP.world.remove(this);
		}
		
	}

}