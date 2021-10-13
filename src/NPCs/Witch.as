package NPCs 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import Pickups.DarkSword;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class Witch extends NPC
	{
		[Embed(source = "../../assets/graphics/NPCs/Witch.png")] private var imgWitch:Class;
		private var sprWitch:Spritemap = new Spritemap(imgWitch, 16, 13);
		[Embed(source = "../../assets/graphics/NPCs/WitchPic.png")] private var imgWitchPic:Class;
		private var sprWitchPic:Image = new Image(imgWitchPic);
		
		private const textExtra:String = "Oh, you found the wand!~You must be very powerful and your goals noble.~Here is an enchantment to improve your sword!";
		private const textExtra1:String = "May you do only good with that sword.~I presume you can be trusted?";
		
		public function Witch(_x:int, _y:int, _tag:int=-1, _text:String="", _talkingSpeed:int=10) 
		{
			super(_x, _y, sprWitch, _tag, _text, _talkingSpeed);
			sprWitch.add("talk", [0, 1], 5);
			myPic = sprWitchPic;
		}
		
		override public function update():void
		{
			if (Main.hasWand)
			{
				if (Main.hasDarkSword)
				{
					prepNewText(textExtra1);
				}
				else
				{
					prepNewText(textExtra);
				}
			}
			super.update();
		}
		
		override public function doneTalking():void
		{
			if (Main.hasWand && !Main.hasDarkSword)
			{
				var p:Player = FP.world.nearestToPoint("Player", x, y) as Player;
				FP.world.add(new DarkSword(p.x - Tile.w/2, p.y - Tile.h/2));
			}
		}
		
		override public function render():void
		{
			if (talking)
			{
				sprWitch.play("talk");
			}
			else
			{
				sprWitch.frame = Game.worldFrame(2);
			}
			super.render();
		}
		
	}

}