package Puzzlements
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	/**
	 * ...
	 * @author Time
	 */
	public class Activators extends Entity
	{
		public var _active:Boolean = false;
		public var tSet:int;
		
		public function Activators(_x:int, _y:int, _g:Graphic, _t:int) 
		{
			super(_x, _y, _g);
			t = _t;
		}
		
		public function set activate(a:Boolean):void
		{
			_active = a;
		}
		
		public function get activate():Boolean
		{
			return _active;
		}
		
		public function set t(_t:int):void
		{
			tSet = _t;
		}
		
		public function get t():int
		{
			return tSet;
		}
		
	}

}