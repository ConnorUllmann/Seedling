package Puzzlements 
{
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Time
	 */
	public class ShieldLock extends Lock
	{
		[Embed(source = "../../assets/graphics/ShieldLockNorm.png")] private var imgShieldLockNorm:Class;
		private var sprShieldLockNorm:Spritemap = new Spritemap(imgShieldLockNorm, 16, 16);
		[Embed(source = "../../assets/graphics/ShieldLock.png")] private var imgShieldLock:Class;
		private var sprShieldLock:Spritemap = new Spritemap(imgShieldLock, 16, 16);
		
		private var p:Player;
		private var shieldType:int;
		
		/**
		 * @param	_x		The x-placement of the block
		 * @param	_y		The y-placement of the block
		 * @param	_tag	The tag for saving
		 * @param	_type	Represents which shield type (0=normal, 1=dark)
		 */
		public function ShieldLock(_x:int, _y:int, _tag:int=-1, _type:int=1) 
		{
			super(_x, _y, -2, _tag, _type==0 ? sprShieldLockNorm : sprShieldLock);
			shieldType = _type;
		}
		
		override public function update():void
		{
			p = collide("Player", x - 1, y) as Player;
			if (p && !activate && ((Player.hasDarkShield && shieldType == 1) || (Player.hasShield && shieldType == 0)))
			{
				p.y = y - originY + 7;
				p.directionFace = 0;
				p.receiveInput = false;
				activate = true;
			}
			activationStep();
		}
		
		override public function turnOff():void
		{
			super.turnOff();
			if (p)
			{
				p.directionFace = -1;
				p.receiveInput = true;
			}
		}
		
	}

}