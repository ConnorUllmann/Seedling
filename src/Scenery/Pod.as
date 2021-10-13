package Scenery 
{
	import Enemies.FinalBoss;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class Pod extends Entity
	{
		[Embed(source = "../../assets/graphics/PodBody.png")] private var imgPodBody:Class;
		private var sprPodBody:Image = new Image(imgPodBody);
		[Embed(source = "../../assets/graphics/Pod.png")] private var imgPod:Class;
		private var sprPod:Spritemap = new Spritemap(imgPod, 24, 24, animEnd);
		
		private var myPodBody:Entity;
		private const hitables:Object = ["Player"];
		
		public function Pod(_x:int, _y:int) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprPod);
			sprPod.centerOO();
			sprPodBody.centerOO();
			
			sprPod.alpha = 0.5;
			
			sprPod.add("open", [0, 1, 2, 3, 4, 5, 6], 10);
			sprPod.add("opened", [6], 10);
			sprPod.add("close", [6, 5, 4, 3, 2, 1, 0], 10);
			sprPod.add("closed", [0], 10);
			sprPod.play("open");
			
			setHitbox(16, 16, 8, 8);
			type = "Pod";
			
			
			myPodBody = FP.world.addGraphic(sprPodBody, -(y - Tile.h * 3), x, y);
		}
		
		override public function update():void
		{
			super.update();
			
			layer = sprPod.frame <= 3 ? -(y + Tile.h * 3) : myPodBody.layer - 1;
			
			var v:Vector.<Entity> = new Vector.<Entity>();
			collideTypesInto(hitables, x, y, v);
			for each(var e:Entity in v)
			{
				/*if (e is FinalBoss)
				{
					var fb:FinalBoss = e as FinalBoss;
					if (sprPod.currentAnim == "closed")
					{
						fb.x = x;
						fb.y = y;
						fb.v.x = fb.v.y = 0;
					}
				}*/
				if (e is Player)
				{
					var p:Player = e as Player;
					if (sprPod.currentAnim == "closed")
					{
						p.x = x;
						p.y = y;
						p.v.x = p.v.y = 0;
						p.hit(null, 0, null, 1);
					}
				}
			}
			
			//type = (sprPod.currentAnim == "closed" && v.length<=0) ? "Solid" : "Pod";
			
			if (v.length > 0 && sprPod.currentAnim == "opened")
			{
				sprPod.play("close");
			}
		}
		
		override public function render():void
		{
			super.render();
		}
		
		public function set open(_o:Boolean):void
		{
			if (_o)
			{
				sprPod.play("open");
			}
			else
			{
				sprPod.play("close");
			}
		}
		public function get open():Boolean
		{
			return sprPod.currentAnim == "open" || sprPod.currentAnim == "opened";
		}
		
		public function animEnd():void
		{
			switch(sprPod.currentAnim)
			{
				case "open":
					sprPod.play("opened");
					break;
				case "close":
					sprPod.play("closed");
					break;
				default:
			}
		}
		
	}

}