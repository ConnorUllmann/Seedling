package Scenery 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import Scenery.Tile;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class Moonrock extends Entity
	{
		[Embed(source = "../../assets/graphics/Moonrock.png")] private var imgMoonrock:Class;
		private var sprMoonrock:Spritemap = new Spritemap(imgMoonrock, 52, 52);
		
		private var tag:int;
		
		private var trigger:Boolean = false;
		public static function set beam(_t:Boolean):void
		{
			Main.beam = _t;
		}
		public static function get beam():Boolean
		{
			return Main.beam;
		}
		private const beamTimeMax:int = Main.FPS * 5;
		private var beamTime:int = beamTimeMax;
		private var canBeam:Boolean = false;
		
		private const cameraTimerMax:int = 90; // The length of time that the camera focuses after this hits
		private var cameraTimer:int = 0;
		
		private const fallRate:int = 20;
		private var fallTo:int;
		
		public function Moonrock(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x, _y, sprMoonrock);
			fallTo = _y;
			sprMoonrock.x = sprMoonrock.y = -2;
			sprMoonrock.originX = sprMoonrock.originY = 2;
			setHitbox(48, 48);
			type = "";
			tag = _tag;
			y = -1000;
			if (Game.moonrockSet)
			{
				y = fallTo;
				type = "Solid";
			}
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
			if (!Game.moonrockSet)
			{
				if ((beam && canBeam) || trigger)
				{
					Game.freezeObjects = true;
				}
				canBeam = false;
				var vp:Vector.<Player> = new Vector.<Player>();
				FP.world.getClass(Player, vp);
				for each(var p:Player in vp)
				{
					if (FP.distance(x + sprMoonrock.width/2, fallTo + sprMoonrock.height/2, p.x, p.y) > sprMoonrock.width * 3 / 4)
					{
						canBeam = true;
					}
				}
				if ((beam && canBeam) || trigger)
				{
					playersDirection(int(p.x > x + sprMoonrock.width / 2) * 2);
				}
				if (beam && canBeam)
				{
					Game.cameraTarget = new Point(x - FP.screen.width / 2, fallTo - FP.screen.height / 2);
					if (beamTime > 0)
					{
						if (beamTime == beamTimeMax)
							Music.playSound("Light");
						beamTime--;
						if (beamTime <= 0)
						{
							beamTime = 0;
							beam = false;
							trigger = true;
						}
					}
					else
					{
						beam = false;
					}
				}
				if (trigger)
				{
					y += fallRate;
					if (y >= fallTo)
					{
						y = fallTo;
						type = "Solid";
						Game.shake = 60;
						Music.playSound("Rock", 0, 2);
						cameraTimer = cameraTimerMax;
						Game.moonrockSet = true;
						trigger = false;
					}
				}
			}
			else
			{				
				p = collide("Player", x, y) as Player;
				if (p && !p.fallFromCeiling && !p.fallInPit)
				{
					p.y = y - originY + p.originY - p.height;
				}
				
				var stairs:Entity = collide("Teleporter", x, y);
				if (stairs is Stairs)
				{
					FP.world.add(new Teleporter(stairs.x, stairs.y, 2, 48, 32));
					Game.setPersistence(0, false, 2);
					FP.world.remove(stairs);
				}
				
				if (cameraTimer > 0)
				{
					cameraTimer--;
				}
				else if(cameraTimer == 0)
				{
					Game.resetCamera();
					Game.freezeObjects = false;
					playersDirection(-1);
					cameraTimer = -1;
				}
			}
			super.update();
			layer = -(fallTo - originY + height/2);
		}
		
		public function playersDirection(d:int):void
		{
			var vp:Vector.<Player> = new Vector.<Player>();
			FP.world.getClass(Player, vp);
			for each(var p:Player in vp)
			{
				p.directionFace = d;
			}
		}
		
		public function removeSelf():void
		{
			Game.setPersistence(tag, false);
		}
		
		override public function render():void
		{
			if (!trigger && beam && canBeam)
			{
				drawFlares();
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				drawFlares();
				Draw.resetTarget();
			}
			
			sprMoonrock.frame = Game.worldFrame(7);
			super.render();
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			super.render();
			Draw.resetTarget();
		}
		
		public function drawFlares():void
		{
			const m:int = 2;
			Draw.rect(x + sprMoonrock.width / 2 - Tile.w / 2 - m, y + sprMoonrock.height / 2 - m, Tile.w, fallTo - y + Tile.h / 2, 0xFFFFFF, 0.5);
			for (var i:int = 0; i < 20; i++)
			{
				const c:uint = FP.getColorRGB(192 + 64 * Math.random(), 192 + 64 * Math.random(), 192 * Math.random());
				const dx:int = Tile.w * 2 * Math.random() - Tile.w; //The distance each beam can be from the center
				const dy:int = Tile.h * 2 * Math.random() - Tile.h;
				const alpha:Number = Math.random() / 2;
				const thick:Number = Math.random() * 3 + 0.5;
				Draw.linePlus(x + sprMoonrock.width/2 + dx - m, y + sprMoonrock.height/2 - m, x + sprMoonrock.width/2 + dx - m, fallTo + sprMoonrock.height/2 + dy - m, c, alpha, thick);
			}
		}
	}
}