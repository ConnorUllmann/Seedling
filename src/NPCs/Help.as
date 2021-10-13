package NPCs 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Time
	 */
	public class Help extends Entity
	{
		[Embed(source = "../../assets/graphics/Help.png")] private var imgHelp:Class;
		private var sprHelp:Spritemap = new Spritemap(imgHelp, 67, 44);
		//Inventory
		//Mute
		//Move
		//Attack
		private static const keys:Array = new Array(new Array(Key.V, Key.V), new Array(Key.ANY, Key.M), new Array(Key.RIGHT, Key.UP, Key.LEFT, Key.DOWN), new Array(Key.X, Key.C))
		private var remove:Boolean = false;
		private var button:Boolean;
		private var pt:Point;
		
		private var disappearRate:Number = 0.1;
		private const scMax:Number = 1.5;
		private const scMin:Number = 1;
		private var scRate:Number = 0.01;
		private var sc:Number = scMin;
		
		private var timeExtraHelp:int = 240;
		private const texts:Array = new Array("press V", "press M to mute", "press an arrow key", "press X or C");
		
		public function Help(_t:int = 0, _button:Boolean = true, _p:Point=null) 
		{
			super(0,0,sprHelp);
			sprHelp.frame = _t;
			sprHelp.centerOO();
			
			button = _button;
			
			layer = -FP.height * 2;
			visible = false;
			
			if (_p)
			{
				pt = _p.clone();
			}
			else
			{
				const margin:int = 16;
				pt = new Point(FP.screen.width / 2, FP.screen.height - sprHelp.height / 2 - margin);
			}
			
			if (sprHelp.frame == 1)
			{
				timeExtraHelp = 0;
				disappearRate = 0.0075;
			}
		}
		
		override public function update():void
		{
			super.update();
			
			if (timeExtraHelp > 0)
			{
				timeExtraHelp--;
			}
			
			sc += scRate;
			if (sc <= scMin)
			{
				sc = scMin;
				scRate = -scRate;
			}
			else if (sc >= scMax)
			{
				sc = scMax;
				scRate = -scRate;
			}
			sprHelp.color = FP.colorLerp(0xFFFFFF, 0x0000FF, Math.sin(sc / (scMax - scMin) * Math.PI));
			
			if (button)
			{
				var hitKey:Boolean = false;
				for (var i:int = 0; i < keys[sprHelp.frame].length; i++)
				{
					if (Input.pressed(keys[sprHelp.frame][i]))
					{
						hitKey = true;
						break;
					}
				}
				
				if (hitKey)
				{
					remove = true;
				}
				Game.freezeObjects = true;
				if (remove)
				{
					sprHelp.alpha -= disappearRate;
					if (sprHelp.frame != 1)
					{
						Game.freezeObjects = false;
					}
					if (sprHelp.alpha <= 0)
					{
						if (sprHelp.frame == 0)
						{
							Game.inventory.open = true;
						}
						Game.freezeObjects = false;
						FP.world.remove(this);
					}
				}
			}
		}
		
		override public function render():void
		{			
			if (timeExtraHelp <= 0)
			{
				Text.size = 8;
				var t:Text = new Text(texts[sprHelp.frame]);
				Text.size = 16;
				
				var ptText:Point = new Point(pt.x - t.width / 2, FP.screen.height - t.height);
				t.alpha = sprHelp.alpha;
				t.color = sprHelp.color;
				t.render(new Point(ptText.x - 1, ptText.y), new Point);
				t.render(new Point(ptText.x + 1, ptText.y), new Point);
				t.render(new Point(ptText.x, ptText.y - 1), new Point);
				t.render(new Point(ptText.x, ptText.y + 1), new Point);
				t.color = 0;
				t.render(ptText.clone(), new Point);
				Draw.setTarget((FP.world as Game).nightBmp, new Point);
				t.render(ptText.clone(), new Point);
				Draw.resetTarget();
			}
			
			if (sprHelp.frame != 1)
			{
			sprHelp.render(pt.clone(), new Point);
			Draw.setTarget((FP.world as Game).nightBmp, new Point);
			sprHelp.render(pt.clone(), new Point);
			Draw.resetTarget();
			}
		}
		
	}

}