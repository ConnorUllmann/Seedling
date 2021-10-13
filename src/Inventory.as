package  
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Draw;
	import NPCs.Help;
	import NPCs.NPC;
	import Enemies.BobBoss;
	/**
	 * ...
	 * @author Time
	 */
	public class Inventory 
	{		
		//NOT an entity, so render is called explicitly by Game.
		
		[Embed(source = "../assets/graphics/Inventory.png")] private static var imgInventory:Class;
		private static var sprInventory:Image = new Image(imgInventory);
		[Embed(source = "../assets/graphics/InventoryItems.png")] private static var imgInventoryItems:Class;
		private static var sprInventoryItems:Spritemap = new Spritemap(imgInventoryItems, 17, 17);
		[Embed(source = "../assets/graphics/InventoryItemsSide.png")] private static var imgInventoryItemsSide:Class;
		private static var sprInventoryItemsSide:Spritemap = new Spritemap(imgInventoryItemsSide, 8, 8);
		[Embed(source = "../assets/graphics/InventoryItemsTotem.png")] private static var imgInventoryItemsTotem:Class;
		private static var sprInventoryItemsTotem:Spritemap = new Spritemap(imgInventoryItemsTotem, 16, 24);
		[Embed(source = "../assets/graphics/tank.png")] private static var imgTank:Class;
		private static var sprTank:Image = new Image(imgTank);
		
		public static const width:int = sprInventory.width;
		public static const height:int = sprInventory.height;
		public static var help:Boolean = true;
		
		private var _open:Boolean;
		
		private const movementDivisor:int = 5;
		public static const offsetMin:Point = new Point(-70, FP.screen.height / 2 - sprInventory.height / 2);
		public static var offsetMax:Point = new Point(0, offsetMin.y);
		public static var offset:Point = new Point();
		
		private var itemOffset:Point = new Point(40, 24);
		private const itemOffsetIncrement:Point = new Point(0, 32);
		
		private const keyPositions:Array = new Array(new Point(2, 60), new Point(15, 60), new Point(2, 72), new Point(15, 72), new Point(9, 84));
		private const sidePositions:Array = new Array(new Point(9, 107), new Point(3, 119), new Point(15, 119));
		private const totemPosition:Point = new Point(5, 19);
		
		private var selected:int = 0;
		private static var items:Array = new Array();
		
		private const scaleMin:Number = 1;
		private const scaleMax:Number = 1.5;
		private const scaleRate:Number = 0.1;
		private var scale:Number = scaleMin;
		
		private const textScaleMin:Number = 1;
		private const textScaleMax:Number = 2;
		private const textScaleRate:Number = 0.2;
		private var textScale:Array = new Array(textScaleMin, textScaleMin);
		
		public static var drawFirstUseHelp:Boolean = false;
		public static var drawExtendedHelp:Boolean = false;
		private var textIndex:int = 0; // The index of the help page that is open
		private static var FUtexts:Array = new Array(
											"This is your inventory. To open/close it, press <V>.", 
											"Pick your weapons and the buttons you press to use them", 
											"Pick a weapon's button by moving up/down, and then press X/C to assign that button.");
		private static var EXtexts:Array = new Array("This new tab shows your keys and other items you've obtained.");
		
		public function Inventory() 
		{
			offset.x = offsetMin.x;
			offset.y = offsetMin.y;
			
			sprInventoryItems.centerOO();
			
			for (var i:int = 0; i < FUtexts.length; i++)
			{
				FUtexts[i] = NPC.endlineText(FUtexts[i], 24);
			}
			for (i = 0; i < EXtexts.length; i++)
			{
				EXtexts[i] = NPC.endlineText(EXtexts[i], 18);
			}
		}
		
		public function check():void
		{
			open = false;
		}
		
		public static function clearItems():void
		{
			items = new Array();
		}
		public static function addItem(i:int, pos:int=-1):void
		{
			if (pos >= 0)
			{
				items.splice(pos, 0, i);
			}
			else
			{
				items.push(i);
			}
		}
		public static function removeItem(item:int):void
		{
			for (var i:int = 0; i < items.length; i++)
			{
				if (getItem(i) == item)
				{
					items.splice(i, 1);
				}
			}
			Main.primary = Main.primary % items.length;
			Main.secondary = Main.secondary % items.length;
		}
		public static function hasItem(item:int):Boolean
		{
			for (var i:int = 0; i < items.length; i++)
			{
				if (getItem(i) == item)
				{
					return true;
				}
			}
			return false;
		}
		public static function getItem(i:int):int
		{
			return items[i];
		}
		
		public function set open(_o:Boolean):void
		{
			Game.freezeObjects = _open = _o;
		}
		
		public function get open():Boolean
		{
			return _open;
		}
		
		public function update():void
		{
			if (Game.cheats)
			{
				firstUse = extended = true;
				drawFirstUseHelp = drawExtendedHelp = false;
			}
			else
			{
				if (items.length >= 2 && !firstUse)
				{
					if (help)
					{
						FP.world.add(new Help(0));
					}
					firstUse = true;
				}
				if (firstUse && !extended && (Player.canSwim || Player.hasFeather || Player.hasTotemPartNumber() > 0))
				{
					extended = true;
				}
			}
			if (drawFirstUseHelp)
			{
				Game.freezeObjects = true;
			}
			
			addItemsFromSave();
			
			var p:Player = FP.world.nearestToPoint("Player", 0, 0) as Player;
			if (p && (!Game.freezeObjects || open))
			{
				if ((Input.released(p.keys[7]) || Input.released(p.keys[8])) && firstUse && !drawFirstUseHelp && !drawExtendedHelp)
				{
					open = !open;
				}
				if (open)
				{
					var tSelected:int = selected;
					if (Input.released(p.keys[1])) //Up
					{
						selected = (selected - 1 + items.length) % items.length;
					}
					if (Input.released(p.keys[3])) //Down
					{
						selected = (selected + 1) % items.length;
					}
					if (Input.released(p.keys[4])) //Primary
					{
						Main.primary = selected;
						textScale[0] = textScaleMax;
					}
					if (Input.released(p.keys[5])) //Secondary
					{
						Main.secondary = selected;
						textScale[1] = textScaleMax;
					}
					if (Input.pressed(p.keys[7]) || Input.pressed(p.keys[8])) //Inventory
					{
						if (drawFirstUseHelp || drawExtendedHelp)
						{
							textIndex++;
							if (drawFirstUseHelp)
							{
								if (textIndex >= FUtexts.length)
								{
									drawFirstUseHelp = false;
									textIndex = 0;
								}
							}
							if (drawExtendedHelp)
							{
								if (textIndex >= EXtexts.length)
								{
									drawExtendedHelp = false;
									textIndex = 0;
								}
							}
						}
					}
					
					//Tank checking
					var m:Point = new Point(Input.mouseX, Input.mouseY);
					var pt:Point = ngTankPos();
					if (m.x >= pt.x - sprTank.originX && m.x < pt.x - sprTank.originX + sprTank.width &&
						m.y >= pt.y - sprTank.originY && m.y < pt.y - sprTank.originY + sprTank.height)
					{
						sprTank.color = 0x888888;
						if (Input.mouseReleased)
						{
							new GetURL("http://www.newgrounds.com/");
						}
					}
					else
					{
						sprTank.color = 0xFFFFFF;
					}
					
					if (selected != tSelected)
					{
						scale = scaleMax;
					}
				}
			}
			if (open)
			{
				moveToward(offset, offsetMax);
			}
			else
			{
				moveToward(offset, offsetMin);
			}
			if (scale > scaleMin)
			{
				scale -= scaleRate;
				scale = Math.max(scale, scaleMin);
			}
			for (var i:int = 0; i < textScale.length; i++)
			{
				if (textScale[i] > textScaleMin)
				{
					textScale[i] -= textScaleRate;
				}
				else
				{
					textScale[i] = textScaleMin;
				}
			}
		}
		
		private function addItemsFromSave():void
		{
			if (!Player.hasGhostSword)
			{
				if (Player.hasSword && !hasItem(0))
				{
					addItem(0);
				}
			}
			else if (!hasItem(4))
			{
				removeItem(0);
				removeItem(3);
				addItem(4, 0);
			}
			
			if (!Player.hasFireWand)
			{
				if (Player.hasFire && !hasItem(1))
				{
					addItem(1);
				}
				if (Player.hasWand && !hasItem(2))
				{
					addItem(2);
				}
			}
			else if (!hasItem(5))
			{
				removeItem(1);
				removeItem(2);
				addItem(5, 1);
			}
			
			if (!Player.hasGhostSword)
			{
				if (Player.hasSpear && !hasItem(3))
				{
					addItem(3);
				}
			}
		}
		
		public function render():void
		{
			offsetMax.x = extended ? 0 : -23;
			
			//Background
			sprInventory.render(offset, new Point());
			
			//Item draw
			for (var i:int = 0; i < items.length; i++)
			{
				sprInventoryItems.frame = items[i];
				if (Main.hasDarkSword && items[i] == 0)
				{
					sprInventoryItems.frame = 6;
				}
				if (selected == i)
				{
					sprInventoryItems.color = 0xFFFF44;
					sprInventoryItems.scale = scale;
				}
				else
				{
					sprInventoryItems.color = 0xFFFFFF;
					sprInventoryItems.scale = 1;
				}
				sprInventoryItems.render(new Point(Math.ceil(offset.x + itemOffset.x + itemOffsetIncrement.x * i), Math.ceil(offset.y + itemOffset.y + itemOffsetIncrement.y * i)), new Point());
			}
			for (i = 0; i < Player.totemParts; i++)
			{
				if (Player.hasTotemPart(i))
				{
					sprInventoryItemsTotem.frame = i;
					sprInventoryItemsTotem.render(totemPosition.add(offset), new Point);
				}
			}
			for (i = 0; i < sprInventoryItemsSide.frameCount; i++)
			{
				sprInventoryItemsSide.frame = i;
				const keyFrame:int = 3;
				switch(i)
				{
					case 0:
						if (Player.canSwim)
						{
							sprInventoryItemsSide.render(sidePositions[0].add(offset), new Point);
						}
						break;
					case 1:
						if (Player.hasTorch)
						{
							sprInventoryItemsSide.render(sidePositions[1].add(offset), new Point);
						}
						break;
					case 2:
						if (Player.hasFeather)
						{
							sprInventoryItemsSide.render(sidePositions[2].add(offset), new Point);
						}
						break;
					default:
						if (Player.hasKey(i - keyFrame))
						{
							sprInventoryItemsSide.render(keyPositions[i - keyFrame].add(offset), new Point);
						}
				}
			}
			
			sprTank.render(ngTankPos(), new Point);
			
			//Text
			const m:int = 4;
			Text.size = 8;
			var t:Text = new Text("X");
			t.scale = textScale[0];
			t.color = 0x000000;
			t.centerOO();
			t.render(new Point(offset.x + itemOffset.x - sprInventoryItems.width/2 - t.width/2, offset.y + itemOffset.y + sprInventoryItems.height/2 - t.height/2 + itemOffsetIncrement.y * Main.primary), new Point());
			t = new Text("C");
			t.scale = textScale[1];
			t.color = 0x000000;
			t.centerOO();
			t.render(new Point(offset.x + itemOffset.x + sprInventoryItems.width + 1 - t.width/2, offset.y + itemOffset.y + sprInventoryItems.height/2 - t.height/2 + itemOffsetIncrement.y * Main.secondary), new Point());
			
			var text:Text;
			const helpTextOffset:Point = new Point(offset.x + sprInventory.width, FP.screen.height / 2); // Left aligned horizontally, but center aligned vertically
			const margin:int = 4;
			if (drawFirstUseHelp)
			{
				text = new Text(FUtexts[textIndex]);
			}
			else if (drawExtendedHelp)
			{
				text = new Text(EXtexts[textIndex]);
			}
			if (text && FP.world.classCount(Help) <= 0 && open)
			{
				Draw.rect(FP.camera.x + helpTextOffset.x, FP.camera.y + helpTextOffset.y - text.height / 2 - margin, text.width + margin * 2, text.height + margin * 2, 0x000000, 0.95);
				text.render(new Point(helpTextOffset.x + margin, helpTextOffset.y - text.height/2), new Point);
			}
			
			Text.size = 16;
		}
		
		private function ngTankPos():Point
		{
			const o:int = 4;
			return new Point(FP.screen.width + o - (sprTank.width * 3 / 4 + o) * Math.abs((offset.x - offsetMin.x) / (offsetMax.x - offsetMin.x)), FP.screen.height - sprTank.height);
		}
		
		public function moveToward(from:Point, to:Point):Point
		{
			from.x += (to.x - from.x) / movementDivisor;
			from.y += (to.y - from.y) / movementDivisor;
			if (Math.abs(from.length - to.length) <= 0.1)
			{
				from.x = to.x;
				from.y = to.y;
			}
			return from;
		}
		
		public function get firstUse():Boolean
		{
			return Main.firstUse;
		}
		public function set firstUse(_fu:Boolean):void
		{
			if (!firstUse && _fu && help)
			{
				//we're going from not first use to first use
				drawFirstUseHelp = true;
				//open = true;
			}
			Main.firstUse = _fu;
		}
		public function get extended():Boolean
		{
			return Main.extended;
		}
		public function set extended(_e:Boolean):void
		{
			if (!extended && _e && help)
			{
				//we're going from not extended to extended
				drawExtendedHelp = true;
				open = true;
			}
			Main.extended = _e;
		}
		
	}

}