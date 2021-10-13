package  
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
	public class Teleporter extends Entity
	{
		[Embed(source = "../assets/graphics/Portal.png")] private var imgPortal:Class;
		private var sprPortal:Spritemap = new Spritemap(imgPortal, 18, 18);
		
		private var to:int;
		private var playerPos:Point;
		
		private var playerTouching:Boolean = false;
		protected var renderLight:Boolean = true;
		
		private var tag:int; //True = exists, false = doesn't exist
		private var invert:Boolean; //If this is true, it inverts the rules for the tag
		private var deactivated:Boolean = false; //If true, then doesn't render or do player stuff
		private var sign:int; //Displays text in the room that this teleporter teleports to (text in Message.as)
		
		public var sound:String = "Room";
		public var soundIndex:int = 0;
		
		public function Teleporter(_x:int, _y:int, _to:int=0, _px:int=0, _py:int=0, _show:Boolean=false, _tag:int=-1, _invert:Boolean=false, _sign:int=-1) 
		{
			super(_x, _y, sprPortal);
			to = _to;
			playerPos = new Point(_px, _py);
			setHitbox(16, 16, 0, 0);
			
			sprPortal.originX = 1;
			sprPortal.originY = 1;
			sprPortal.x = -sprPortal.originX;
			sprPortal.y = -sprPortal.originY;
			sprPortal.add("spin", [0, 1, 2, 3], 15);
			sprPortal.play("spin");
			
			visible = _show;
			tag = _tag;
			invert = _invert;
			sign = _sign - 1; //takes the value of _sign - 1 because zero should become -1 (to negate all of the levels where it defaults to zero)
			
			if (visible)
				soundIndex = 3;
			
			type = "Teleporter";
			
			checkDeactivated();
		}
		
		override public function check():void
		{
			super.check();
			if (collide("Player", x, y))
			{
				playerTouching = true;
			}
		}
		
		/**
		 * Removes this object by its tag
		 */
		public function removeSelf():void
		{
			Game.setPersistence(tag, false);
		}
		
		public function checkDeactivated():void
		{
			deactivated = tag >= 0 && (!Game.checkPersistence(tag) == invert);
		}
		
		override public function update():void
		{
			checkDeactivated();
			if (deactivated)
			{
				return;
			}
			if (collide("Player", x, y))
			{
				if (!playerTouching)
				{
					Music.playSound(sound, soundIndex);
					FP.world = new Game(to, playerPos.x, playerPos.y);
					Game.sign = sign;
				}
			}
			else
			{
				playerTouching = false;
			}
		}
		
		override public function render():void
		{
			if (deactivated)
			{
				return;
			}
			super.render();
			renderLit();
		}
		public function renderLit():void
		{
			if (renderLight)
			{
				super.render();
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				super.render();
				Draw.resetTarget();
			}
		}
	}

}