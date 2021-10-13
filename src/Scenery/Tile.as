package Scenery
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	import flash.display.BlendMode;
	/**
	 * ...
	 * @author Time
	 */
	public class Tile extends Entity
	{
		public static const LAYER:int = 100;
		public static const w:int = 16;
		public static const h:int = 16;
		private static const types:Array = new Array("Tile", "Tile", "Solid", "Tile", "Tile", "Tile", "Tile", "Tile", "Tile", "Solid", 
													 "Tile", "Solid", "Tile", "Tile", "Solid", "Solid", "Tile", "Tile", "Tile", "Solid",
													 "Solid", "Tile", "Tile", "Solid", "Solid", "Tile", "Tile", "Solid", "Tile", "Unused",
													 "Tile", "Tile", "Tile", "Tile", "Solid", "Solid", "Solid", "Tile");
		
		public var img:int = 0;
		private var bladesOfGrass:int = 12;
		/*
		 * 0 = Ground
		 * 1 = Water
		 * 2 = Stone
		 * 3 = Brick
		 * 4 = Dirt
		 * 5 = Dungeon Tile
		 * 6 = Pit
		 * 7 = Shield Tile
		 * 8 = Forest
		 * 9 = Cliff
		 * 10= Cliff Stairs
		 * 11= Wood
		 * 12= Walkable Wood
		 * 13= Cave
		 * 14= Wood (natural)
		 * 15= Dark Stone
		 * 16= Igneous Stone
		 * 17= Lava
		 * 18= Blue Tile
		 * 19= Blue Wall
		 * 20= Blue Wall (dark)
		 * 21= Snow
		 * 22= Ice
		 * 23= Ice Wall
		 * 24= Ice Wall (glowing)
		 * 25= Waterfall
		 * 26= Body Floor
		 * 27= Body Wall
		 * 28= Ghost Tile
		 * 29= Bridge
		 * 30= Ghost Tile Step
		 * 31= Igneous-to-Lava
		 * 32= Odd Tile
		 * 33= Fuchsia Tile
		 * 34= Odd Tile (wall)
		 * 35= Rock Wall (dark)
		 * 36= Rock Wall
		 * 37= Rock Wall (floor)
		 */
		public var t:int = 0; //type of tile
		private var grass:Boolean; //Only used if ground
		private const waterfallFrames:int = 4;
		
		private const closedBridge:Array = new Array(0, 1);
		private const openingBridge:Array = new Array(1, 2, 3, 4, 5, 6);
		private const openBridge:Array = new Array(7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18);
		private const bridgeOpeningTimerMax:int = 60;
		public var bridgeOpeningTimer:int = bridgeOpeningTimerMax;
		
		private static const igneousAlpha:Number = 0.25;
		private var igneousFrame:int = 0;
		private const igneousCounterMax:int = 8;
		private var igneousCounter:int = igneousCounterMax;
		public var igneousBreakApart:Boolean = false;
		
		private var _em:Emitter;
		private var _emObj:Entity;
		private static const _emOriginX:int = 4;
		private static const _emOriginY:int = 2; //The origin position of the image stored for the emitter
		private static const bodyFrames:Array = new Array(0, 1, 2, 3, 2, 1);
		private var continuous:Boolean;	//Whether a waterfall falls another level
		private var pit:Boolean;	//Whether the waterfall should end in a pit.
		private var spray:Boolean;	//Whether or not the particles will form at the bottom
		private var myEdges:BitmapData;
		
		private var randVal:Number = Math.random(); //Used to get the starting frame for water and lava, and used general-purpose throughout
		private var randVal1:Number = Math.random();
		private var randVal2:Number = Math.random();
		
		public function Tile(_x:int, _y:int, _t:int=0, _grass:Boolean=true, _g:Graphic=null, _pit:Boolean=false, _continuous:Boolean=false, _spray:Boolean=true) 
		{
			super(_x + w/2, _y + h/2);
			layer = LAYER;
			
			grass = _grass;			
			t = _t;
			
			setHitbox(w, h, w / 2, h / 2);
			type = "Tile";
			
			pit = _pit;
			continuous = _continuous;
			spray = _spray;
		}
		
		override public function update():void
		{
			//Set to the correct type after all of the objects have run their first-frame "check", and then deactivate update loop.
			type = types[t];
			active = false;
		}
		
		override public function render():void
		{
			if (!onScreen(int(t == 32) * 16))
			{
				return;
			}
			const phases:int = 100;
			var loops:int;
			var maxAlpha:Number;
			switch(t)
			{
				case 0: Game.sprGround.frame = img;
						Game.sprGround.render(new Point(x, y), FP.camera);
						break;
				case 1: Game.sprWater.frame = Game.worldFrame(Game.sprWater.frameCount) + Math.floor(randVal * Game.sprWater.frameCount);
						Game.sprWater.render(new Point(x, y), FP.camera);
						drawMyEdges();
						break;
				case 2: Game.sprStone.frame = img;
						Game.sprStone.render(new Point(x, y), FP.camera);
						break;
				case 3: Game.sprBrick.render(new Point(x, y), FP.camera);
						break;
				case 4: Game.sprDirt.frame = img;
						Game.sprDirt.render(new Point(x, y), FP.camera);
						break;
				case 5: 
						Game.sprDungeonTile.angle = 90 * Math.floor(randVal * 4);
						Game.sprDungeonTile.render(new Point(x, y), FP.camera);
						break;
				case 6: Game.sprPit.render(new Point(x, y), FP.camera);
						break;
				case 7: Game.sprShieldTile.frame = img;
						Game.sprShieldTile.render(new Point(x, y), FP.camera);
						break;
				case 8: Game.sprForest.frame = img;
						Game.sprForest.render(new Point(x, y), FP.camera);
						break;
				case 9:
						Game.sprCliff.render(new Point(x, y), FP.camera);
						break;
				case 10:
						Game.sprCliffStairs.render(new Point(x, y), FP.camera);
						break;
				case 11:
						Game.sprWood.frame = img;
						Game.sprWood.render(new Point(x, y), FP.camera);
						break;
				case 12:
						Game.sprWoodWalk.frame = img;
						Game.sprWoodWalk.render(new Point(x, y), FP.camera);
						break;
				case 13:
						Game.sprCave.render(new Point(x, y), FP.camera);
						break;
				case 14:
						Game.sprWoodTree.frame = img;
						Game.sprWoodTree.render(new Point(x, y), FP.camera);
						break;
				case 15:
						Game.sprDarkTile.frame = img;
						Game.sprDarkTile.render(new Point(x, y), FP.camera);
						
						Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
						loops = 5;
						Game.sprDarkTile.alpha = (Math.sin(Game.worldFrame(phases, loops) / phases * 2 * Math.PI) + 1) / 2;
						Game.sprDarkTile.render(new Point(x, y), FP.camera);
						Game.sprDarkTile.alpha = 1;
						Draw.resetTarget();
						break;
				case 16:
						Game.sprIgneousTile.frame = img;
						Game.sprIgneousTile.render(new Point(x, y), FP.camera);
						
						Game.sprIgneousTile.alpha = igneousAlpha;
						Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
						Game.sprIgneousTile.render(new Point(x, y), FP.camera);
						Draw.resetTarget();
						Game.sprIgneousTile.alpha = 1;
						break;
				case 17:
						Game.sprLava.frame = Game.worldFrame(Game.sprLava.frameCount) + Math.floor(randVal * Game.sprLava.frameCount);
						Game.sprLava.render(new Point(x, y), FP.camera);
						
						//Set the scale, color, and alpha of the lava for drawing to the surface.
						const scale:Number = 1.5;
						if (!myEdges)
						{
							myEdges = new BitmapData(scale * Game.sprLava.width, scale * Game.sprLava.height, true, 0);
							
							Draw.setTarget(myEdges, new Point);
							Game.sprLava.scale = scale;
							Game.sprLava.color = 0xFFFF00;
							Game.sprLava.alpha = 0.4;
							Game.sprLava.render(new Point(myEdges.width/2, myEdges.height/2), new Point);
							Game.sprLava.alpha = 1;
							Game.sprLava.scale = (scale - 1) / 2 + 1;
							Game.sprLava.render(new Point(myEdges.width/2, myEdges.height/2), new Point);
							Draw.resetTarget();
						}
						else
						{
							var m:Matrix = new Matrix();
							var n:int = 10;
							loops = 2;
							const addScale:Number = 0.1; //The most variance above and below 1 that it can be scaled
							var sc:Number = Math.sin(Game.worldFrame(n, loops) / n*2*Math.PI) * addScale + 1;
							m.scale(sc, sc);
							m.translate(x - myEdges.width * sc / 2 - FP.camera.x, y - myEdges.height * sc / 2 - FP.camera.y);
							(FP.world as Game).solidBmp.draw(myEdges, m);
						}
						
						//Reset Lava values
						Game.sprLava.scale = 1;
						Game.sprLava.alpha = 1;
						Game.sprLava.color = 0xFFFFFF;
						
						//Draw the lava straight onto the night surface as well.
						Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
						Game.sprLava.render(new Point(x, y), FP.camera);
						Draw.resetTarget();
						break;
				case 18:
						Game.sprBlueTile.frame = img;
						if (img == 15)
						{
							Game.sprBlueTile.frame += Math.floor((Game.sprBlueTile.frameCount - img - 1) * randVal);
						}
						Game.sprBlueTile.render(new Point(x, y), FP.camera);
						break;
				case 19:
						Game.sprBlueTileWall.frame = img;
						Game.sprBlueTileWall.render(new Point(x, y), FP.camera);
						break;
				case 20:
						Game.sprBlueTileWallDark.frame = img;
						Game.sprBlueTileWallDark.render(new Point(x, y), FP.camera);
						break;
				case 21:
						Game.sprSnow.frame = img;
						Game.sprSnow.render(new Point(x, y), FP.camera);
						break;
				case 22:
						Game.sprIce.frame = Math.floor(randVal * Game.sprIce.frameCount);
						Game.sprIce.render(new Point(x, y), FP.camera);
						break;
				case 23:
						Game.sprIceWall.frame = Game.worldFrame(Game.sprIceWall.frameCount, 2);
						Game.sprIceWall.render(new Point(x, y), FP.camera);
						if (!Game.snowing)
						{
							Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
							var lightFrames:int = 60;
							var lightLoops:int = 5;
							Game.sprIceWall.alpha = (Math.sin(Game.worldFrame(lightFrames, lightLoops) / lightFrames * 2 * Math.PI)+1)/2 * 0.3 + 0.1;
							Game.sprIceWall.render(new Point(x, y), FP.camera);
							Game.sprIceWall.alpha = 1;
							Draw.resetTarget();
						}
						drawMyEdges();
						break;
				case 24:
						Game.sprIceWallLit.frame = Game.worldFrame(Game.sprIceWallLit.frameCount, 2);
						Game.sprIceWallLit.render(new Point(x, y), FP.camera);
						if (!Game.snowing)
						{
							Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
							lightFrames = 60;
							lightLoops = 5;
							Game.sprIceWallLit.alpha = (Math.sin(Game.worldFrame(lightFrames, lightLoops) / lightFrames * 2 * Math.PI) + 1) / 2 * 0.3 + 0.1;
							Game.sprIceWallLit.render(new Point(x, y), FP.camera);
							Game.sprIceWallLit.alpha = 1;
							Draw.resetTarget();
						}
						drawMyEdges();
						break;
				case 25:
						Game.sprWaterfall.frame = (Game.worldFrame(waterfallFrames, 0.8) + Math.floor(randVal * waterfallFrames)) % waterfallFrames + waterfallFrames * int(continuous);
						Game.sprWaterfall.render(new Point(x, y), FP.camera);
						if (pit)
						{
							Game.sprPitShadow.render(new Point(x, y), FP.camera);
						}
						if (spray && _em)
						{
							_em.emit("spray", x - originX - _emOriginX + width * Math.random(), y - originY + height - _emOriginY + Math.random());
							_em.update();
						}
						break;
				case 26:
						Game.sprBody.flipped = randVal < 0.5;
						Game.sprBody.angle = 180 * (int(2 * randVal) - 1);
						loops = 1;
						Game.sprBody.frame = bodyFrames[(Game.worldFrame(bodyFrames.length, loops) + int(randVal * bodyFrames.length)) % bodyFrames.length];
						Game.sprBody.render(new Point(x, y), FP.camera);
						Game.sprBody.flipped = false;
						drawMyEdges();
						break;
				case 27:
						Game.sprBodyWall.flipped = randVal < 0.5;
						Game.sprBodyWall.angle = 180 * (int(2 * randVal) - 1);
						loops = 2;
						Game.sprBodyWall.frame = bodyFrames[(Game.worldFrame(bodyFrames.length, loops) + int(randVal * bodyFrames.length)) % bodyFrames.length];
						Game.sprBodyWall.render(new Point(x, y), FP.camera);
						Game.sprBodyWall.flipped = false;
						drawMyEdges();
						break;
				case 28:
						Game.sprGhostTile.frame = img;
						Game.sprGhostTile.render(new Point(x, y), FP.camera);
						
						Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
						loops = 3;
						maxAlpha = 0.05;
						Game.sprGhostTile.alpha = (Math.sin(Game.worldFrame(phases, loops) / (phases-1) * 2 * Math.PI) + 1) / 2 * maxAlpha;
						Game.sprGhostTile.render(new Point(x, y), FP.camera);
						Game.sprGhostTile.alpha = 1;
						Draw.resetTarget();
						break;
				case 29:
						if (bridgeOpeningTimer >= bridgeOpeningTimerMax)
						{
							loops = 2;
							Game.sprBridge.frame = closedBridge[Game.worldFrame(closedBridge.length, loops)];
							type = "Solid";
						}
						else if (bridgeOpeningTimer > 0)
						{
							bridgeOpeningTimer--;
							Game.sprBridge.frame = openingBridge[int((1 - bridgeOpeningTimer / bridgeOpeningTimerMax) * openingBridge.length)];
							Game.sprBridge.blend = BlendMode.INVERT;
							type = "Solid";
						}
						else if (bridgeOpeningTimer <= 0)
						{
							loops = 2;
							Game.sprBridge.frame = openBridge[Game.worldFrame(openBridge.length, loops)];
							type = "Tile";
						}
						Game.sprBridge.render(new Point(x, y), FP.camera);
						Game.sprBridge.blend = BlendMode.NORMAL;
						
						Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
						loops = 3;
						maxAlpha = 0.1;
						Game.sprBridge.alpha = (Math.sin(Game.worldFrame(phases, loops) / (phases-1) * 2 * Math.PI) + 1) / 2 * maxAlpha;
						if (bridgeOpeningTimer < bridgeOpeningTimerMax && bridgeOpeningTimer > 0)
						{
							Game.sprBridge.alpha = 1;
						}
						
						Game.sprBridge.render(new Point(x, y), FP.camera);
						Game.sprBridge.alpha = 1;
						Draw.resetTarget();
						break;
				case 30:
						Game.sprGhostTileStep.render(new Point(x, y), FP.camera);
						
						Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
						loops = 3;
						maxAlpha = 0.05;
						Game.sprGhostTileStep.alpha = (Math.sin(Game.worldFrame(phases, loops) / (phases-1) * 2 * Math.PI) + 1) / 2 * maxAlpha;
						Game.sprGhostTileStep.render(new Point(x, y), FP.camera);
						Game.sprGhostTileStep.alpha = 1;
						Draw.resetTarget();
						break;
				case 31:
						if (!igneousBreakApart)
						{
							var p:Player = FP.world.nearestToPoint("Player", x, y) as Player;
							if (p)
							{
								if (FP.distance(p.x, p.y, x, y) <= Math.sqrt(width * width + height * height)/2)
								{
									if (igneousCounter > 0)
									{
										igneousCounter--;
									}
									else
									{
										igneousCounter = igneousCounterMax;
										igneousBreakApart = true;
									}
								}
							}
						}
						else
						{
							if (igneousCounter > 0)
							{
								igneousCounter--;
							}
							else
							{
								igneousCounter = igneousCounterMax;
								igneousFrame++;
								if (igneousFrame >= Game.sprIgneousLava.frameCount)
								{
									t = 17; //Lava
								}
							}
						}
						Game.sprIgneousLava.frame = igneousFrame;
						Game.sprIgneousLava.render(new Point(x, y), FP.camera);
						
						Game.sprIgneousLava.alpha = igneousAlpha;
						Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
						Game.sprIgneousLava.render(new Point(x, y), FP.camera);
						Draw.resetTarget();
						Game.sprIgneousLava.alpha = 1;
						break;
				case 32:
						maxAlpha = 1;
						loops = 3;
						const minRadius:int = 12;
						const maxRadius:int = 16;
						const minAlpha:Number = 0.5;
						const smoothed:Number = (Math.sin(Game.worldFrame(phases, loops) / phases * 2 * Math.PI + randVal * 2 * Math.PI) + 1) / 2;
						
						Draw.setTarget((FP.world as Game).underBmp, FP.camera);
						Draw.circlePlus(x, y, smoothed*(maxRadius-minRadius)+minRadius, 0xFFFFFF, smoothed);
						Draw.resetTarget();
						
						Game.sprOddTile.frame = img;
						Game.sprOddTile.render(new Point(x, y), FP.camera);
						break;
				case 33:
						Game.sprFuchTile.frame = img;
						Game.sprFuchTile.render(new Point(x, y), FP.camera);
						
						Draw.setTarget((FP.world as Game).nightBmp, FP.camera);
						loops = 4;
						Game.sprFuchTile.alpha = (Math.sin(Game.worldFrame(phases, loops) / phases * 2 * Math.PI + randVal * 2 * Math.PI) + 1) / 2 * 0.75 + 0.25;
						Game.sprFuchTile.render(new Point(x, y), FP.camera);
						Game.sprFuchTile.alpha = 1;
						Draw.resetTarget();
						
						drawMyEdges();
						break;
				case 34:
						Game.sprOddTileWall.frame = img;
						Game.sprOddTileWall.render(new Point(x, y), FP.camera);
						break;
				case 35:
						Game.sprRockTile.frame = Math.round(randVal);
						Game.sprRockTile.angle = 180 * Math.floor(2 * randVal);
						Game.sprRockTile.render(new Point(x, y), FP.camera);
						break;
				case 36:
						Game.sprRockTile.frame = Math.round(randVal) + 2;
						Game.sprRockTile.angle = 180 * Math.floor(2 * randVal);
						Game.sprRockTile.render(new Point(x, y), FP.camera);
						drawMyEdges();
						break;
				case 37:
						Game.sprRockyTile.frame = Math.round(randVal) * 4;
						Game.sprRockyTile.scaleX = Math.round(randVal1) * 2 - 1;
						Game.sprRockyTile.scaleY = Math.round(randVal2) * 2 - 1;
						Game.sprRockyTile.render(new Point(x, y), FP.camera);
						break;
				default:
			}
			
		}
		
		override public function check():void
		{
			img = 0;
			var c:Tile = collide("Tile", x + 1, y) as Tile;
			if (c && (c.t == t || c.t == 9))
			{
				img++;
			}
			c = collide("Tile", x, y - 1) as Tile;
			if (c && (c.t == t || c.t == 9))
			{
				img += 2;
			}
			c = collide("Tile", x - 1, y) as Tile;
			if (c && (c.t == t || c.t == 9))
			{
				img += 4;
			}
			c = collide("Tile", x, y + 1) as Tile;
			if (c && c.t == t) //Ignores the 9 because of the cliff shouldn't clip below.
			{
				img += 8;
			}
			switch(t)
			{
				case 0:
					if (grass)
					{
						addGrass();
					}
					break;
				case 8:
					if (grass)
					{
						addGrass();
					}
					break;
				case 13: //creates a block for the top of the cave so you can't enter from above.
					var e:Entity;
					e = new Entity(x - originX, y - originY);
					FP.world.add(e);
					e.setHitbox(width, 1);
					e.type = "Solid";
					break;
				case 23:
					drawEdges(15 - img, 0x0088FF, 0.25);
					break;
				case 24:
					FP.world.add(new Light(x, y, 60, 1, 0x0088FF, true));
					drawEdges(15 - img, 0x0088FF, 0.5);
					break;
				case 25:
					if(spray)
					{
						_em = new Emitter(Game.imgWaterfallSpray, 8, 5);
						_em.newType("spray", [0, 1, 2, 3]);
						_em.setAlpha("spray", 1, 0);
						_em.setMotion("spray", 90, 6, 0.8, 10, 4, 0.3);
						_emObj = FP.world.addGraphic(_em, -(y - originY + height + 3));
					}
					break;
				case 26:
				case 27:
				case 33:
				case 36:
					drawEdges(15 - img, 0x000000, 0.4);
					break;
				default:
			}
		}
		
		public function addGrass():void
		{
			for (var i:int = 0; i < bladesOfGrass; i++)
			{
				FP.world.add(new Grass(x + Tile.w * (Math.random() - 0.5), y + Tile.h * (Math.random() - 0.5)));
			}
		}
		
		public function drawEdges(_f:int, _c:uint=0, _a:Number=1, _thick:int=1):void
		{
			_c += 0xFF000000;
			myEdges = new BitmapData(width, height, true, 0x00000000);
			Draw.setTarget(myEdges, new Point);
			if (_f & 1)
			{
				Draw.linePlus(width-1, 0, width-1, height, _c, _a, _thick);
			}
			if ((_f & 2) / 2)
			{
				Draw.linePlus(0, 0, width, 0, _c, _a, _thick);
			}
			if ((_f & 4) / 4)
			{
				Draw.linePlus(0, 0, 0, height, _c, _a, _thick);
			}
			if ((_f & 8) / 8)
			{
				Draw.linePlus(0, height-1, width, height-1, _c, _a, _thick);
			}
			Draw.resetTarget();
		}
		
		public function drawMyEdges():void
		{
			if (myEdges)
			{
				var m:Matrix = new Matrix(1, 0, 0, 1, x - originX - FP.camera.x, y - originY - FP.camera.y);
				FP.buffer.draw(myEdges, m);
			}
		}
		
	}

}