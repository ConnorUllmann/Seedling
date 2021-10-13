package Puzzlements 
{
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Time
	 */
	public class PushableBlockSpear extends PushableBlockFire
	{
		
		public function PushableBlockSpear(_x:int, _y:int) 
		{
			super(_x, _y);
			moveTypes = new Array("Spear");
			(graphic as Image).color = 0x8822FF;
		}
		
	}

}