package
{
	import com.newgrounds.components.FlashAd;
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.getDefinitionByName;
	import com.newgrounds.*;
	import net.flashpunk.utils.Input;

	[SWF(width = "480", height = "480")]
	public class Preloader extends Sprite
	{
		public static const sponsorVersion:Boolean = false;
		
		
		public static var URL:String;
		// Change these values
		private static const mustClick: Boolean = false;
		private static const mainClassName: String = "Main";
		
		private static const BG_COLOR:uint = 0x000000;
		private static const FG_COLOR:uint = 0xFFFFFF;
		
		
		[Embed(source = '../assets/graphics/pixel_logo_large.png')] public static var imgNG:Class;
		private static var sprNG:DisplayObject = new imgNG();
		
		[Embed(source = 'net/flashpunk/graphics/04B_03__.TTF', fontFamily = 'default')]
		private static const FONT:Class;
		
		
		
		// Ignore everything else
		
		public static var LOCAL:Boolean = false;
		public static var JAYISGAMES:Boolean = false;
		public static var ARMORGAMES:Boolean = false;
		public static var CONNORULLMANN:Boolean = false;
		public static var KONGREGATE:Boolean = false;
		public static var NEWGROUNDS:Boolean = false;
		public static var FREEWORLDGROUP:Boolean = false;
		public static var ANDKON:Boolean = false;
		
		
		private static const NGAPPID:String = "26353:sQcLm12P";
		private static const NGENCRYPTIONKEY:String = "F1PhADGhzfgTvJe04kYcrbVn8kjUkljt";
		
		
		private var progressBar: Shape;
		private var text: TextField;
		
		private var px:int;
		private var py:int;
		private var w:int;
		private var h:int;
		private var sw:int;
		private var sh:int;
		
		private var flashAd:FlashAd;
		private var promoRect:Rectangle;
		
		public function Preloader ()
		{
			URL = root.stage.loaderInfo.url;
			
			LOCAL = checkDomain() == 2;
			JAYISGAMES = checkDomain(["jayisgames.com"]) == 1;
			ARMORGAMES = checkDomain(["http://games.armorgames.com", "http://preview.armorgames.com", "http://cache.armorgames.com", "http://cdn.armorgames.com", 
									  "http://gamemedia.armorgames.com", "http://*.armorgames.com", "armorgames.com"]) == 1;
			CONNORULLMANN = checkDomain(["connorullmann.com"]) == 1;
			KONGREGATE = checkDomain(["kongregate.com"]) == 1;
			NEWGROUNDS = checkDomain(["newgrounds.com", "ungrounded.net"]) == 1;
			FREEWORLDGROUP = checkDomain(["freeworldgroup.com"]) == 1;
			ANDKON = checkDomain(["andkon.com"]) == 1;
			
			if (!ARMORGAMES && !KONGREGATE)
				API.connect(root, NGAPPID, NGENCRYPTIONKEY);
			if (KONGREGATE)
				QuickKong.connectToKong(stage);
			
			sw = stage.stageWidth;
			sh = stage.stageHeight;
			
			if (sponsorVersion && !CONNORULLMANN)
				return;
			
			if (ARMORGAMES || KONGREGATE || CONNORULLMANN || FREEWORLDGROUP || ANDKON)
			{
				addChild(sprNG);
				sprNG.x = (sw - sprNG.width) / 2;
				sprNG.y = (sh - sprNG.height) / 3;
				
				promoRect = new Rectangle(sprNG.x, sprNG.y, sprNG.width, sprNG.height);
			}
			else
			{
				flashAd = new FlashAd();
				addChild(flashAd);
				flashAd.x = (sw - flashAd.width) / 2;
				flashAd.y = (sh - flashAd.height) / 3;
				flashAd.showPlayButton = false;
				flashAd.playButton.visible = false;
				flashAd.playButton.addEventListener(MouseEvent.MOUSE_UP, onPlayClick);
				
				promoRect = new Rectangle(flashAd.x, flashAd.y, flashAd.width, flashAd.height);
			}
			
			
			w = stage.stageWidth * 0.8;
			h = 20;
			
			px = (sw - w) * 0.5;
			py = (sh + promoRect.y + promoRect.height - h) / 2;
			
			graphics.beginFill(BG_COLOR);
			graphics.drawRect(0, 0, sw, sh);
			graphics.endFill();
			
			graphics.beginFill(FG_COLOR);
			graphics.drawRect(px - 2, py - 2, w + 4, h + 4);
			graphics.endFill();
			
			progressBar = new Shape();
			
			addChild(progressBar);
			
			text = new TextField();
			
			text.textColor = FG_COLOR;
			text.selectable = false;
			text.mouseEnabled = false;
			text.defaultTextFormat = new TextFormat("default", 16);
			text.embedFonts = true;
			text.autoSize = "left";
			text.text = "0%";
			text.x = (sw - text.width) * 0.5;
			text.y = py - text.height - 2;
			
			addChild(text);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if (mustClick) {
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}
		
		public function onPlayClick(e:MouseEvent):void
		{
			flashAd.playButton.removeEventListener(MouseEvent.MOUSE_UP, onPlayClick);
			load();
		}

		public function onEnterFrame (e:Event): void
		{
			if (hasLoaded()) //flashAd.currentFrame >= flashAd.totalFrames
			{	
				if (flashAd)
				{
					flashAd.showPlayButton = true;
					if(flashAd.playButton)
						flashAd.playButton.visible = true;
				}
				else
				{
					load();
				}
				if (text.alpha > 0)
					text.alpha -= 0.005;
			}
			
			var p:Number = (loaderInfo.bytesLoaded / loaderInfo.bytesTotal);
			
			progressBar.graphics.clear();
			progressBar.graphics.beginFill(BG_COLOR);
			progressBar.graphics.drawRect(px, py, p * w, h);
			progressBar.graphics.endFill();
			
			text.text = hasLoaded() ? "Done!" : int(p * 100) + "%";
			text.x = (sw - text.width) * 0.5;
		}
		private function load():void
		{
			graphics.clear();
			graphics.beginFill(BG_COLOR);
			graphics.drawRect(0, 0, sw, sh);
			graphics.endFill();
			
			if (! mustClick) {
				startup();
			} else {
				text.scaleX = 2.0;
				text.scaleY = 2.0;
			
				text.text = "Click to start";
				text.y = (sh - text.height) * 0.5;
			}
		}
		
		private function onMouseDown(e:MouseEvent):void {
			if (hasLoaded())
			{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				startup();
			}
		}
		
		private function hasLoaded (): Boolean {
			return (loaderInfo.bytesLoaded >= loaderInfo.bytesTotal);
		}
		
		private function startup (): void {
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var mainClass:Class = getDefinitionByName(mainClassName) as Class;
			parent.addChild(new mainClass as DisplayObject);
			
			parent.removeChild(this);
		}
		
		public static function checkDomain(allowed:*=""):int
		{
			var url:String = Preloader.URL;
			var startCheck:int = url.indexOf('://' ) + 3;
			if (url.substr(0, startCheck) == 'file://') return 2;
			var domainLen:int = url.indexOf('/', startCheck) - startCheck;
			var host:String = url.substr(startCheck, domainLen);
			if (allowed is String) allowed = [allowed];
			for each (var d:String in allowed)
			{
				if (host.substr(-d.length, d.length) == d) return 1;
			}
			return 0;
		}
	}
}