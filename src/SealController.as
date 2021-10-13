package  
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Draw;
	import flash.display.BlendMode;
	import Scenery.FinalDoor;
	/**
	 * ...
	 * @author Time
	 */
	public class SealController extends Entity
	{
		[Embed(source = "../assets/graphics/Seal.png")] private static var imgSeal:Class;
		private static var sprSeal:Spritemap = new Spritemap(imgSeal, 4, 4);
		
		public static const SEALS:int = 16;
		private var scale:Number = 4;
		private const rows:int = 4;
		private const cols:int = 4;
		
		private var waitTime:int = 60; //The time that this waits at peak darkness
		private const alphaSteps:int = 60; //The time that this takes to reach full darkness
		private var alphaStep:int = 0;
		private var alpha:Number = 0;
		
		private var showNewest:Boolean;
		private var parent:FinalDoor;
		private var backBmp:BitmapData;
		
		public var text:String; //Set this to display centered text at the bottom of the screen.
		private var textO:Text;
		
		private var playedSound:Boolean = false;
		
		public function SealController(_showNewest:Boolean=true, _parent:FinalDoor=null, _text:String="") 
		{
			Game.freezeObjects = true;
			layer = -FP.height*2;
			sprSeal.centerOO();
			
			showNewest = _showNewest;
			parent = _parent;
			text = _text;
			
			Text.size = 8;
			textO = new Text(text);
			Text.size = 16;
		}
		
		public static function getSealPart(index:int):Boolean
		{
			var last:int = -1;
			if (hasAllSealParts())
			{
				return true;
			}
			for (var i:int = 0; i < SEALS; i++)
			{
				if (Main.hasSealPart(i) == index)
				{
					return false;
				}
				else if (Main.hasSealPart(i) == -1)
				{
					last = i;
					break;
				}
			}
			if (last >= 0 && last < SEALS)
			{
				Main.hasSealPartSet(last, index);
			}
			return true;
		}
		
		public static function hasAllSealParts():Boolean
		{
			return Main.hasSealPart(SEALS - 1) != -1;
		}
		
		override public function update():void
		{
			if (alphaStep >= alphaSteps)
			{
				var p:Player = FP.world.nearestToEntity("Player", this) as Player;
				if(!p || (p && Input.released(p.keys[6])))
				{
					FP.world.remove(this);
				}
			}
			
			if (alphaStep >= alphaSteps && waitTime > 0)
			{
				waitTime--;
			}
			else if(alphaStep < alphaSteps * 2)
			{
				alphaStep++;
			}
			else
			{
				FP.world.remove(this);
			}
			alpha = ( -Math.cos(alphaStep / alphaSteps * Math.PI) + 1) / 2;
		}
		
		override public function render():void
		{
			//(FP.world as Game).drawCover(0, 0.75);
			drawCover(alpha);
			Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
			drawCover(alpha);
			Draw.setTarget((FP.world as Game).solidBmp, FP.camera);
			drawCover(alpha);
			Draw.resetTarget();
			if (!backBmp)
			{
				backBmp = new BitmapData(sprSeal.width * cols, sprSeal.height * rows, true, 0x00000000);
				Draw.setTarget(backBmp);
				for (var i:int = 0; i < SEALS; i++)
				{
					sprSeal.alpha = 1;
					sprSeal.frame = i % sprSeal.frameCount;
					setScale(i, 1);
					sprSeal.render(new Point(sprSeal.originX + sprSeal.width * Math.floor(i / rows), sprSeal.originY + sprSeal.height * (i % rows)), new Point);
				}
				Draw.resetTarget();
				backBmp.threshold(backBmp, backBmp.rect, new Point, ">", 0, 0xFFFFFFFF);
			}
			else
			{
				var m:Matrix = new Matrix();
				m.scale(scale, scale);
				m.translate(FP.screen.width / 2 - sprSeal.width * scale * cols / 2, FP.screen.height / 2 - sprSeal.height * scale * rows / 2);
				var c:ColorTransform = new ColorTransform(1, 1, 1, 0.25 * alpha);
				FP.buffer.draw(backBmp, m, c);
				(FP.world as Game).nightBmp.draw(backBmp, m, new ColorTransform(1,1,1,alpha));
				(FP.world as Game).solidBmp.draw(backBmp, m, new ColorTransform(1,1,1,alpha));
			}
			sprSeal.alpha = alpha;
			for (i = 0; i < SEALS; i++)
			{
				var j:int = Main.hasSealPart(i);
				if (j == -1)
				{
					break;
				}
				sprSeal.frame = j % sprSeal.frameCount;
				setScale(j);
				
				if (i + 1 < SEALS && Main.hasSealPart(i + 1) == -1 && alphaStep <= alphaSteps && showNewest)
				{
					sprSeal.scale = (1 - alpha) * 100 + 1;
					sprSeal.alpha /= sprSeal.scale;
					
					if (sprSeal.scale <= 1 && !playedSound)
					{
						Music.abruptThenFade(Music.sndOSeal);
						playedSound = true;
					}
				}
				Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
				renderSeal(j);
				Draw.setTarget((FP.world as Game).solidBmp, FP.camera);
				renderSeal(j);
				Draw.resetTarget();
				renderSeal(j);
				sprSeal.scale = 1;
				sprSeal.alpha = alpha;
			}
			
			if (text != "")
			{
				const margin:int = 16; //the margin from the bottom of the screen.
				textO.alpha = alpha;
				textO.render(new Point(FP.screen.width / 2 - textO.width/2, FP.screen.height - margin - textO.height), new Point);
			}
		}
		
		private function setScale(j:int, sc:Number=-1234):void
		{
			if (sc == -1234)
			{
				sc = scale;
			}
			sprSeal.scaleX = sc;
			if (j >= sprSeal.frameCount)
			{
				sprSeal.frame = (j + sprSeal.frameCount/2) % sprSeal.frameCount;
				sprSeal.scaleX = -sc;
			}
			sprSeal.scaleY = sc;
		}
		
		private function renderSeal(j:int):void
		{
			sprSeal.render(new Point(FP.screen.width / 2 + scale * sprSeal.originX + scale * sprSeal.width * (Math.floor(j / rows) - cols / 2), FP.screen.height / 2 + scale * sprSeal.originY + scale * sprSeal.height * (j % rows - rows / 2)), new Point);
		}
		
		private function drawCover(a:Number):void
		{
			Draw.rect(FP.camera.x, FP.camera.y, FP.screen.width, FP.screen.height, 0, a);
		}
		
		override public function removed():void
		{
			Game.freezeObjects = false;
			if (parent)
			{
				parent.mySealController = null;
			}
			Music.bkgdVolumeMaxExtern = Music.fadeVolumeMaxExtern = 1; //Restore the volume after it is shown.
			//(FP.world as Game).undrawCover();
		}
		
	}

}