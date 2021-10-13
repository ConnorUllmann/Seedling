package  
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Time
	 */
	public class Message extends Entity
	{
		private static const titles:Array = new Array("Gundernourd", "Rostef", "Lacste", "Trohn", "Woshad", "Bosiniad", "Ghethis");
		private static const subtitles:Array = new Array("true beginnings", "stuck in the forest", "trick and mortar", "cold realizations", "stab in the dark", "burning tremors", "falling from on high");
		private static const titleColor:Array = new Array(0xBA8BB7, 0x85DC5A, 0x9C43A4, 0x9F9FFF, 0x976464, 0xE8A94A, 0xDBE9F7);
		private static const subtitleColor:Array = new Array(0x76518C, 0x3E8525, 0x7378A4, 0x6E6EFF, 0x5E4141, 0xCB5821, 0x85C9AF);
		private static const titleSize:int = 16;
		private static const subtitleSize:int = 8;
		
		private var titleText:Text;
		private var subtitleText:Text;
		
		private var alpha:Number = 2.5;
		private const rectColor:uint = 0;
		
		//top-center aligned
		
		public function Message(_x:int, _y:int, _sign:int) 
		{
			super(_x, _y);
			Text.size = titleSize;
			titleText = new Text(titles[_sign]);
			Text.size = subtitleSize;
			subtitleText = new Text(subtitles[_sign]);
			Text.size = 16;
			titleText.color = titleColor[_sign];
			subtitleText.color = subtitleColor[_sign];
			
			visible = false;
		}
		
		override public function render():void
		{
			if (alpha > 0)
			{
				alpha -= 0.01;
				if (alpha <= 0)
				{
					FP.world.remove(this);
					return;
				}
			}
			
			const h:int = titleText.height + subtitleText.height;
			Draw.rect(FP.camera.x, y + FP.camera.y, FP.screen.width, h * 5/6, rectColor, Math.min(alpha, 1));
			
			titleText.alpha = subtitleText.alpha = Math.min(1, alpha);
			titleText.render(new Point(x - titleText.width/2, y), new Point);
			subtitleText.render(new Point(x - subtitleText.width/2, y + titleText.height * 2/3), new Point);
		}
		
	}

}