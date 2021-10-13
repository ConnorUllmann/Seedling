package Pickups
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import Scenery.Tile;
	/**
	 * ...
	 * @author Time
	 */
	public class Seed extends Pickup
	{
		[Embed(source = "../../assets/graphics/Seed.png")] private var imgSeed:Class;
		private var sprSeed:Spritemap = new Spritemap(imgSeed, 9, 13);
		[Embed(source = "../../assets/graphics/SeedBloody.png")] private var imgSeedBloody:Class;
		private var sprSeedBloody:Spritemap = new Spritemap(imgSeedBloody, 11, 15);
		
		[Embed(source = "../../assets/graphics/TreeGrow.png")] private var imgTreeGrow:Class;
		public var sprTreeGrow:Spritemap = new Spritemap(imgTreeGrow, 16, 24, endAnim);
		
		private const sitFrames:Object = [0, 1, 2, 1];
		private var drawCover:Boolean = false;
		
		private var coverAlpha:Number = 0;
		private const coverAlphaRate:Number = 0.005;
		
		private var bloody:Boolean;
		public var tree:Boolean = false;
		
		public function Seed(_x:int, _y:int, _bloody:Boolean = false, _text:String="", _tree:Boolean=false) 
		{
			super(_x + Tile.w/2, _y + Tile.h/2, _bloody ? sprSeedBloody : sprSeed, null, false);
			sprSeed.centerOO();
			sprSeedBloody.centerOO();
			
			bloody = _bloody;
			
			setHitbox(10, 14, 5, 7);
			
			special = true;
			text = _text;
			
			tree = _tree;
			if (tree)
			{
				graphic = sprTreeGrow;
				sprTreeGrow.add("grow", [0, 0, 0, 0, 1, 0, 1, 2, 2, 1, 2, 3, 4, 4, 5, 6], 3.5);
				sprTreeGrow.add("grown", [6]);
				sprTreeGrow.originX = sprTreeGrow.width / 2;
				sprTreeGrow.originY = sprTreeGrow.height * 2 / 3;
				sprTreeGrow.x = -sprTreeGrow.originX;
				sprTreeGrow.y = -sprTreeGrow.originY;
				sprTreeGrow.play("grow");
			}
		}
		
		public function destroySilently():void
		{
			FP.world.remove(this);
		}
		
		override public function update():void
		{
			if (drawCover)
			{
				(FP.world as Game).drawCover(0, coverAlpha);
				coverAlpha += coverAlphaRate;
				if (coverAlpha >= 1)
				{
					//GAME WON
					if (bloody)
					{
						Game.cutscene[1] = true;
						FP.world = new Game(1, 64, 96, false);
					}
					else if (tree)
					{
						Game.menu = true;
						Game.cutscene[2] = false;
						Main.unlockMedal(Main.badges[14]);
						FP.world = new Game((FP.world as Game).level, Game.currentPlayerPosition.x, Game.currentPlayerPosition.y, false, 2);
					}
					else
					{
						Game.cutscene[2] = true;
						FP.world = new Game((FP.world as Game).level, Game.currentPlayerPosition.x, Game.currentPlayerPosition.y);
					}
				}
			}
			else if(!tree)
			{
				super.update();
			}
		}
		
		private function endAnim():void
		{
			sprTreeGrow.play("grown");
			drawCover = true;
		}
		
		override public function removeSelf():void
		{
			Game.freezeObjects = true;
			drawCover = true;
		}
		
		override public function render():void
		{
			if (!tree)
			{
				(graphic as Spritemap).frame = sitFrames[Game.worldFrame(sitFrames.length)];
			}
			super.render();
		}
		
	}

}