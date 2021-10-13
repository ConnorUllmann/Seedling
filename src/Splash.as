package  
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Time
	 */
	public class Splash extends World
	{
		[Embed(source = '../assets/graphics/pixel_logo_large.png')] public static var imgNG:Class;
		[Embed(source = '../assets/graphics/OctoLogo.png')] public static var imgOctoLogo:Class;
		[Embed(source = '../assets/graphics/rackemmap-162Wx158H.png')] public static var imgRekcahdamLogo:Class;
		[Embed(source = '../assets/graphics/musicby.png')] public static var imgMusicBy:Class;
		private var spMusicBy:DisplayObject = new imgMusicBy();
		
		public var sp:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		private static const WIDTH:int = 480;
		private static const HEIGHT:int = 480;
		private static const url:Object = ["http://www.newgrounds.com/", "http://www.connorullmann.com/", "http://www.rekcahdam.com/"];
		
		private const frameWidth:int = 162;
		private const frameHeight:int = 158;
		private var rows:int;
		private var cols:int;
		private var frameCount:int;
		private const frameSpeed:Number = 0.1;
		private var frame:Number = 0;
		private const extraFadeFrames:int = 3;
		
		public static const rek:int = 2;
		private var t:int;
		
		private var timerSplash:int = 150;
		private var timerAll:int = timerSplash;
		
		public var percentageFinished:Number = 1 - timerSplash / timerAll;
		
		public function Splash(_t:int=0)
		{
			t = _t;
			
			sp.push(new imgNG(), new imgOctoLogo(), new imgRekcahdamLogo());
			
			for (var i:int = 0; i < sp.length; i++)
			{
				sp[i].visible = false;
			}
			
			spMusicBy.visible = false;
			rows = sp[rek].height / frameHeight;
			cols = sp[rek].width / frameWidth;
			frameCount = rows * cols;
		}
		override public function begin():void
		{
			FP.engine.addChild(sp[t]);
			if (t == rek)
				FP.engine.addChild(spMusicBy);
		}
		override public function end():void
		{
			FP.engine.removeChild(sp[t]);
			if (t == rek)
				FP.engine.removeChild(spMusicBy);
			Mouse.cursor = MouseCursor.ARROW;
		}
		override public function update():void
		{
			super.update();
			alpha();
			checkBegin();
			link();
			
			if (t == rek)
			{
				spMusicBy.x = WIDTH / 2 - spMusicBy.width/2;
				spMusicBy.y = sp[t].y - spMusicBy.height - 10;
				spMusicBy.alpha = sp[t].alpha;
				spMusicBy.visible = true;
				
				sp[t].visible = true;
				
				frame += frameSpeed;
				if(frame >= frameCount)
				{
					sp[t].alpha = 1 - (frame - frameCount) / extraFadeFrames;
				}
				const cframe:int = Math.min(Math.floor(frame), frameCount - 2);
				sp[t].scrollRect = new Rectangle(cframe % cols * frameWidth, Math.floor(cframe / cols) * frameHeight, frameWidth, frameHeight);
				sp[t].x = WIDTH/2 - frameWidth / 2;
				sp[t].y = HEIGHT/2 - frameHeight / 2;
			}
			else
			{
				sp[t].visible = true;
				sp[t].x = WIDTH / 2 - sp[t].width / 2;
				sp[t].y = HEIGHT / 2 - sp[t].height / 2;
			}
		}
		
		public function alpha():void
		{
			if (t == rek)
				return;
			percentageFinished = 1 - timerAll / timerSplash;
			if (percentageFinished <= 0.25)
			{
				sp[t].alpha = percentageFinished * 4;
			}
			else if (percentageFinished < 0.75)
			{
				sp[t].alpha = 1;
			}
			else
			{
				sp[t].alpha = 1 - (percentageFinished - 0.75) * 4;
			}
		}
		
		public function checkBegin():void
		{
			if ((t != rek && timerAll <= 0) || (t == rek && frame >= frameCount + extraFadeFrames))
			{
				startMenu();
				return;
			}
			else
			{
				timerAll--;
			}
		}
		
		public function link():void
		{
			if (inBounds())
			{
				Mouse.cursor = MouseCursor.BUTTON;
				if (Input.mouseReleased)
				{
					new GetURL(url[t]);
				}
			}
			else
			{
				Mouse.cursor = MouseCursor.ARROW;
			}
		}
		
		public function startMenu():void
		{
			if (t + 1 >= sp.length)
			{
				Mouse.cursor = MouseCursor.ARROW;
				if (Main.level == -1)
				{
					FP.world = new Game();// 41, 240, 112);// 112, 96, 208);
				}
				else
				{
					FP.world = new Game(Main.level, Main.playerPositionX, Main.playerPositionY);
				}
			}
			else
			{
				FP.world = new Splash(t + 1);
			}
		}
		
		public function inBounds():Boolean
		{
			return FP.engine.mouseX >= sp[t].x && FP.engine.mouseY >= sp[t].y && FP.engine.mouseX <= sp[t].x + sp[t].width && FP.engine.mouseY <= sp[t].y + sp[t].height;
		}
		
	}

}