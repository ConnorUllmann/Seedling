package Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Projectiles.LightBossShot;
	import Scenery.Light;
	/**
	 * ...
	 * @author Time
	 */
	public class LightBoss extends Enemy
	{
		[Embed(source = "../../assets/graphics/LightBoss.png")] private var imgLightBoss:Class;
		private var sprLightBoss:Spritemap = new Spritemap(imgLightBoss, 17, 16, animEnd);
		
		private const divisor:int = 20;
		private const lightLength:int = 4;
		private const shotSpeed:int = 1;
		private const maxSpeed:Number = 1.5;
		public var goto:Point;
		private var parent:LightBossController;
		public var id:int;
		private var myLight:Light;
		private var angleFace:Number;
		
		public function LightBoss(_x:int, _y:int, _id:int, _parent:LightBossController) 
		{
			super(_x, _y, sprLightBoss);
			sprLightBoss.centerOO();
			sprLightBoss.add("sit", [0]);
			sprLightBoss.add("die", [1, 2, 3, 4, 5, 6, 7, 8, 9], 20);
			sprLightBoss.play("sit");
			
			canFallInPit = false;
			activeOffScreen = true;
			dieInWater = false;
			
			setHitbox(12, 12, 6, 6);
			
			solids = [];
			
			id = _id;
			parent = _parent;
			
			hitsMax = 3;
			
			FP.world.add(myLight = new Light(x, y, 100, 1, 0xFFFF00, true));
			
			hitSoundIndex = 1; //Big hit sound
			dieSoundIndex = 1; //Big die sound
		}
		
		override public function update():void
		{
			super.update();
			if (Game.freezeObjects)
				return;
			
			if (goto)
			{
				v.x += (goto.x - x) / divisor;
				v.y += (goto.y - y) / divisor;
			}
			
			if (!Math.floor(Math.random() * 90))
			{
				Music.playSound("Boss 6 Move");
			}
			
			angleFace = Math.atan2(v.y, v.x);
			
			if (myLight)
			{
				myLight.x = x + lightLength * Math.cos(angleFace);
				myLight.y = y + lightLength * Math.sin(angleFace);
				myLight.color = FP.colorLerp(0xFFFF00, 0x00FF00, hits / hitsMax);
			}
			v.normalize(Math.min(v.length, maxSpeed));
			(graphic as Image).angle = angleFace * FP.DEG;
			normalColor = 0xFFFFFF * (1 - hits / hitsMax);
		}
		
		override public function startDeath(t:String=""):void
		{
			sprLightBoss.play("die");
			sprLightBoss.scale = 1.1;
			parent.removeFlier(id);
			
			var p:Player = FP.world.nearestToPoint("Player", x, y) as Player;
			
			if (myLight)
			{
				FP.world.remove(myLight);
			}
		}
		
		public function animEnd():void
		{
			switch((graphic as Spritemap).currentAnim)
			{
				case "die":
					destroy = true;
					FP.world.remove(this);
					break;
				default:
			}
		}
		
		public function shoot():void
		{
			FP.world.add(new LightBossShot(x + lightLength * Math.cos(angleFace), y + lightLength * Math.sin(angleFace), new Point(shotSpeed*Math.cos(angleFace), shotSpeed*Math.sin(angleFace))));
		}
		
	}

}