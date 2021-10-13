package Pickups
{
	import Enemies.BossTotem;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import Scenery.Tile;
	import Puzzlements.Activators;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class Wand extends Pickup
	{
		[Embed(source = "../../assets/graphics/WandPickup.png")] private var imgWandPickup:Class;
		private var sprWandPickup:Spritemap = new Spritemap(imgWandPickup, 5, 9);
		
		private var tag:int;
		private var doActions:Boolean = true;
		
		private var doBossActions:Boolean =  true;
		private const alphaRate:Number = 0.01;
		//When this is picked up, it will activate any tset = 0 object in the room.
		private var tset:int = 0;
		
		public function Wand(_x:int, _y:int, _tag:int=-1) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprWandPickup, null, false);
			sprWandPickup.centerOO();
			setHitbox(3, 8, 2, 4);
			
			tag = _tag;
			
			if (doBossActions)
			{
				(graphic as Spritemap).alpha = 0;
			}
			
			special = true;
			text = "You got the Wand!~It shoots weakly, but far.";
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
				Player.hasWand = true;
				if (doBossActions)
				{
					//Activate falling blocks
					var v:Vector.<Activators> = new Vector.<Activators>();
					FP.world.getClass(Activators, v);
					for each (var n:Activators in v)
					{
						if (n.t == tset)
						{
							n.activate = true;
						}
					}
				}
				Game.setPersistence(tag, false);
			}
		}
		
		override public function update():void
		{
			var p:Player = FP.world.nearestToPoint("Player", x, y) as Player;
			if ((p && p.y < y + Tile.h && Player.hasAllTotemParts() && !p.fallFromCeiling) || !doBossActions)
			{
				if ((graphic as Spritemap).alpha < 1)
				{
					(graphic as Spritemap).alpha = Math.min((graphic as Spritemap).alpha + alphaRate, 1);
					Game.freezeObjects = (graphic as Spritemap).alpha < 1;
				}
				else
				{
					super.update();
				}
			}
		}
		override public function render():void
		{
			const frameCount:int = 6;
			
			sprWandPickup.frame = Game.worldFrame(frameCount);
			sprWandPickup.y = -sprWandPickup.originY + 2 * Math.sin(2 * Math.PI * (Game.time % Game.timePerFrame)/Game.timePerFrame);
			super.render();
			
			const offsetX:int = sprWandPickup.x + 3;
			const offsetY:int = sprWandPickup.y + 1;
			var radiusMax:int = 20;
			var radiusMin:int = 14;
			const color:uint = 0xFFFF00;
			const alpha:Number = (graphic as Spritemap).alpha * 0.2;
			var frame:int = sprWandPickup.frame;
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			Draw.circlePlus(x + offsetX, y + offsetY, (radiusMax - radiusMin) * frame / (frameCount - 1) + radiusMin, color, alpha);
			Draw.circlePlus(x + offsetX, y + offsetY, ((radiusMax - radiusMin) * frame / (frameCount - 1) + radiusMin) / 2, color, alpha);
			Draw.resetTarget();
		}
		
	}

}