package Puzzlements
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	import Scenery.Wire;
	/**
	 * ...
	 * @author Time
	 */
	public class ButtonRoom extends Activators
	{
		[Embed(source = "../../assets/graphics/ButtonRoom.png")] private var imgButtonRoom:Class;
		private var sprButtonRoom:Spritemap = new Spritemap(imgButtonRoom, 16, 16);
		
		private var hitables:Object = ["Player", "Enemy", "Solid"]; //Things that push down the button
		private var flip:Boolean; //Changes the actions of the button so that there's persistence in the room.
								  //Defaults to pushed is true, and unpushed is false.
		private var room:int;
		
		private var tag:int;
		
		private var frameAdd:int = 0;
		
		//tset matches up with "tag" for objects in other rooms, not their tsets.
		
		public function ButtonRoom(_x:int, _y:int, _t:int, _tag:int, _flip:Boolean, _room:int) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, sprButtonRoom, _t);
			sprButtonRoom.centerOO();
			setHitbox(8, 6, 4, 3);
			type = "ButtonRoom";
			layer = Tile.LAYER;
			flip = _flip;
			room = _room;
			tag = _tag;
		}
		
		override public function check():void
		{
			super.check();
			_active = !Game.checkPersistence(tag); //Notted so that it starts off as up (not down, as "true" would imply)
			activate = _active;
			if (collide("Wire", x, y + Tile.h))
			{
				frameAdd = 2;
				sprButtonRoom.frame = int(activate) + frameAdd;
			}
		}
		
		override public function update():void
		{
			var v:Vector.<Entity> = new Vector.<Entity>();
			collideTypesInto(hitables, x, y, v);
			var tempCheck:Boolean = false;
			for each (var c:Entity in v)
			{
				if (c && !(c is Cover))
				{
					tempCheck = true;
				}
			}
			activate = tempCheck;
		}
		
		override public function set activate(a:Boolean):void
		{
			if (a) //Can't be reset to false!!
			{
				if (!_active)
					Music.playSound("Switch");
				_active = a;
				var persist:Boolean = _active;
				if (flip)
				{
					persist = !persist;
				}
				if (room == -1)
				{
					var v:Vector.<Activators> = new Vector.<Activators>();
					FP.world.getClass(Activators, v);
					for (var i:int = 0; i < v.length; i++)
					{
						if (v[i] != this && v[i].t == t)
						{
							v[i].activate = persist;
						}
					}
				}
				else
				{
					Game.setPersistence(t, persist, room); //persist = false, then things won't exist.  persist = true, then they will.
				}
				sprButtonRoom.frame = int(_active) + frameAdd;
				Game.setPersistence(tag, !activate);
			}
		}
		
	}

}