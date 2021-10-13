package 
{
	import Enemies.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.World;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import flash.geom.Point;
	import net.flashpunk.utils.Draw;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import NPCs.AdnanCharacter;
	import NPCs.ForestCharacter;
	import NPCs.Help;
	import NPCs.Hermit;
	import NPCs.IntroCharacter;
	import NPCs.Karlore;
	import NPCs.Oracle;
	import NPCs.Rekcahdam;
	import NPCs.Sensei;
	import NPCs.Sign;
	import NPCs.Statue;
	import NPCs.Totem;
	import NPCs.Watcher;
	import NPCs.Witch;
	import NPCs.Yeti;
	import Scenery.*;
	import Puzzlements.*;
	import Pickups.*;
	import flash.display.BlendMode;
	import net.flashpunk.utils.Ease;
	/**
	 * ...
	 * @author Time
	 */
	public class Game extends World
	{
	/*0  */	[Embed(source = '../assets/levels/OverWorld.oel', mimeType = "application/octet-stream")] public static var OverWorld1:Class;
	/*1  */	[Embed(source = '../assets/levels/Building1.oel', mimeType = "application/octet-stream")] public static var Building1:Class;
		
	/*2  */	[Embed(source = '../assets/levels/Dungeon1/Entrance.oel', mimeType = "application/octet-stream")] public static var Dungeon1_Entrance:Class;
	/*3  */	[Embed(source = '../assets/levels/Dungeon1/1.oel', mimeType = "application/octet-stream")] public static var Dungeon1_1:Class;
	/*4  */	[Embed(source = '../assets/levels/Dungeon1/2.oel', mimeType = "application/octet-stream")] public static var Dungeon1_2:Class;
	/*5  */	[Embed(source = '../assets/levels/Dungeon1/3.oel', mimeType = "application/octet-stream")] public static var Dungeon1_3:Class;
	/*6  */	[Embed(source = '../assets/levels/Dungeon1/4.oel', mimeType = "application/octet-stream")] public static var Dungeon1_4:Class;
	/*7  */	[Embed(source = '../assets/levels/Dungeon1/5.oel', mimeType = "application/octet-stream")] public static var Dungeon1_5:Class;
	/*8  */	[Embed(source = '../assets/levels/Dungeon1/6.oel', mimeType = "application/octet-stream")] public static var Dungeon1_6:Class;
	/*9  */	[Embed(source = '../assets/levels/Dungeon1/7.oel', mimeType = "application/octet-stream")] public static var Dungeon1_7:Class;
	/*10 */	[Embed(source = '../assets/levels/Dungeon1/8.oel', mimeType = "application/octet-stream")] public static var Dungeon1_8:Class;
	/*11 */	[Embed(source = '../assets/levels/Dungeon1/9.oel', mimeType = "application/octet-stream")] public static var Dungeon1_9:Class;
	
	/*12 */ [Embed(source = '../assets/levels/OverWorld/region1.oel', mimeType = "application/octet-stream")] public static var OverWorld1_1:Class;
	
	/*13 */	[Embed(source = '../assets/levels/Dungeon2/Entrance.oel', mimeType = "application/octet-stream")] public static var Dungeon2_Entrance:Class;
	/*14 */	[Embed(source = '../assets/levels/Dungeon2/1.oel', mimeType = "application/octet-stream")] public static var Dungeon2_1:Class;
	/*15 */	[Embed(source = '../assets/levels/Dungeon2/2.oel', mimeType = "application/octet-stream")] public static var Dungeon2_2:Class;
	/*16 */	[Embed(source = '../assets/levels/Dungeon2/3.oel', mimeType = "application/octet-stream")] public static var Dungeon2_3:Class;
	/*17 */	[Embed(source = '../assets/levels/Dungeon2/4.oel', mimeType = "application/octet-stream")] public static var Dungeon2_4:Class;
	/*18 */	[Embed(source = '../assets/levels/Dungeon2/5.oel', mimeType = "application/octet-stream")] public static var Dungeon2_5:Class;
	/*19 */	[Embed(source = '../assets/levels/Dungeon2/6.oel', mimeType = "application/octet-stream")] public static var Dungeon2_Boss:Class;
	/*20 */	[Embed(source = '../assets/levels/Dungeon2/7.oel', mimeType = "application/octet-stream")] public static var Dungeon2_7:Class;
		
	/*21 */	[Embed(source = '../assets/levels/Dungeon3/Entrance.oel', mimeType = "application/octet-stream")] public static var Dungeon3_Entrance:Class;
	/*22 */	[Embed(source = '../assets/levels/Dungeon3/1.oel', mimeType = "application/octet-stream")] public static var Dungeon3_1:Class;
	/*23 */	[Embed(source = '../assets/levels/Dungeon3/2.oel', mimeType = "application/octet-stream")] public static var Dungeon3_2:Class;
	/*24 */	[Embed(source = '../assets/levels/Dungeon3/3.oel', mimeType = "application/octet-stream")] public static var Dungeon3_3:Class;
	/*25 */	[Embed(source = '../assets/levels/Dungeon3/4.oel', mimeType = "application/octet-stream")] public static var Dungeon3_4:Class;
	/*26 */	[Embed(source = '../assets/levels/Dungeon3/5.oel', mimeType = "application/octet-stream")] public static var Dungeon3_5:Class;
	/*27 */	[Embed(source = '../assets/levels/Dungeon3/6.oel', mimeType = "application/octet-stream")] public static var Dungeon3_6:Class;
	/*28 */	[Embed(source = '../assets/levels/Dungeon3/7.oel', mimeType = "application/octet-stream")] public static var Dungeon3_7:Class;
	/*29 */	[Embed(source = '../assets/levels/Dungeon3/8.oel', mimeType = "application/octet-stream")] public static var Dungeon3_8:Class;
	/*30 */	[Embed(source = '../assets/levels/Dungeon3/9.oel', mimeType = "application/octet-stream")] public static var Dungeon3_9:Class;
	/*31 */	[Embed(source = '../assets/levels/Dungeon3/10.oel', mimeType = "application/octet-stream")] public static var Dungeon3_10:Class;
	/*32 */	[Embed(source = '../assets/levels/Dungeon3/11.oel',mimeType = "application/octet-stream")] public static var Dungeon3_Boss:Class;
	
	/*33 */ [Embed(source = '../assets/levels/OverWorld/witchhut.oel', mimeType = "application/octet-stream")] public static var OverWorld1_witchhut:Class;
	/*34 */ [Embed(source = '../assets/levels/OverWorld/barhouse.oel', mimeType = "application/octet-stream")] public static var OverWorld1_barhouse:Class;
	/*35 */ [Embed(source = '../assets/levels/OverWorld/blandashurmin.oel', mimeType = "application/octet-stream")] public static var OverWorld1_blandashurmin:Class;
	/*36 */ [Embed(source = '../assets/levels/OverWorld/intree.oel', mimeType = "application/octet-stream")] public static var OverWorld1_intree:Class;
	/*37 */ [Embed(source = '../assets/levels/OverWorld/region2.oel', mimeType = "application/octet-stream")] public static var OverWorld1_2:Class;
	
	/*38 */	[Embed(source = '../assets/levels/Dungeon4/Entrance.oel', mimeType = "application/octet-stream")] public static var Dungeon4_Entrance:Class;
	/*39 */	[Embed(source = '../assets/levels/Dungeon4/1.oel', mimeType = "application/octet-stream")] public static var Dungeon4_1:Class;
	/*40 */	[Embed(source = '../assets/levels/Dungeon4/2.oel', mimeType = "application/octet-stream")] public static var Dungeon4_2:Class;
	/*41 */	[Embed(source = '../assets/levels/Dungeon4/3.oel', mimeType = "application/octet-stream")] public static var Dungeon4_3:Class;
	/*42 */	[Embed(source = '../assets/levels/Dungeon4/4.oel', mimeType = "application/octet-stream")] public static var Dungeon4_4:Class;
	/*43 */	[Embed(source = '../assets/levels/Dungeon4/Boss.oel', mimeType = "application/octet-stream")] public static var Dungeon4_Boss:Class;
	
	/*44 */ [Embed(source = '../assets/levels/OverWorld/region3.oel', mimeType = "application/octet-stream")] public static var OverWorld1_3:Class;
	
	/*45 */	[Embed(source = '../assets/levels/Dungeon5/Entrance.oel', mimeType = "application/octet-stream")] public static var Dungeon5_Entrance:Class;
	/*46 */	[Embed(source = '../assets/levels/Dungeon5/1.oel', mimeType = "application/octet-stream")] public static var Dungeon5_1:Class;
	/*47 */	[Embed(source = '../assets/levels/Dungeon5/2.oel', mimeType = "application/octet-stream")] public static var Dungeon5_2:Class;
	/*48 */	[Embed(source = '../assets/levels/Dungeon5/3.oel', mimeType = "application/octet-stream")] public static var Dungeon5_3:Class;
	/*49 */	[Embed(source = '../assets/levels/Dungeon5/4.oel', mimeType = "application/octet-stream")] public static var Dungeon5_4:Class;
	/*50 */	[Embed(source = '../assets/levels/Dungeon5/5.oel', mimeType = "application/octet-stream")] public static var Dungeon5_5:Class;
	/*51 */	[Embed(source = '../assets/levels/Dungeon5/6.oel', mimeType = "application/octet-stream")] public static var Dungeon5_6:Class;
	/*52 */	[Embed(source = '../assets/levels/Dungeon5/7.oel', mimeType = "application/octet-stream")] public static var Dungeon5_7:Class;
	/*53 */	[Embed(source = '../assets/levels/Dungeon5/8.oel', mimeType = "application/octet-stream")] public static var Dungeon5_8:Class;
	/*54 */	[Embed(source = '../assets/levels/Dungeon5/9.oel', mimeType = "application/octet-stream")] public static var Dungeon5_9:Class;
	/*55 */	[Embed(source = '../assets/levels/Dungeon5/10.oel', mimeType = "application/octet-stream")] public static var Dungeon5_10:Class;
	/*56 */	[Embed(source = '../assets/levels/Dungeon5/11.oel', mimeType = "application/octet-stream")] public static var Dungeon5_11:Class;
	/*57 */ [Embed(source = '../assets/levels/Dungeon5/Boss.oel', mimeType = "application/octet-stream")] public static var Dungeon5_Boss:Class;
	/*58 */	[Embed(source = '../assets/levels/Dungeon5/DeadBoss.oel', mimeType = "application/octet-stream")] public static var Dungeon5_DeadBoss:Class;
	
	/*59 */	[Embed(source = '../assets/levels/Dungeon6/Entrance.oel', mimeType = "application/octet-stream")] public static var Dungeon6_Entrance:Class;
	/*60 */	[Embed(source = '../assets/levels/Dungeon6/1.oel', mimeType = "application/octet-stream")] public static var Dungeon6_1:Class;
	/*61 */	[Embed(source = '../assets/levels/Dungeon6/2.oel', mimeType = "application/octet-stream")] public static var Dungeon6_2:Class;
	/*62 */	[Embed(source = '../assets/levels/Dungeon6/3.oel', mimeType = "application/octet-stream")] public static var Dungeon6_3:Class;
	/*63 */	[Embed(source = '../assets/levels/Dungeon6/4.oel', mimeType = "application/octet-stream")] public static var Dungeon6_4:Class;
	/*64 */	[Embed(source = '../assets/levels/Dungeon6/5.oel', mimeType = "application/octet-stream")] public static var Dungeon6_5:Class;
	/*65 */	[Embed(source = '../assets/levels/Dungeon6/6.oel', mimeType = "application/octet-stream")] public static var Dungeon6_6:Class;
	/*66 */	[Embed(source = '../assets/levels/Dungeon6/7.oel', mimeType = "application/octet-stream")] public static var Dungeon6_7:Class;
	/*67 */	[Embed(source = '../assets/levels/Dungeon6/8.oel', mimeType = "application/octet-stream")] public static var Dungeon6_8:Class;
	/*68 */	[Embed(source = '../assets/levels/Dungeon6/9.oel', mimeType = "application/octet-stream")] public static var Dungeon6_9:Class;
	/*69 */	[Embed(source = '../assets/levels/Dungeon6/Boss.oel', mimeType = "application/octet-stream")] public static var Dungeon6_Boss:Class;
	/*70 */	[Embed(source = '../assets/levels/Dungeon6/10.oel', mimeType = "application/octet-stream")] public static var Dungeon6_10:Class;
	
	/*71 */	[Embed(source = '../assets/levels/Dungeon7/Entrance.oel', mimeType = "application/octet-stream")] public static var Dungeon7_Entrance:Class;
	/*72 */	[Embed(source = '../assets/levels/Dungeon7/1.oel', mimeType = "application/octet-stream")] public static var Dungeon7_1:Class;
	/*73 */	[Embed(source = '../assets/levels/Dungeon7/2.oel', mimeType = "application/octet-stream")] public static var Dungeon7_2:Class;
	/*74 */	[Embed(source = '../assets/levels/Dungeon7/3.oel', mimeType = "application/octet-stream")] public static var Dungeon7_3:Class;
	/*75 */	[Embed(source = '../assets/levels/Dungeon7/4.oel', mimeType = "application/octet-stream")] public static var Dungeon7_4:Class;
	/*76 */	[Embed(source = '../assets/levels/Dungeon7/5.oel', mimeType = "application/octet-stream")] public static var Dungeon7_5:Class;
	/*77 */	[Embed(source = '../assets/levels/Dungeon7/6.oel', mimeType = "application/octet-stream")] public static var Dungeon7_6:Class;
	/*78 */	[Embed(source = '../assets/levels/Dungeon7/7.oel', mimeType = "application/octet-stream")] public static var Dungeon7_7:Class;
	/*79 */	[Embed(source = '../assets/levels/Dungeon7/8.oel', mimeType = "application/octet-stream")] public static var Dungeon7_8:Class;
	/*80 */	[Embed(source = '../assets/levels/Dungeon7/9.oel', mimeType = "application/octet-stream")] public static var Dungeon7_9:Class;
	/*81 */	[Embed(source = '../assets/levels/Dungeon7/10.oel', mimeType = "application/octet-stream")] public static var Dungeon7_10:Class;
	/*82 */	[Embed(source = '../assets/levels/Dungeon7/Boss.oel', mimeType = "application/octet-stream")] public static var Dungeon7_Boss:Class;

	/*83 */	[Embed(source = '../assets/levels/OverWorld/fallhole.oel', mimeType = "application/octet-stream")] public static var OverWorld_fallhole:Class;
	/*84 */	[Embed(source = '../assets/levels/OverWorld/fallhole1.oel', mimeType = "application/octet-stream")] public static var OverWorld_fallhole1:Class;
	/*85 */	[Embed(source = '../assets/levels/OverWorld/d7entrance.oel', mimeType = "application/octet-stream")] public static var OverWorld_d7entrance:Class;
	/*86 */	[Embed(source = '../assets/levels/OverWorld/house.oel', mimeType = "application/octet-stream")] public static var OverWorld_house:Class;
	/*87 */	[Embed(source = '../assets/levels/OverWorld/region4.oel', mimeType = "application/octet-stream")] public static var OverWorld1_4:Class;
	/*88 */	[Embed(source = '../assets/levels/OverWorld/region5.oel', mimeType = "application/octet-stream")] public static var OverWorld1_5:Class;
	/*89 */	[Embed(source = '../assets/levels/OverWorld/region6.oel', mimeType = "application/octet-stream")] public static var OverWorld1_6:Class;
	/*90 */	[Embed(source = '../assets/levels/OverWorld/waterfallcave.oel', mimeType = "application/octet-stream")] public static var OverWorld_waterfallcave:Class;
	/*91 */	[Embed(source = '../assets/levels/OverWorld/mountain.oel', mimeType = "application/octet-stream")] public static var OverWorld_mountain:Class;
	/*92 */	[Embed(source = '../assets/levels/OverWorld/mountain1.oel', mimeType = "application/octet-stream")] public static var OverWorld_mountain1:Class;
	/*93 */	[Embed(source = '../assets/levels/OverWorld/finalboss.oel', mimeType = "application/octet-stream")] public static var OverWorld_finalboss:Class;
	/*94 */	[Embed(source = '../assets/levels/OverWorld/treelarge.oel', mimeType = "application/octet-stream")] public static var OverWorld_treelarge:Class;
	/*95 */	[Embed(source = '../assets/levels/OverWorld/d6entrance.oel', mimeType = "application/octet-stream")] public static var OverWorld_d6entrance:Class;
	/*96 */	[Embed(source = '../assets/levels/Dungeon7/11.oel', mimeType = "application/octet-stream")] public static var Dungeon7_11:Class;
	/*97 */	[Embed(source = '../assets/levels/Dungeon7/12.oel', mimeType = "application/octet-stream")] public static var Dungeon7_12:Class;
	
	/*98 */	[Embed(source = '../assets/levels/Dungeon8/Entrance.oel', mimeType = "application/octet-stream")] public static var Dungeon8_Entrance:Class;
	/*99 */	[Embed(source = '../assets/levels/Dungeon8/1.oel', mimeType = "application/octet-stream")] public static var Dungeon8_1:Class;
	/*100*/	[Embed(source = '../assets/levels/Dungeon8/2.oel', mimeType = "application/octet-stream")] public static var Dungeon8_2:Class;
	/*101*/	[Embed(source = '../assets/levels/Dungeon8/3.oel', mimeType = "application/octet-stream")] public static var Dungeon8_3:Class;
	/*102*/	[Embed(source = '../assets/levels/Dungeon8/4.oel', mimeType = "application/octet-stream")] public static var Dungeon8_4:Class;
	/*103*/	[Embed(source = '../assets/levels/Dungeon8/5.oel', mimeType = "application/octet-stream")] public static var Dungeon8_5:Class;
	/*104*/	[Embed(source = '../assets/levels/Dungeon8/6.oel', mimeType = "application/octet-stream")] public static var Dungeon8_6:Class;
	/*105*/	[Embed(source = '../assets/levels/Dungeon8/7.oel', mimeType = "application/octet-stream")] public static var Dungeon8_7:Class;
	/*106*/	[Embed(source = '../assets/levels/Dungeon8/8.oel', mimeType = "application/octet-stream")] public static var Dungeon8_8:Class;
	/*107*/	[Embed(source = '../assets/levels/Dungeon8/9.oel', mimeType = "application/octet-stream")] public static var Dungeon8_9:Class;
	/*108*/	[Embed(source = '../assets/levels/Dungeon8/10.oel', mimeType = "application/octet-stream")] public static var Dungeon8_10:Class;
	/*109*/	[Embed(source = '../assets/levels/Dungeon8/11.oel', mimeType = "application/octet-stream")] public static var Dungeon8_11:Class;
	/*110*/	[Embed(source = '../assets/levels/Dungeon8/12.oel', mimeType = "application/octet-stream")] public static var Dungeon8_12:Class;
	
	/*111*/	[Embed(source = '../assets/levels/End/1.oel', mimeType = "application/octet-stream")] public static var End_1:Class;
	/*112*/	[Embed(source = '../assets/levels/End/Boss.oel', mimeType = "application/octet-stream")] public static var End_Boss:Class;
	/*113*/	[Embed(source = '../assets/levels/End/2.oel', mimeType = "application/octet-stream")] public static var End_2:Class;
	/*114*/	[Embed(source = '../assets/levels/End/3.oel', mimeType = "application/octet-stream")] public static var End_3:Class;
	/*115*/	[Embed(source = '../assets/levels/End/4.oel', mimeType = "application/octet-stream")] public static var End_4:Class;

	
		public static const levels:Array = new Array(OverWorld1, Building1, 
		Dungeon1_Entrance, Dungeon1_1, Dungeon1_2, Dungeon1_3, Dungeon1_4, Dungeon1_5, Dungeon1_6, Dungeon1_7, Dungeon1_8, Dungeon1_9,
		OverWorld1_1,
		Dungeon2_Entrance, Dungeon2_1, Dungeon2_2, Dungeon2_3, Dungeon2_4, Dungeon2_5, Dungeon2_Boss, Dungeon2_7,
		Dungeon3_Entrance, Dungeon3_1, Dungeon3_2, Dungeon3_3, Dungeon3_4, Dungeon3_5, Dungeon3_6, Dungeon3_7, Dungeon3_8, Dungeon3_9, Dungeon3_10, Dungeon3_Boss,
		OverWorld1_witchhut, OverWorld1_barhouse, OverWorld1_blandashurmin, OverWorld1_intree, OverWorld1_2,
		Dungeon4_Entrance, Dungeon4_1, Dungeon4_2, Dungeon4_3, Dungeon4_4, Dungeon4_Boss,
		OverWorld1_3,
		Dungeon5_Entrance, Dungeon5_1, Dungeon5_2, Dungeon5_3, Dungeon5_4, Dungeon5_5, Dungeon5_6, Dungeon5_7, Dungeon5_8, Dungeon5_9, Dungeon5_10, Dungeon5_11, Dungeon5_Boss, Dungeon5_DeadBoss,
		Dungeon6_Entrance, Dungeon6_1, Dungeon6_2, Dungeon6_3, Dungeon6_4, Dungeon6_5, Dungeon6_6, Dungeon6_7, Dungeon6_8, Dungeon6_9, Dungeon6_Boss, Dungeon6_10,
		Dungeon7_Entrance, Dungeon7_1, Dungeon7_2, Dungeon7_3, Dungeon7_4, Dungeon7_5, Dungeon7_6, Dungeon7_7, Dungeon7_8, Dungeon7_9, Dungeon7_10, Dungeon7_Boss,
		OverWorld_fallhole, OverWorld_fallhole1, OverWorld_d7entrance, OverWorld_house, OverWorld1_4, OverWorld1_5, OverWorld1_6, OverWorld_waterfallcave, OverWorld_mountain,
		OverWorld_mountain1, OverWorld_finalboss, OverWorld_treelarge, OverWorld_d6entrance, Dungeon7_11, Dungeon7_12,
		Dungeon8_Entrance, Dungeon8_1, Dungeon8_2, Dungeon8_3, Dungeon8_4, Dungeon8_5, Dungeon8_6, Dungeon8_7, Dungeon8_8, Dungeon8_9, Dungeon8_10, Dungeon8_11, Dungeon8_12,
		End_1, End_Boss, End_2, End_3, End_4);
		
		public static const bossMusic:int = 13;
		public static var levelMusics:Array = new Array(0, 3, 
		5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
		0,
		6, 6, 6, 6, 6, 6, -1, 6,
		7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, -1,
		0, 0, 0, 0, 0,
		8, 8, 8, 8, 8, -1,
		0,
		0, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, -1, 9,
		10, 10, 10, 10, 10, 10, 10, 10, 10, 10, -1, 10,
		11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, -1,
		0, 11, 11, 0, 0, 0, 0, 0, 0,
		0, 12, 0, 0, 11, 11,
		12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12,
		5, -1, 5, 5, 5);
		
		/*TILES*/
		[Embed(source = "../assets/graphics/Grass.png")] private static var imgGrass:Class;
		public static var sprGrass:Spritemap = new Spritemap(imgGrass, 3, 4);
		[Embed(source = "../assets/graphics/Shore.png")] private static var imgGround:Class;
		public static var sprGround:Spritemap = new Spritemap(imgGround, 16, 16);
		[Embed(source = "../assets/graphics/Water.png")] private static var imgWater:Class;
		public static var sprWater:Spritemap = new Spritemap(imgWater, 16, 16);
		[Embed(source = "../assets/graphics/Stone.png")] private static var imgStone:Class;
		public static var sprStone:Spritemap = new Spritemap(imgStone, 16, 16);
		[Embed(source = "../assets/graphics/Brick.png")] private static var imgBrick:Class;
		public static var sprBrick:Spritemap = new Spritemap(imgBrick, 16, 16);
		[Embed(source = "../assets/graphics/Dirt.png")] private static var imgDirt:Class;
		public static var sprDirt:Spritemap = new Spritemap(imgDirt, 16, 16);
		[Embed(source = "../assets/graphics/DungeonTile.png")] private static var imgDungeonTile:Class;
		public static var sprDungeonTile:Spritemap = new Spritemap(imgDungeonTile, 16, 16);
		[Embed(source = "../assets/graphics/Pit.png")] private static var imgPit:Class;
		public static var sprPit:Spritemap = new Spritemap(imgPit, 16, 16);
		[Embed(source = "../assets/graphics/ShieldTile.png")] private static var imgShieldTile:Class;
		public static var sprShieldTile:Spritemap = new Spritemap(imgShieldTile, 16, 16);
		[Embed(source = "../assets/graphics/ForestTile.png")] private static var imgForest:Class;
		public static var sprForest:Spritemap = new Spritemap(imgForest, 16, 16);
		[Embed(source = "../assets/graphics/Cliff.png")] private static var imgCliff:Class;
		public static var sprCliff:Spritemap = new Spritemap(imgCliff, 16, 16);
		[Embed(source = "../assets/graphics/Wood.png")] private static var imgWood:Class;
		public static var sprWood:Spritemap = new Spritemap(imgWood, 16, 16);
		[Embed(source = "../assets/graphics/WoodWalk.png")] private static var imgWoodWalk:Class;
		public static var sprWoodWalk:Spritemap = new Spritemap(imgWoodWalk, 16, 16);
		[Embed(source = "../assets/graphics/Cave.png")] private static var imgCave:Class;
		public static var sprCave:Spritemap = new Spritemap(imgCave, 16, 16);
		[Embed(source = "../assets/graphics/WoodTree.png")] private static var imgWoodTree:Class;
		public static var sprWoodTree:Spritemap = new Spritemap(imgWoodTree, 16, 16);
		[Embed(source = "../assets/graphics/DarkTile.png")] private static var imgDarkTile:Class;
		public static var sprDarkTile:Spritemap = new Spritemap(imgDarkTile, 16, 16);
		[Embed(source = "../assets/graphics/IgneousTile.png")] private static var imgIgneousTile:Class;
		public static var sprIgneousTile:Spritemap = new Spritemap(imgIgneousTile, 16, 16);
		[Embed(source = "../assets/graphics/Lava2.png")] private static var imgLava:Class;
		public static var sprLava:Spritemap = new Spritemap(imgLava, 16, 16);
		[Embed(source = "../assets/graphics/BlueStone.png")] private static var imgBlueTile:Class;
		public static var sprBlueTile:Spritemap = new Spritemap(imgBlueTile, 16, 16);
		[Embed(source = "../assets/graphics/BlueStoneWall.png")] private static var imgBlueTileWall:Class;
		public static var sprBlueTileWall:Spritemap = new Spritemap(imgBlueTileWall, 16, 16);
		[Embed(source = "../assets/graphics/BlueStoneWallDark.png")] private static var imgBlueTileWallDark:Class;
		public static var sprBlueTileWallDark:Spritemap = new Spritemap(imgBlueTileWallDark, 16, 16);
		[Embed(source = "../assets/graphics/Snow.png")] private static var imgSnow:Class;
		public static var sprSnow:Spritemap = new Spritemap(imgSnow, 16, 16);
		[Embed(source = "../assets/graphics/Ice.png")] private static var imgIce:Class;
		public static var sprIce:Spritemap = new Spritemap(imgIce, 16, 16);
		[Embed(source = "../assets/graphics/IceWall.png")] private static var imgIceWall:Class;
		public static var sprIceWall:Spritemap = new Spritemap(imgIceWall, 16, 16);
		[Embed(source = "../assets/graphics/IceWallLit.png")] private static var imgIceWallLit:Class;
		public static var sprIceWallLit:Spritemap = new Spritemap(imgIceWallLit, 16, 16);
		[Embed(source = "../assets/graphics/Waterfall.png")] private static var imgWaterfall:Class;
		public static var sprWaterfall:Spritemap = new Spritemap(imgWaterfall, 16, 16);
		[Embed(source = "../assets/graphics/Body.png")] private static var imgBody:Class;
		public static var sprBody:Spritemap = new Spritemap(imgBody, 16, 16);
		[Embed(source = "../assets/graphics/BodyWall.png")] private static var imgBodyWall:Class;
		public static var sprBodyWall:Spritemap = new Spritemap(imgBodyWall, 16, 16);
		[Embed(source = "../assets/graphics/GhostTile.png")] private static var imgGhostTile:Class;
		public static var sprGhostTile:Spritemap = new Spritemap(imgGhostTile, 16, 16);
		[Embed(source = "../assets/graphics/OpenBridge.png")] public static var imgBridge:Class;
		public static var sprBridge:Spritemap = new Spritemap(imgBridge, 16, 16);
		[Embed(source = "../assets/graphics/GhostTileStep.png")] private static var imgGhostTileStep:Class;
		public static var sprGhostTileStep:Spritemap = new Spritemap(imgGhostTileStep, 16, 16);
		[Embed(source = "../assets/graphics/IgneousLava.png")] private static var imgIgneousLava:Class;
		public static var sprIgneousLava:Spritemap = new Spritemap(imgIgneousLava, 16, 16);
		[Embed(source = "../assets/graphics/OddTile.png")] private static var imgOddTile:Class;
		public static var sprOddTile:Spritemap = new Spritemap(imgOddTile, 16, 16);
		[Embed(source = "../assets/graphics/FuchTile.png")] private static var imgFuchTile:Class;
		public static var sprFuchTile:Spritemap = new Spritemap(imgFuchTile, 16, 16);
		[Embed(source = "../assets/graphics/OddTileWall.png")] private static var imgOddTileWall:Class;
		public static var sprOddTileWall:Spritemap = new Spritemap(imgOddTileWall, 16, 16);
		[Embed(source = "../assets/graphics/RockTile.png")] private static var imgRockTile:Class;
		public static var sprRockTile:Spritemap = new Spritemap(imgRockTile, 16, 16);
		[Embed(source = "../assets/graphics/RockyTile.png")] private static var imgRockyTile:Class;
		public static var sprRockyTile:Spritemap = new Spritemap(imgRockyTile, 16, 16);
		
		
		/*CLIFFSIDE*/
		[Embed(source = "../assets/graphics/CliffSide.png")] private static var imgCliffSides:Class;
		public static var sprCliffSides:Spritemap = new Spritemap(imgCliffSides, 16, 16);
		[Embed(source = "../assets/graphics/CliffSideMaskL.png")] public static var imgCliffSidesMaskL:Class;
		[Embed(source = "../assets/graphics/CliffSideMaskR.png")] public static var imgCliffSidesMaskR:Class;
		[Embed(source = "../assets/graphics/CliffSideMaskLU.png")] public static var imgCliffSidesMaskLU:Class;
		[Embed(source = "../assets/graphics/CliffSideMaskRU.png")] public static var imgCliffSidesMaskRU:Class;
		[Embed(source = "../assets/graphics/CliffSideMaskU.png")] public static var imgCliffSidesMaskU:Class;
		
		[Embed(source = "../assets/graphics/CliffStairs.png")] private static var imgCliffStairs:Class;
		public static var sprCliffStairs:Spritemap = new Spritemap(imgCliffStairs, 16, 16);
		
		/*BUILDINGS*/
		[Embed(source = "../assets/graphics/Building.png")] private static var imgBuilding:Class;
		public static var sprBuilding:Image = new Image(imgBuilding);
		[Embed(source = "../assets/graphics/BuildingMask.png")] public static var imgBuildingMask:Class;
		
		[Embed(source = "../assets/graphics/Building1.png")] private static var imgBuilding1:Class;
		public static var sprBuilding1:Image = new Image(imgBuilding1);
		[Embed(source = "../assets/graphics/Building1Mask.png")] public static var imgBuilding1Mask:Class;
		
		[Embed(source = "../assets/graphics/Building2.png")] private static var imgBuilding2:Class;
		public static var sprBuilding2:Image = new Image(imgBuilding2);
		[Embed(source = "../assets/graphics/Building2Mask.png")] public static var imgBuilding2Mask:Class;
		
		[Embed(source = "../assets/graphics/Building3.png")] private static var imgBuilding3:Class;
		public static var sprBuilding3:Image = new Image(imgBuilding3);
		[Embed(source = "../assets/graphics/Building3Mask.png")] public static var imgBuilding3Mask:Class;
		
		[Embed(source = "../assets/graphics/Building4.png")] private static var imgBuilding4:Class;
		public static var sprBuilding4:Image = new Image(imgBuilding4);
		[Embed(source = "../assets/graphics/Building4Mask.png")] public static var imgBuilding4Mask:Class;
		
		[Embed(source = "../assets/graphics/Building5.png")] private static var imgBuilding5:Class;
		public static var sprBuilding5:Image = new Image(imgBuilding5);
		[Embed(source = "../assets/graphics/Building5Mask.png")] public static var imgBuilding5Mask:Class;
		
		[Embed(source = "../assets/graphics/Building6.png")] private static var imgBuilding6:Class;
		public static var sprBuilding6:Image = new Image(imgBuilding6);
		[Embed(source = "../assets/graphics/Building6Mask.png")] public static var imgBuilding6Mask:Class;
		
		[Embed(source = "../assets/graphics/Building7.png")] private static var imgBuilding7:Class;
		public static var sprBuilding7:Image = new Image(imgBuilding7);
		[Embed(source = "../assets/graphics/Building7Mask.png")] public static var imgBuilding7Mask:Class;
		
		[Embed(source = "../assets/graphics/Building8.png")] private static var imgBuilding8:Class;
		public static var sprBuilding8:Spritemap = new Spritemap(imgBuilding8, 64, 64);
		[Embed(source = "../assets/graphics/Building8Mask.png")] public static var imgBuilding8Mask:Class;
		
		public static var buildings:Array = new Array(sprBuilding, sprBuilding1, sprBuilding2, sprBuilding3, sprBuilding4, 
													 sprBuilding5, sprBuilding6, sprBuilding7, sprBuilding8);
		public static var buildingMasks:Array = new Array(imgBuildingMask, imgBuilding1Mask, imgBuilding2Mask, imgBuilding3Mask, imgBuilding4Mask, 
														 imgBuilding5Mask, imgBuilding6Mask, imgBuilding7Mask, imgBuilding8Mask);
														 
		/*STATUES*/
		[Embed(source = "../assets/graphics/Statues.png")] private static var imgStatues:Class;
		public static var sprStatues:Spritemap = new Spritemap(imgStatues, 48, 40);
		
		/*ROCKS*/
		[Embed(source = "../assets/graphics/Rock.png")] private static var imgRock:Class;
		public static var sprRock:Image = new Image(imgRock);
		
		[Embed(source = "../assets/graphics/Rock2.png")] private static var imgRock2:Class;
		public static var sprRock2:Image = new Image(imgRock2);
		
		[Embed(source = "../assets/graphics/Rock3.png")] private static var imgRock3:Class;
		public static var sprRock3:Image = new Image(imgRock3);
		
		[Embed(source = "../assets/graphics/Rock4.png")] private static var imgRock4:Class;
		public static var sprRock4:Image = new Image(imgRock4);
		
		public static var rocks:Array = new Array(sprRock, sprRock2, sprRock3, sprRock4);
		
		/*OTHER*/
		[Embed(source = "../assets/graphics/Pole.png")] private static var imgPole:Class;
		public static var sprPole:Spritemap = new Spritemap(imgPole, 16, 16);
		[Embed(source = "../assets/graphics/Wire.png")] private static var imgWire:Class;
		public static var sprWire:Spritemap = new Spritemap(imgWire, 16, 16);
		
		[Embed(source = "../assets/graphics/Tree2.png")] private static var imgTree:Class;
		public static var sprTree:Spritemap = new Spritemap(imgTree, 32, 32);
		[Embed(source = "../assets/graphics/TreeBare.png")] private static var imgTreeBare:Class;
		public static var sprTreeBare:Spritemap = new Spritemap(imgTreeBare, 32, 32);
		[Embed(source = "../assets/graphics/OpenTree.png")] private static var imgOpenTree:Class;
		public static var sprOpenTree:Spritemap = new Spritemap(imgOpenTree, 32, 32);
		[Embed(source = "../assets/graphics/OpenTreeMask.png")] public static var imgOpenTreeMask:Class;
		
		[Embed(source = "../assets/graphics/Blizzard.png")] private static var imgBlizzard:Class;
		public static var sprBlizzard:Image = new Image(imgBlizzard);
		[Embed(source = "../assets/graphics/Light.png")] private static var imgLight:Class;
		public static var sprLight:Image = new Image(imgLight);
		
		[Embed(source = "../assets/graphics/SnowHill.png")] private static var imgSnowHill:Class;
		public static var sprSnowHill:Image = new Image(imgSnowHill);
		[Embed(source = "../assets/graphics/SnowHillMask.png")] public static var imgSnowHillMask:Class;
		
		[Embed(source = "../assets/graphics/WaterfallSpray.png")] public static const imgWaterfallSpray:Class;
		
		[Embed(source = "../assets/graphics/PitShadow.png")] private static var imgPitShadow:Class;
		public static var sprPitShadow:Spritemap = new Spritemap(imgPitShadow, 16, 16);
		
		[Embed(source = "../assets/graphics/Droplet.png")] private static var imgDroplet:Class;
		public static var sprDroplet:Spritemap = new Spritemap(imgDroplet, 9, 5);
		
		[Embed(source = "../assets/graphics/Health.png")] private static var imgHealth:Class;
		public static var sprHealth:Spritemap = new Spritemap(imgHealth, 12, 12);
		
		[Embed(source = "../assets/graphics/BlurRegion.png")] private static var imgBlurRegion:Class;
		public static var sprBlurRegion:Image = new Image(imgBlurRegion);
		
		[Embed(source = "../assets/graphics/BlurRegion2.png")] private static var imgBlurRegion2:Class;
		public static var sprBlurRegion2:Image = new Image(imgBlurRegion2);
		
		[Embed(source = "../assets/graphics/TreeLarge.png")] private var imgTreeLarge:Class;
		private var sprTreeLarge:Spritemap = new Spritemap(imgTreeLarge, 160, 192);
		
		[Embed(source = "../assets/graphics/Logo2.png")] private var imgLogo:Class;
		private var sprLogo:Spritemap = new Spritemap(imgLogo, 152, 62);
		
		[Embed(source = "../assets/graphics/pixel_logo_medium.png")] private var imgNG:Class;
		private var sprNG:Spritemap = new Spritemap(imgNG, 87, 75);
		
		[Embed(source = "../assets/graphics/promos.png")] private var imgGames:Class;
		private var spGames:DisplayObject = new imgGames();
		
		[Embed(source = "../assets/graphics/MenuArrow.png")] private var imgMenuArrow:Class;
		private var sprMenuArrow:Spritemap = new Spritemap(imgMenuArrow, 16, 16);
		
		/*BOSS KEYS/LOCKS*/
		[Embed(source = "../assets/graphics/BossLock.png")] private static var imgBossLock:Class;
		private static var sprBossLock:Spritemap = new Spritemap(imgBossLock, 16, 16);
		[Embed(source = "../assets/graphics/BossLock1.png")] private static var imgBossLock1:Class;
		private static var sprBossLock1:Spritemap = new Spritemap(imgBossLock1, 16, 16);
		[Embed(source = "../assets/graphics/BossLock2.png")] private static var imgBossLock2:Class;
		private static var sprBossLock2:Spritemap = new Spritemap(imgBossLock2, 16, 16);
		[Embed(source = "../assets/graphics/BossLock3.png")] private static var imgBossLock3:Class;
		private static var sprBossLock3:Spritemap = new Spritemap(imgBossLock3, 16, 16);
		[Embed(source = "../assets/graphics/BossLock4.png")] private static var imgBossLock4:Class;
		private static var sprBossLock4:Spritemap = new Spritemap(imgBossLock4, 16, 16);
		
		[Embed(source = "../assets/graphics/BossKey.png")] private static var imgBossKey:Class;
		public static var sprBossKey:Spritemap = new Spritemap(imgBossKey, 12, 16);
		[Embed(source = "../assets/graphics/BossKey1.png")] private static var imgBossKey1:Class;
		public static var sprBossKey1:Spritemap = new Spritemap(imgBossKey1, 12, 16);
		[Embed(source = "../assets/graphics/BossKey2.png")] private static var imgBossKey2:Class;
		public static var sprBossKey2:Spritemap = new Spritemap(imgBossKey2, 12, 16);
		[Embed(source = "../assets/graphics/BossKey3.png")] private static var imgBossKey3:Class;
		public static var sprBossKey3:Spritemap = new Spritemap(imgBossKey3, 12, 16);
		[Embed(source = "../assets/graphics/BossKey4.png")] private static var imgBossKey4:Class;
		public static var sprBossKey4:Spritemap = new Spritemap(imgBossKey4, 12, 16);
		
		public static var bossLocks:Array = new Array(sprBossLock, sprBossLock1, sprBossLock2, sprBossLock3, sprBossLock4);
		public static var bossKeys:Array = new Array(sprBossKey, sprBossKey1, sprBossKey2, sprBossKey3, sprBossKey4);
		
		/*Main variables*/
		public static const cheats:Boolean = false;
		public static var menu:Boolean = true; //Whether or not the game should start as a menu
		public static const menuLevels:Array = new Array(12, 37, 44, 87, 88, 89);
		private static var menuIndex:int = 0;
		private const restartKey:int = Key.R;
		private const escapeKey:int = Key.ESCAPE;
		private const yesKey:int = Key.Y;
		private const muteKey:int = Key.M;
		private const menuKeyLeft:int = Key.LEFT;
		private const menuKeyRight:int = Key.RIGHT;
		private var restart:Boolean;
		
		public static var inventory:Inventory;
		public static const dayLength:uint = 160 * Main.FPS; //the number is the number of seconds per day		
															//The first quarter is dawn, the second two are day, and the last quarter is twilight
		public static const nightLength:uint = 80 * Main.FPS; //the number is the number of seconds per night
		public var todaysTime:int = 0; //The time of the current day; 0 is dawn, and the last frame is the last of night.
		public var lightAlpha:Number = 1;
		public const minLightAlpha:Number = 0.1; //This is added to whatever light alpha is gained from the level itself.
		public static var daysPassed:int = 0;
		public static const minDarkness:Number = 0.1;
		public var dayNight:Boolean = true;
		public var nightBmp:BitmapData = new BitmapData(FP.screen.width, FP.screen.height, false, 0x000000);
		public var solidBmp:BitmapData = new BitmapData(FP.screen.width, FP.screen.height, true, 0x00000000); //For drawing 1-alpha pics that'll be dimmed onto nightBmp
		private const solidBmpAlpha:Number = 1;
		//public var underwaterBmp:BitmapData = new BitmapData(FP.screen.width, FP.screen.height, false, 0x2222FF);
		public var underBmp:BitmapData = new BitmapData(FP.screen.width, FP.screen.height, true, 0x00000000);
		
		//Snow variables
		private var snowBmp:BitmapData = new BitmapData(FP.buffer.width, FP.buffer.height, false, 0);
		private var bwBuffer:BitmapData = new BitmapData(FP.buffer.width, FP.buffer.height, false, 0);
		public static var blackAndWhite:Boolean = true;
		public static var snowing:Boolean = true;
		public static var blizzardOffset:Point = new Point();
		public static const blizzardRate:Point = new Point(10, 10);
		public static const DEFAULT_SNOW_ALPHA:Number = 0.25;
		public var snowAlpha:Number = 0;
		
		public static const speakingAlpha:Number = 0.8; //The alpha of the bars that come down when talking to an NPC
		public static const speakingColor:uint = 0x000000; //The color of the bars that come down when talking to an NPC
		
		public static const timePerFrame:int = 45;
		public static var _time:Number;
		public static function set time(_t:Number):void
		{
			Main.time = _t;
		}
		public static function get time():Number
		{
			return Main.time;
		}
		public var timeRate:Number = 1;
		
		public static function set moonrockSet(_t:Boolean):void
		{
			Main.rockSet = _t;
		}
		public static function get moonrockSet():Boolean
		{
			return Main.rockSet;
		}
		
		public static var underwater:Boolean;
		
		public static var freezeObjects:Boolean = false;
		public static var ALIGN:String = "LEFT";
		public static var talking:Boolean = false; //Whether in a conversation with an NPC
		public static var _talkingText:String = ""; //The text to display for a conversation
		public static var talkingPic:Image; //The picture to display for the person talking to you
		
		private var drawBlackCover:Boolean = true;
		public var blackCover:Number = 1;
		public var blackCoverRate:Number = -0.05;
		
		public var blurRegion:Boolean = false;
		public var blurRegion2:Boolean = false;
		
		private var checked:Boolean = false;
		public static const tagsPerLevel:int = 30;
		public function set level(i:int):void
		{
			Main.level = i;
		}
		public function get level():int
		{
			return Main.level;
		}
		public static var fallthroughLevel:int = -1;
		public static var fallthroughOffset:Point;
		public static var setFallFromCeiling:Boolean = false;
		
		public static var shake:Number = 0; //set this to a value to have the screen shake
		private var newCoverColor:uint = 0x000000;
		private var newCoverAlpha:Number = 0;
		private var newCoverDraw:Boolean = false;
		
		//Rain
		public static var raining:Boolean = false;
		public var rainingHeaviness:int = 0;
		public var rainingRect:Rectangle = new Rectangle;
		public var rainingHeight:int = 0;
		public var rainingColor:uint = 0;
		
		public static var healthc:int = 0;
		public static var healths:int = 0;
		
		public static var currentPlayerPosition:Point;
		public var _playerPosition:Point;
		public function set playerPosition(p:Point):void
		{
			currentPlayerPosition = p.clone();
			_playerPosition = p.clone();
			Main.playerPositionX = p.x;
			Main.playerPositionY = p.y;
			//trace("Changed, bitch: " + p.x + ", " + p.y);
		}
		public function get playerPosition():Point
		{
			return _playerPosition;
		}
		
		public static var _cameraTarget:Point = new Point( -1, -1);
		public static var cameraSpeedDivisorDef:int = 10;
		public static var cameraSpeedDivisor:int = cameraSpeedDivisorDef;
		public function resetCameraSpeed():void
		{
			cameraSpeedDivisor = cameraSpeedDivisorDef;
		}
		
		//Controls it a "Message" is shown at the start of this level (-1 means one is not shown)
		public static var sign:int = -1;
		public static var fallthroughSign:int = -1;
		
		//Main Menu motion stuff
		private static var menuOffset:Point = new Point;
		private const menuAlphaDivisor:int = 128;
		private const menuStates:int = 4;
		private const menuTweenTime:int = 10;
		private static var menuState:int = 0;
		private static var menuTween:Tween;
		private static var menuScroll:Number = 0;
		private var menuMaxWidth:Object = { "controls": { "left":0, "right":0 }, "credits":0 };
		private const menuText:Array = new Array("Arrows", "X", "C", "V or I", "----------", "Esc", "R", "M", "W");
		private const menuTextAppend:Array = new Array("move", "action", "secondary", "inventory", "----------", "menu", "restart game", "mute", "soundtrack");
		private const menuCreditsTitles:Array = new Array("Programming\n & Graphics", "Sound", "Concept", "Thanks to");
		private const menuCreditsNames:Array = new Array(new Array("Connor Ullmann"), new Array("Roger \"Rekcahdam\" Hicks"), new Array("Connor Ullmann", "Joe Biglin", "Lisa Miller", "Dan Tsukasa"), new Array("Newgrounds", "Sheldon Ketterer", "Grant Demeter", "Collin Ullmann", "Max Beck", "Ian Ting"));
		private static var rightArrowScale:Number = 1;
		private static var leftArrowScale:Number = 1;
		private static var arrowMoveRate:Number = 0.03;
		private static var arrowMove:Number = 0;
		
		public static var tiles:Vector.<Vector.<Tile>>;
		
		public static var currentCharacter:int = 0; // The current character being displayed in a string.
		public static const framesPerCharacterDefault:int = 4;
		public static var framesPerCharacter:int = framesPerCharacterDefault; //The number of frames for each character displayed in the string.
		private var framesThisCharacter:int = 0; //The counter for frames for each character displayed in the string.
		private var proceedText:Boolean = true;
		
		public static var cutscene:Array = new Array(false, false, false, false);
		private var cTextIndex:int = 0;
		private static var cutsceneText:Array = new Array(
			new Array("Wind calls you to life.", "Go, learn of good and evil.", "Answers lie in this house."),
			new Array());
		private static const textTime:int = 10; //Time between each message.
		private var textTimer:int = textTime;
		/*
		 * cutsceneTimer[0][0] controls the time before the first message pops up during the wind.
		 */
		private var cutsceneTimer:Array = new Array(
			new Array(3 * Main.FPS, 210),
			new Array()); //used for live counting.
		
		public function Game(_level:int=-1, _playerx:int=80, _playery:int=128, _restart:Boolean=false, _menuState:int=-1) 
		{
			super();
			level = _level;
			playerPosition = new Point(_playerx, _playery);
			Main.printItems();
			
			restart = _restart;
			
			if (_menuState >= 0)
				menuState = _menuState
			
			end();
			
			if (!inventory)
			{
				inventory = new Inventory();
			}
			
			Music.bkgdVolumeMaxExtern = Music.fadeVolumeMaxExtern = 1; //Restore the volume.
			
			if (menu)
				FP.engine.addChild(spGames);
		}
		override public function end():void
		{
			Inventory.drawFirstUseHelp = Inventory.drawExtendedHelp = false;
			underwater = false;
			talking = false;
			talkingText = "";
			talkingPic = null;
			fallthroughLevel = -1;
			fallthroughSign = -1;
			fallthroughOffset = new Point();
			resetCamera();
			resetCameraSpeed();		
			if (!menu)
			{
				menuOffset = new Point;
				menuState = 0;
				menuScroll = 0;
				clearTweens();
				menuTween = null;
				rightArrowScale = leftArrowScale = 1;
				arrowMove = 0;
				arrowMoveRate = Math.abs(arrowMoveRate);
			}
			
			if (FP.engine.contains(spGames))
			{
				FP.engine.removeChild(spGames);
			}
		}
		override public function begin():void
		{
			/*if (Main.hasSealPart(SealController.SEALS - 2) == -1)
			{
				for (var i:int = 0; i < 15; i++)
				{
					var index:int = -1;
					while (index < 0 || !SealController.getSealPart(index))
					{
						index = Math.floor(Math.random() * SealController.SEALS);
					}
				}
			}*/
			super.begin();
			sprGrass.x = -sprGrass.width / 2;
			sprGrass.y = -sprGrass.height;
			sprWater.centerOO();
			sprGround.centerOO();
			sprStone.centerOO();
			sprBrick.centerOO();
			sprDirt.centerOO();
			sprDungeonTile.centerOO();
			sprPit.centerOO();
			sprShieldTile.centerOO();
			sprForest.centerOO();
			sprCliff.centerOO();
			sprCliffStairs.centerOO();
			sprWood.centerOO();
			sprWoodWalk.centerOO();
			sprCave.centerOO();
			sprWoodTree.centerOO();
			sprDarkTile.centerOO();
			sprIgneousTile.centerOO();
			sprLava.centerOO();
			sprBlueTile.centerOO();
			sprBlueTileWall.centerOO();
			sprBlueTileWallDark.centerOO();
			sprSnow.centerOO();
			sprIce.centerOO();
			sprIceWall.centerOO();
			sprIceWallLit.centerOO();
			sprWaterfall.centerOO();
			sprBody.centerOO();
			sprBodyWall.centerOO();
			sprGhostTile.centerOO();
			sprBridge.centerOO();
			sprGhostTileStep.centerOO();
			sprIgneousLava.centerOO();
			sprOddTile.centerOO();
			sprFuchTile.centerOO();
			sprOddTileWall.centerOO();
			sprRockTile.centerOO();
			sprRockyTile.centerOO();
			
			sprLogo.centerOO();
			sprNG.centerOO();
			sprOpenTree.centerOO();
			sprTreeBare.centerOO();
			sprTree.centerOO();
			sprPole.centerOO();
			sprBlizzard.centerOO();
			sprPitShadow.centerOO();
			sprDroplet.centerOO();
			sprMenuArrow.centerOO();
			
			
			for (var i:int = 0; i < bossLocks.length; i++)
			{
				bossLocks[i].centerOO();
			}
			
			for (i = 0; i < bossKeys.length; i++)
			{
				bossKeys[i].centerOO();
			}
			
			if (menu)
			{
				loadlevel(levels[menuLevels[menuIndex]]);
				cameraTarget = new Point((FP.width - FP.screen.width) * (menuIndex % 2), (FP.height - FP.screen.height) * (menuIndex % 2));
				FP.camera = cameraTarget.clone();
				//trace(menuLevels[menuIndex] + ": " + FP.camera.x + ", " + FP.camera.y);
				Input.clear();
				
				if (menuState != 0)
				{
					menuTween = new Tween(menuTweenTime, Tween.ONESHOT);
					addTween(menuTween, true);
				}
			}
			else
			{
				if (level < 0)
				{
					if (!cheats)
					{
						time = dayLength / 2;
						Music.playSound("Wind", 0);
						cutscene[0] = true;
					}
					level = 0;
				}
				loadlevel(levels[level]);
			}
			
			inventory.check();
			
			if (sign >= 0)
			{
				add(new Message(FP.screen.width / 2, 0, sign));
				sign = -1;
			}
			
			
			if (cheats) FP.console.enable();
		}
		override public function update():void
		{		
			musicUpdate();
				
			if (Input.released(muteKey))
			{
				FP.volume = int(!FP.volume);
				Input.clear();
			}
			else
			{
				menuAndRestart();
			}
			
			if (!checked)
			{
				var v:Vector.<Entity> = new Vector.<Entity>();
				getAll(v);
				for (var i:int = 0; i < v.length; i++)
				{
					v[i].check();
				}
				checked = true;
			}
			if (blackCover <= 0)
			{
				super.update();
			}
			view();
			time += timeRate;
			if (time % (dayLength + nightLength) == 0)
			{
				daysPassed++;
			}
			todaysTime = time % (dayLength + nightLength);
			
			if (menu)
			{
				var cursor:String = MouseCursor.ARROW;
				var renderPt:Point = ngPos(menuOffset.x, menuOffset.y);
				if (Input.mouseX >= renderPt.x - sprNG.originX && Input.mouseX < renderPt.x - sprNG.originX + sprNG.width &&
					Input.mouseY >= renderPt.y - sprNG.originY && Input.mouseY < renderPt.y - sprNG.originY + sprNG.height)
				{
					cursor = MouseCursor.BUTTON;
					sprNG.frame = 1;
					if (Input.mouseDown)
					{
						sprNG.frame = 2;
					}
					else if (Input.mouseReleased)
					{
						new GetURL("http://www.newgrounds.com/games/browse/genre/adventure/interval/year/sort/score");
					}
				}
				else
				{
					sprNG.frame = 0;
				}
				
				if (spGames.alpha >= 1 && spGames.visible)
				{
					var gamesPos:Array = new Array(new Rectangle(33, 25, 282, 117), new Rectangle(33, 154, 282, 117), new Rectangle(33, 284, 282, 117));
					var links:Array = new Array("http://www.newgrounds.com/portal/view/555641",
												"http://www.newgrounds.com/portal/view/587346",
												"http://www.newgrounds.com/portal/view/579499");
					for (i = 0; i < gamesPos.length; i++)
					{
						var m:Point = new Point(Input.mouseX * FP.screen.scale, Input.mouseY * FP.screen.scale);
						if (m.x >= spGames.x + gamesPos[i].x && m.x < spGames.x + gamesPos[i].x + gamesPos[i].width &&
							m.y >= spGames.y + gamesPos[i].y && m.y < spGames.y + gamesPos[i].y + gamesPos[i].height)
						{
							cursor = MouseCursor.BUTTON;
							if (Input.mouseReleased)
							{
								new GetURL(links[i]);
							}
						}
					}
				}
				
				Mouse.cursor = cursor;
			}
			else
			{
				Mouse.cursor = MouseCursor.ARROW;
			}
			
			var p:Player = nearestToPoint("Player", 0, 0) as Player;
			if (p && classCount(Help) <= 0)
			{
				//Managing snow alpha in the level (Dungeon5/Entrance) where the snow gets intense
				if (level == 45 /* Dungeon5/Entrance.oel */) snowAlpha = DEFAULT_SNOW_ALPHA * Math.pow(1 - p.y / FP.height, 2);
				else snowAlpha = DEFAULT_SNOW_ALPHA;
				
				// The starting wind/text scene.
				if (cutscene[0])
				{
					ALIGN = "CENTER";
					freezeObjects = true;
					p.receiveInput = false;
					p.directionFace = 3;
					timeRate = Math.max(timeRate - 0.0025, 0);
					if (classCount(DustParticle) <= 100 && timeRate > 0)
					{
						FP.world.add(new DustParticle(FP.camera.x, Math.random() * FP.screen.height + FP.camera.y));
					}
					
					if (cutsceneTimer[0][0] > 0)
					{
						cutsceneTimer[0][0]--;
					}
					else if(cutsceneTimer[0][0] > -1)
					{
						talking = true;
						//The change in cTextIndex happens during the text function during the by-character change.
						if (cTextIndex <= 0)
						{
							proceedText = classCount(DustParticle) <= 0; //Stay on the first text segment until the dust clears
						}
						else
						{
							if (cutsceneTimer[0][1] > 0) //Pan the camera over the first dungeon for some time, and don't proceed with text.
							{
								proceedText = false;
								cutsceneTimer[0][1]--;
								cameraSpeedDivisor = 50;
								cameraTarget = new Point(256, 272);
							}
							else //Once the timer is up, reset the camera and let the text continue.
							{	
								resetCamera();
								resetCameraSpeed();
								proceedText = true;
								if (cTextIndex >= cutsceneText[0].length) //If we're all done showing the text, go ahead and reactivate the player.
								{
									cTextIndex = cutsceneText[0][cutsceneText[0].length - 1];
									cutsceneTimer[0][0] = -1;
									talking = false;
									freezeObjects = false;
									p.directionFace = -1;
									p.receiveInput = true;
									cutscene[0] = false;
									timeRate = 1;
									ALIGN = "LEFT";
									add(new Help(2));
								}
							}
						}
						
						talkingText = cutsceneText[0][cTextIndex];
					}
				}
				else if (cutscene[1])
				{
					p.directionFace = 1;
					p.receiveInput = false;
					p.v.y = -1;
					if (p.y <= 64)
					{
						p.v.y = 0;
					}
				}
				else if (cutscene[2])
				{
					p.receiveInput = false;
					p.visible = false;
					p.active = false;
				}
				else
				{
					cTextIndex = 0; //Reset the text index for this cutscene.
				}
			}
			if (raining)
			{
				const rainingHeavinessMax:int = 100;
				if (!Math.floor(Math.random() * (rainingHeavinessMax - rainingHeaviness)))
				{
					var rainingRectTemp:Rectangle = rainingRect.intersection(new Rectangle(FP.camera.x, FP.camera.y, FP.screen.width, FP.screen.height));
					if(rainingRectTemp)
						FP.world.add(new Droplet(rainingRectTemp.x + Math.random() * rainingRectTemp.width, rainingRectTemp.y + rainingRectTemp.height * Math.random(), rainingHeight, rainingColor));
				}
			}
			if (canInventory())
			{
				inventory.update();
			}
			else if (inventory)
			{
				inventory.open = false;
			}
		}
		override public function render():void
		{
			if (blurRegion)
			{
				sprBlurRegion.scale = 1 / 3;
				sprBlurRegion.render(new Point(FP.camera.x * (FP.width - sprBlurRegion.width*sprBlurRegion.scale)/(FP.width - FP.screen.width), FP.camera.y * (FP.height - sprBlurRegion.height*sprBlurRegion.scale)/(FP.height - FP.screen.height)), FP.camera);
			}
			if (blurRegion2)
			{
				sprBlurRegion2.x = -80;
				sprBlurRegion2.scale = 0.275;
				sprBlurRegion2.render(new Point(FP.camera.x * (FP.width - sprBlurRegion2.width * sprBlurRegion2.scale) / (FP.width - FP.screen.width), 
												FP.camera.y * (FP.height - sprBlurRegion2.height*sprBlurRegion2.scale) / (FP.height - FP.screen.height)), FP.camera);
			}
			FP.buffer.draw(underBmp);
			underBmp.fillRect(underBmp.rect, 0x00000000);
			
			super.render();
			bufferTransforms();
			
			talk();
			if (newCoverDraw)
			{
				Draw.rect(FP.camera.x, FP.camera.y, FP.screen.width, FP.screen.height, newCoverColor, newCoverAlpha);
			}
			if (canInventory())
			{
				inventory.render();
			}
			drawHealth();
			cover();
			
			var v:Vector.<Help> = new Vector.<Help>();
			getClass(Help, v);
			for each(var h:Help in v)
			{
				h.render();
			}
			
			var vm:Vector.<Message> = new Vector.<Message>();
			getClass(Message, vm);
			for each(var m:Message in vm)
			{
				m.render();
			}
			
			if (menu)
			{
				menuState = (menuState + menuStates) % menuStates;
				const stateInterval:int = FP.screen.width;
				const divisor:int = 10;
				if (menuTween)
					menuOffset.x = (-stateInterval * menuState - menuOffset.x) * menuTween.percent + menuOffset.x;
				else
					menuOffset.x = 0;
				
				drawPromos(menuOffset.x + stateInterval * 3, menuOffset.y);
				drawCreditsText(menuOffset.x + stateInterval * 2, menuOffset.y);
				drawHelpText(menuOffset.x + stateInterval, menuOffset.y);
				drawLogo(menuOffset.x, menuOffset.y);
				
				const arrowScaleRate:Number = 0.1;
				if (rightArrowScale > 1)
					rightArrowScale = Math.max(rightArrowScale - arrowScaleRate, 1);
				if (leftArrowScale > 1)
					leftArrowScale = Math.max(leftArrowScale - arrowScaleRate, 1);
					
				arrowMove += arrowMoveRate;
				if (arrowMove >= 1)
				{
					arrowMove = 1;
					arrowMoveRate = -Math.abs(arrowMoveRate);
				}
				if (arrowMove <= 0)
				{
					arrowMove = 0;
					arrowMoveRate = Math.abs(arrowMoveRate);
				}
				const arrowMoveMax:int = 8;
				const arrowMoveTemp:Number = arrowMoveMax * (1 - Math.sin(arrowMove * Math.PI));
				
				sprMenuArrow.scaleX = 1;
				sprMenuArrow.scale = rightArrowScale;
				sprMenuArrow.render(new Point(FP.screen.width - arrowMoveTemp - sprMenuArrow.width / 2, FP.screen.height - sprMenuArrow.height / 2), new Point);
				sprMenuArrow.scaleX = -sprMenuArrow.scaleX;
				sprMenuArrow.scale = leftArrowScale;
				sprMenuArrow.render(new Point(sprMenuArrow.width / 2 + arrowMoveTemp, FP.screen.height - sprMenuArrow.height / 2), new Point);
			}
			
			if (menu && restart)
			{
				Draw.rect(FP.camera.x, FP.camera.y, FP.screen.width, FP.screen.height, 0, 0.8);
				Text.size = 8;
				var text:Text = new Text("Would you like to restart? <Y>/<N>");
				text.color = 0xFFFFFF;
				text.render(new Point(FP.screen.width / 2 - text.width / 2, FP.screen.height / 2 - text.height / 2), new Point);
				Text.size = 16;
			}
			bufferRestore();
			
			//gameboy();
			
		}
		public function gameboy():void
		{
			const cols:Array = new Array(0xFF0E380F, 0xFF306230, 0xFF8BAC0F, 0xFF9BBC0F);
										//(0xFF000000, 0xFF222222, 0xFF444444, 0xFF666666, 0xFF888888, 0xFFAAAAAA, 0xFFCCCCCC, 0xFFFFFFFF);// 
			var hist:Vector.<Vector.<Number>> = FP.buffer.histogram();
			var temp:BitmapData = new BitmapData(FP.buffer.width, FP.buffer.height, true, 0);
			for (var i:int = 0; i < cols.length; i++)
			{
				var c:BitmapData = FP.buffer.clone();
				
				var range:int = 128;
				var r:uint = Math.min(Math.max(maxIndex(hist[1]) + range, range), 255);
				var g:uint = Math.min(Math.max(maxIndex(hist[2]) + range, range), 255);
				var b:uint = Math.min(Math.max(maxIndex(hist[3]) + range, range), 255);
				var minCol:uint = FP.getColorRGB(Math.max(r - range * 2, 0), Math.max(g - range * 2, 0), Math.max(b - range * 2, 0));
				var col:uint = 0xFF000000 + (FP.getColorRGB(r, g, b) - minCol) / cols.length * i + minCol;
				c.threshold(c, c.rect, new Point, "<", col);
				c.threshold(c, c.rect, new Point, ">=", col, cols[i]);
				temp.draw(c, null, null, BlendMode.HARDLIGHT);
				c.dispose();
			}
			FP.buffer.draw(temp);
			temp.dispose();
		}
		public function maxIndex(v:Vector.<Number>):int
		{
			if (v.length <= 0)
				return 0;
			var m:Number = v[0];
			var index:int = 0;
			for (var i:int = 1; i < v.length; i++)
			{
				if (v[i] > m)
				{
					index = i;
					m = v[i];
				}
			}
			return index;
		}
		
		/*
		 * Manages Music
		 */
		private function musicUpdate():void
		{
			if (snowAlpha > 0 && blackAndWhite)
			{
				const maxBlizzardVolume:Number = 0.5;
				if(!Music.soundIsPlaying("Wind", 1))
					Music.playSound("Wind", 1);
				Music.volumeSound("Wind", 1, snowAlpha / DEFAULT_SNOW_ALPHA * maxBlizzardVolume);
				
			}
			else
			{
				Music.stopSound("Wind", 1);
			}
			
			if (menu && !Music.sndOMenu.playing)
				Music.fadeToLoop(Music.sndOMenu);
			if (!menu)
			{
				if (Main.hasSword && !Main.hasShield && levelMusics[level] == 5 /* Watcher song */ && level != 10)
				{
					Music.stop(false, true, true);
				}
				else
				{
					if (!Main.hasSword && (levelMusics[level] == 5 || levelMusics[level] == 0) && level != 10)
					{
						if(!Music.songs[4].playing)
							Music.fadeToLoop(Music.songs[4], 0.05);
					}
					else if (levelMusics[level] >= 0)
					{
						if(!Music.songs[levelMusics[level]].playing)
							Music.fadeToLoop(Music.songs[levelMusics[level]], 0.05);
					}
					else
					{
						Music.fadeToLoop(null, 0.05);
					}
				}
			}
			if (Music.sndOTheme.playing)
			{
				const quarterDay:Number = dayLength / 4;
				var _a:Number = 1;
				if (todaysTime < quarterDay) //Dawn
				{
					_a = todaysTime / quarterDay;
				}
				else if (todaysTime < quarterDay * 3) //Daytime
				{
					
				}
				else if (todaysTime < dayLength) //Twilight
				{
					_a = 1 - (todaysTime - quarterDay * 3) / quarterDay;
				}
				else //Night
				{
					_a = 0;
				}
				Music.bkgdVolumeDefault = _a;
				Music.fadeVolumeDefault = _a;
			}	
			else
			{
				Music.bkgdVolumeDefault = 1;
				Music.fadeVolumeDefault = 1;
			}
		}
		
		private function menuAndRestart():void
		{
			if (menu)
			{
				cutscene[0] = false;
				
				if (Input.released(restartKey) && !restart)
				{
					restart = true;
					Input.clear();
				}
				else
				{
					if (restart)
					{
						if (Input.released(yesKey))
						{
							Main.clearSave();
							cutscene[1] = cutscene[2] = false;
							restart = false;
							menu = false;
							FP.world = new Game();
						}
						else if (Input.released(Key.ANY))
						{
							restart = false;
							Input.clear();
						}
					}
					else if (Input.released(menuKeyRight))
					{
						rightArrowScale = 2;
						menuState++;
						menuTween = new Tween(menuTweenTime, Tween.ONESHOT, null, Ease.circIn);
						addTween(menuTween, true);
						Music.playSound("Text", 1);
						Input.clear();
					}
					else if (Input.released(menuKeyLeft))
					{
						leftArrowScale = 2;
						menuState--;
						menuTween = new Tween(menuTweenTime, Tween.ONESHOT, null, Ease.circIn);
						addTween(menuTween, true);
						Music.playSound("Text", 1);
						Input.clear();
					}
					else if (Input.released(Key.ANY))// || Input.mouseReleased)
					{
						Input.clear();
						menu = false;
						FP.world = new Game(level, playerPosition.x, playerPosition.y);
					}
				}
				Game.freezeObjects = true;
				if (FP.width > FP.height)
				{
					cameraTarget = new Point(cameraTarget.x - 2*(menuIndex%2)+1, cameraTarget.x * (FP.height - FP.screen.height) / (FP.width - FP.screen.width));
				}
				else
				{
					cameraTarget = new Point(cameraTarget.y * (FP.width - FP.screen.width) / (FP.height - FP.screen.height), cameraTarget.y + 1);
				}
				drawCover(0, 1 - Math.sin(cameraTarget.x / (FP.width - FP.screen.width) * Math.PI));
				if (cameraTarget.x > FP.width - FP.screen.width || cameraTarget.x < -1 || cameraTarget.y > FP.height - FP.screen.height || cameraTarget.y < -1)
				{
					undrawCover();
					menuIndex = (menuIndex + 1) % menuLevels.length;
					FP.world = new Game(level, playerPosition.x, playerPosition.y);
					return;
				}
				
			}
			else
			{
				if (Input.released(restartKey))
				{
					menu = true;
					Input.clear();
					FP.world = new Game(level, playerPosition.x, playerPosition.y, true);
				}
				else if (Input.released(escapeKey))
				{
					menu = true;
					FP.world = new Game(level, playerPosition.x, playerPosition.y);
				}
			}
		}
		
		private function drawLogo(_xoff:int=0, _yoff:int=0):void
		{
			renderMenu(_xoff, _yoff);
			Draw.setTarget(nightBmp, new Point);
			renderMenu(_xoff, _yoff);
			Draw.resetTarget();
		}
		
		private function drawPromos(_xoff:int=0, _yoff:int=0):void
		{
			const maxRectAlpha:Number = 0.8;
			const basePos:Point = new Point(FP.screen.width / 2, FP.screen.height / 2);
			const tweenScale:Number = menuAlphaDivisor == 0 ? 1 : Math.max(1 - Math.abs(_xoff) / menuAlphaDivisor, 0);
			
			if (tweenScale <= 0)
			{
				spGames.visible = false;
				return;
			}
			spGames.visible = true;
			
			var rectW:int = (spGames.width * FP.screen.scale + 4) / 2;
			Draw.rect(FP.camera.x + basePos.x + _xoff - rectW, FP.camera.y, rectW * 2, FP.screen.height, 0, tweenScale * maxRectAlpha);
			
			spGames.alpha = tweenScale;
			spGames.x = (basePos.x + _xoff) * FP.screen.scale - spGames.width/2;
			spGames.y = (basePos.y + _yoff) * FP.screen.scale - spGames.height / 2;
		}
		private function drawCreditsText(_xoff:int=0, _yoff:int=0):void
		{
			const sectionToSectionMargin:int = 32; //The distance between the last text in "Programming/Graphics" to the title "Music"
			const titleToTextMargin:int = 0; //The distance between the title and the first name
			const nameToNameMargin:int = 0; //The distance between each name in the list.
			const rectToTextMargin:int = 4; //The distance between the text and the edge of the bounding black box
			const maxRectAlpha:Number = 0.8;
			const menuScrollSpeed:Number = 0.6;
			const basePos:Point = new Point(FP.screen.width / 2, FP.screen.height / 3);
			const tweenScale:Number = menuAlphaDivisor == 0 ? 1 : Math.max(1 - Math.abs(_xoff) / menuAlphaDivisor, 0);
			var text:Text;
			
			if (tweenScale <= 0)
				return;
			else
				menuScroll -= tweenScale * menuScrollSpeed;
			
			var rectW:int = tweenScale * (menuMaxWidth["credits"] + rectToTextMargin);
			Draw.rect(FP.camera.x + basePos.x + _xoff - rectW, FP.camera.y, rectW * 2, FP.screen.height, 0, tweenScale * maxRectAlpha);
			
			var height:int = 0;
			for (var i:int = 0; i < menuCreditsTitles.length; i++)
			{
				Text.size = 16;
				text = new Text(menuCreditsTitles[i]);
				text.x = basePos.x + _xoff;
				text.y = basePos.y + menuScroll + text.height/2 + height + _yoff;
				text.centerOO();
				text.alpha = text.scaleX = tweenScale;
				text.color = 0x88FF44;
				drawTextBold(text, null, 0x002200);
				height += text.height + titleToTextMargin;
				
				menuMaxWidth["credits"] = Math.max(text.width/2, menuMaxWidth["credits"]);
				
				Text.size = 8;
				var textName:Text;
				for (var j:int = 0; j < menuCreditsNames[i].length; j++)
				{
					textName = new Text(menuCreditsNames[i][j]);
					textName.x = basePos.x + _xoff;
					textName.y = basePos.y + menuScroll + text.height / 2 + height + _yoff;
					textName.centerOO();
					textName.alpha = textName.scaleX = tweenScale;
					textName.color = 0x8844FF;
					textName.render(new Point, new Point);
					//drawTextBold(textName, null, 0x000044);
					height += textName.height + (j + 1 < menuCreditsNames[i].length ? nameToNameMargin : sectionToSectionMargin);
					menuMaxWidth["credits"] = Math.max(textName.width/2, menuMaxWidth["credits"]);
				}
			}
			if (basePos.y + menuScroll + height + _yoff < 0)
			{
				menuState++;
				menuTween = new Tween(menuTweenTime, Tween.ONESHOT, null, Ease.circIn);
				addTween(menuTween, true);
				menuScroll = FP.screen.height - basePos.y;
			}
			Text.size = 16;
			
		}
		private function drawHelpText(_xoff:int=0, _yoff:int=0):void
		{
			const margin:int = 4;
			const maxRectAlpha:Number = 0.8;
			const basePos:Point = new Point(FP.screen.width / 2, FP.screen.height / 4);
			const tweenScale:Number = menuAlphaDivisor == 0 ? 1 : Math.max(1 - Math.abs(_xoff) / menuAlphaDivisor, 0);
			if (tweenScale <= 0)
				return;
				
			var text:Text;
			
			var rectW:Object = {"left":tweenScale * (menuMaxWidth["controls"]["left"] + margin), "right":tweenScale * (menuMaxWidth["controls"]["right"] + margin)};
			Draw.rect(FP.camera.x + basePos.x + _xoff - rectW["left"], FP.camera.y, rectW["left"] + rectW["right"], FP.screen.height, 0, tweenScale * maxRectAlpha);
			
			Text.size = 16;
			text = new Text("Controls");
			text.centerOO();
			text.scaleX = tweenScale;
			text.x = basePos.x - text.width/2 + _xoff;
			text.y = basePos.y - text.height + _yoff - FP.screen.height*(1-tweenScale);
			text.color = 0xFFFFFF;
			drawTextBold(text, null, 0);
			
			Text.size = 8;
			var texts:Vector.<Text> = new Vector.<Text>();
			for (var i:int = 0; i < menuText.length; i++)
			{
				texts.push(new Text(menuText[i]));
			}
			for (i = 0; i < menuText.length; i++)
			{
				texts[i].originX = texts[i].width;
				texts[i].x = basePos.x - texts[i].width - margin/2 * tweenScale + _xoff;
				texts[i].y = (i-1 >= 0 ? texts[i-1].y + texts[i].height : basePos.y + _yoff + FP.screen.height * (1 - tweenScale));
				texts[i].alpha = texts[i].scaleX = tweenScale;
				texts[i].color = 0x88FF44;
				drawTextBold(texts[i], null, 0x002200);
				menuMaxWidth["controls"]["left"] = Math.max(texts[i].width, menuMaxWidth["controls"]["left"]);
			}
			for (i = 0; i < menuTextAppend.length; i++)
			{
				text = new Text(menuTextAppend[i]);
				text.x = basePos.x + margin/2 * tweenScale + _xoff;
				text.y = texts[i].y;
				text.alpha = text.scaleX = tweenScale;
				text.color = 0x8844FF;
				drawTextBold(text, null, 0x000022); 
				menuMaxWidth["controls"]["right"] = Math.max(text.width, menuMaxWidth["controls"]["right"]);
			}
			menuMaxWidth["controls"]["left"] = menuMaxWidth["controls"]["right"] = Math.max(menuMaxWidth["controls"]["left"], menuMaxWidth["controls"]["right"]);
			Text.size = 16;
		}
		
		private function renderMenu(_xoff:int, _yoff:int):void
		{
			const offset:int = 4;
			var renderPt:Point = new Point(FP.screen.width / 2 + _xoff, FP.screen.height / 4 + _yoff);
			sprLogo.alpha = menuAlphaDivisor == 0 ? 1 : Math.max(1 - Math.abs(_xoff) / menuAlphaDivisor, 0);
			sprLogo.y += offset;
			sprLogo.color = 0;
			sprLogo.render(renderPt.clone(), new Point);
			sprLogo.y -= offset;
			sprLogo.color = 0xFFFFFF;
			sprLogo.render(renderPt.clone(), new Point);
			
			Text.size = 8;
			var t:Text = new Text("press any key to play", 26, 46);
			t.alpha = sprLogo.alpha;
			t.color = 0;
			t.render(new Point(renderPt.x - sprLogo.originX, renderPt.y + 1 - sprLogo.originY), new Point);
			t.color = 0xFFFFFF;
			t.render(new Point(renderPt.x - sprLogo.originX, renderPt.y - sprLogo.originY), new Point);
			Text.size = 16;
			
			sprNG.alpha = sprLogo.alpha;
			sprNG.render(ngPos(_xoff, _yoff), new Point);
		}
		private function ngPos(_xoff:int, _yoff:int):Point
		{
			return new Point(FP.screen.width / 2 + _xoff, FP.screen.height + _yoff - sprNG.height / 2);
		}
		
		public static function health(hits:int, hitsMax:int):void
		{
			healthc = hitsMax - hits - 1;
			healths = hitsMax;
		}
		
		public static function drawHealth():void
		{
			if (menu)
				return;
			const cols:int = 2;
			for (var i:int = 0; i < healths; i++)
			{
				sprHealth.frame = int(i > healthc);
				sprHealth.render(new Point(FP.screen.width - sprHealth.width - int(i % cols) * (sprHealth.width-1), int(i/2) * (sprHealth.height-1)), new Point);
			}
		}
		
		public function canInventory():Boolean
		{
			var p:Player = nearestToPoint("Player", 0, 0) as Player;
			return inventory && !talking && p && p.receiveInput && !p.destroy;
		}
		
		public function bufferTransforms():void
		{
			if (underwater)
			{
				FP.buffer.colorTransform(FP.buffer.rect, new ColorTransform(1, 1, 2, 1, -128, -128, 0));
			}
			//Day/night system
			const quarterDay:Number = dayLength / 4;
			var currentLightAlpha:Number = 1;
			const nightAlpha:Number = 0.1;
			if (dayNight)
			{
				if (todaysTime < quarterDay) //Dawn
				{
					currentLightAlpha = (todaysTime / quarterDay) * (1-nightAlpha) + nightAlpha;
				}
				else if (todaysTime < quarterDay * 3) //Daytime
				{
					
				}
				else if (todaysTime < dayLength) //Twilight
				{
					currentLightAlpha = (1 - (todaysTime - quarterDay * 3) / quarterDay) * (1-nightAlpha) + nightAlpha;
				}
				else //Night
				{
					currentLightAlpha = nightAlpha;
				}
			}
			nightBmp.draw(solidBmp, null, new ColorTransform(1, 1, 1, solidBmpAlpha), BlendMode.HARDLIGHT);
			
			if (snowing)
			{
				snowBmp.fillRect(snowBmp.rect, 0);
				Draw.setTarget(snowBmp, new Point());
				sprBlizzard.scaleX = FP.screen.width / sprBlizzard.width;
				sprBlizzard.scaleY = FP.screen.height / sprBlizzard.height;
				blizzardOffset.x += blizzardRate.x;
				blizzardOffset.y += blizzardRate.y;
				blizzardOffset.x %= sprBlizzard.width;
				blizzardOffset.y %= sprBlizzard.height;
				sprBlizzard.alpha = snowAlpha;
				//sprBlizzard.color = FP.colorLerp(0x000000, 0xFFFFFF, currentLightAlpha);
				for (var i:int = 0; i < 2; i++)
				{
					for (var j:int = 0; j < 2; j++)
					{
						var xpos:Number = blizzardOffset.x - i * sprBlizzard.width + sprBlizzard.originX;
						var ypos:Number = blizzardOffset.y - j * sprBlizzard.height + sprBlizzard.originY;
						sprBlizzard.render(new Point(xpos, ypos), new Point());
						
						sprBlizzard.render(new Point(xpos, ypos - 24), new Point());
						sprBlizzard.render(new Point(xpos, ypos + 24), new Point());
						
						/*
						var xpos1:int = sprBlizzard.originX + sprBlizzard.width - blizzardOffset.x - i * sprBlizzard.width;
						var ypos1:int = sprBlizzard.originY + blizzardOffset.y - j * sprBlizzard.height;
						sprBlizzard.scaleX = -sprBlizzard.scaleX;
						sprBlizzard.render(new Point(xpos1, ypos1 - 24), new Point());
						sprBlizzard.scaleX = -sprBlizzard.scaleX;
						*/
					}
				}
				var p:Player = nearestToPoint("Player", 0, 0) as Player;
				if (p && Player.hasWand)
				{
					var blizzardCircleRadius:int = 64;
					sprLight.scaleX = blizzardCircleRadius / sprLight.width;
					sprLight.scaleY = blizzardCircleRadius / sprLight.height;
					sprLight.centerOO();
					sprLight.blend = BlendMode.DARKEN;
					const lightsToDraw:int = 10 * snowAlpha;
					for (i = 0; i < lightsToDraw; i++)
					{
						sprLight.render(new Point(p.x, p.y), FP.camera);
					}
				}
				FP.buffer.draw(snowBmp, null, null, BlendMode.ADD);
			}
			FP.buffer.draw(nightBmp, null, new ColorTransform(1, 1, 1, 1 - (currentLightAlpha * lightAlpha) * (1 - minDarkness) - Math.min(minDarkness, lightAlpha)), BlendMode.MULTIPLY);
			
			if (blackAndWhite)
			{
				bwBuffer.copyPixels(FP.buffer, bwBuffer.rect, new Point());
				var rc:Number = 0.3;
				var gc:Number = 0.59;
				var bc:Number = 0.11;
				bwBuffer.applyFilter(bwBuffer, bwBuffer.rect, new Point(), new ColorMatrixFilter([rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, 0, 0, 0, 1, 0]));
				FP.buffer.draw(bwBuffer, null, new ColorTransform(1, 1, 1, snowAlpha / DEFAULT_SNOW_ALPHA));
			}
			Draw.resetTarget();
		}
		
		public function averageColor(v:Vector.<Number>):int
		{
			var sum:int = 0;
			for (var i:int = 0; i < v.length; i++)
			{
				sum += v[i];
			}
			return sum /= v.length;
		}
		
		public function bufferRestore():void
		{
			nightBmp.fillRect(nightBmp.rect, 0xFF080822);
			solidBmp.fillRect(solidBmp.rect, 0x00000000);
		}
		
		public function drawCover(c:uint = 0x000000, a:Number = 1):void
		{
			newCoverColor = c;
			newCoverAlpha = a;
			newCoverDraw = true;
		}
		public function undrawCover():void
		{
			newCoverColor = 0x000000;
			newCoverAlpha = 0;
			newCoverDraw = false;
		}
		
		public function talk():void
		{
			if (talking && talkingText)
			{
				const n:int = 6;
				Draw.rect(FP.camera.x, FP.camera.y, FP.screen.width, FP.screen.height / n, speakingColor, speakingAlpha);
				Draw.rect(FP.camera.x, FP.camera.y + FP.screen.height * (n - 1) / n, FP.screen.width, FP.screen.height / n + 1, speakingColor, speakingAlpha);
				const minM:int = 4; //The margin between the image border and the text area
				const textToImageMargin:int = 8; //The distance between the text and the image
				var d:int = FP.screen.height / n;
				Text.size = 8;
				
				//Scrolling text
				if (framesThisCharacter > 0)
				{
					framesThisCharacter--;
				}
				else
				{
					framesThisCharacter = framesPerCharacter;
					currentCharacter++;
					
					const soundBufferCharacters:int = 3; //The number of characters before the end of the phrase where it stops restarting the sound.
					
					if (currentCharacter > talkingText.length)
					{
						if (textTimer > 0)
						{
							textTimer--;
						}
						else
						{
							if (proceedText)
							{
								cTextIndex++;
							}
							textTimer = textTime;
						}
					}
					else if(currentCharacter <= talkingText.length - soundBufferCharacters)
					{
						if (!Music.soundIsPlaying("Text", 0))
							Music.playSound("Text", 0);
					}
				}
				var fullString:String;
				fullString = talkingText.substr(0, currentCharacter);
				
				var t:Text = new Text(fullString);
				if (talkingPic)
				{
					var m:int = (d - talkingPic.height * talkingPic.scale) / 2;
					Draw.rect(FP.camera.x + minM, FP.camera.y + FP.screen.height * (n - 1) / n + minM, m * 2 + talkingPic.width - minM * 2, m * 2 + talkingPic.height - minM * 2, 0xFFFFFF, 1);
					talkingPic.render(new Point(m, FP.screen.height * (n - 1) / n + m), new Point());
				}
				var w:int = textToImageMargin; //The distance of the text to the left edge.
				if (talkingPic)
				{
					w += m + talkingPic.width * talkingPic.scale;
				}
				var alignOffsetX:int = 0;
				switch(ALIGN)
				{
					case "LEFT":
						break;
					case "CENTER":
							alignOffsetX = (FP.screen.width - w - t.width) / 2;
						break;
					case "RIGHT":
							alignOffsetX = (FP.screen.width - w) - t.width;
						break;
					default:
				}
				t.render(new Point(w + alignOffsetX, FP.screen.height * (n - 1 / 2) / n - t.height / 2 + 1), new Point());
				if (currentCharacter > talkingText.length && !cutscene[0])
				{
					var text:Text = new Text("<X>");
					var pt:Point = new Point(FP.screen.width - text.width, FP.screen.height - d - text.height / 2);
					drawTextBold(text, pt);
				}
			}
		}
		
		public static function drawTextBold(t:Text, p:Point, c:uint=0, camera:Point=null):void
		{
			var _c:uint = t.color;
			t.color = c;
			if (!camera)
				camera = new Point;
			if (!p)
				p = new Point;
			t.render(new Point(p.x-1, p.y), camera);
			t.render(new Point(p.x+1, p.y), camera);
			t.render(new Point(p.x, p.y-1), camera);
			t.render(new Point(p.x, p.y + 1), camera);
			t.color = _c;
			t.render(p.clone(), camera);
		}
		
		public static function set talkingText(s:String):void 
		{
			if (_talkingText != s)
			{
				currentCharacter = 0;
			}
			_talkingText = s;
		}
		public static function get talkingText():String
		{
			return _talkingText;
		}
		
		public function cover():void
		{
			if (drawBlackCover)
			{
				if (blackCover > 0)
				{
					Draw.rect(FP.camera.x, FP.camera.y, FP.screen.width, FP.screen.height, 0x000000, blackCover);
				}
			}
			if (blackCoverRate > 0 && blackCover < 1)
			{
				blackCover = Math.min(blackCover + blackCoverRate, 1);
			}
			else if (blackCoverRate < 0 && blackCover > 0)
			{
				blackCover = Math.max(blackCover + blackCoverRate, 0);
			}
		}
		
		public function totalEnemies():int
		{
			//return typeCount("Enemy") + typeCount("ShieldBoss");
			return classCount(Bob) + 
				   classCount(BobSoldier) + 
				   classCount(BobBoss) + 
				   classCount(Flyer) + 
				   classCount(Jellyfish) +
				   classCount(Cactus) +
				   classCount(SandTrap) +
				   classCount(ShieldBoss) +
				   classCount(Spinner) +
				   classCount(WallFlyer) + 
				   classCount(Puncher) + 
				   classCount(Drill) + 
				   classCount(Turret) + 
				   classCount(IceTurret) +
				   classCount(BossTotem) + 
				   classCount(Tentacle) + 
				   classCount(TentacleBeast) + 
				   classCount(Grenade) + 
				   classCount(DarkTrap) + 
				   classCount(LightBoss) + 
				   classCount(LavaRunner) + 
				   classCount(Bulb) + 
				   classCount(Squishle) + 
				   classCount(FinalBoss) + 
				   classCount(Enemy);
		}
		
		public static function checkPersistence(tag:int, _l:int=-1):Boolean
		{
			return Main.levelPersistence(_l >= 0 ? _l : Main.level, tag);
		}
		
		public static function setPersistence(tag:int, o:Boolean, _l:int=-1):void
		{
			Main.levelPersistenceSet(_l >= 0 ? _l : Main.level, tag, o);
		}
		
		public static function worldFrame(n:int, loops:Number=1):int //n is the number of values to return (1..n) and loops is the number of animation loops to go over.
		{
			return int((time % (timePerFrame * loops)) / (timePerFrame * loops / Math.max(n, 1)));
		}
		
		public function view():void
		{
			var player:Player = nearestToPoint("Player", FP.camera.x + FP.width / 2, FP.camera.y + FP.height / 2) as Player;
			var targetPosition:Point = new Point;
			if (player)
			{
				targetPosition = new Point(player.x - FP.screen.width / 2, player.y - FP.screen.height / 2);
				//Inventory offsetting
				targetPosition.x -=  Inventory.width / 2 + Inventory.offset.x / 2;
			}
			
			if (cameraTarget.x != -1 || cameraTarget.y != -1)
			{
				targetPosition = cameraTarget.clone();
			}
			FP.camera.x += (targetPosition.x - FP.camera.x) / cameraSpeedDivisor;
			FP.camera.y += (targetPosition.y - FP.camera.y) / cameraSpeedDivisor;
			
			if (FP.width < FP.screen.width)
			{
				FP.camera.x = -(FP.screen.width - FP.width) / 2;
			}
			else
			{
				FP.camera.x = Math.min(Math.max(FP.camera.x, 0), FP.width - FP.screen.width);
			}
			if (FP.height < FP.screen.height)
			{
				FP.camera.y = -(FP.screen.height - FP.height) / 2;
			}
			else
			{
				FP.camera.y = Math.min(Math.max(FP.camera.y, 0), FP.height - FP.screen.height);
			}
			
			if (shake > 0)
			{
				FP.camera.x += shake * Math.random() - shake / 2;
				FP.camera.y += shake * Math.random() - shake / 2;
				shake = Math.max(shake - 1, 0);
			}
			
			FP.camera.x = Math.round(FP.camera.x);
			FP.camera.y = Math.round(FP.camera.y);
		}
		
		public static function set cameraTarget(_c:Point):void
		{
			_cameraTarget = _c;
		}
		public static function get cameraTarget():Point
		{
			return _cameraTarget;
		}
		public static function resetCamera():void
		{
			cameraTarget = new Point( -1, -1);
		}
		
		public function restartLevel():void
		{
			FP.world = new Game(level, playerPosition.x, playerPosition.y);
		}
		
		public function loadlevel(_level:Class):void 
		{
			var file:ByteArray = new _level;
			var str:String = file.readUTFBytes( file.length );
			var xml:XML = new XML(str);
			
			var e:Entity;
			var o:XML;
			var n:XML;
			
			FP.width = xml.width;
			FP.height = xml.height;
			
			var w:int = xml.width;
			var h:int = xml.height;
			
			lightAlpha = 1;
			dayNight = false;
			snowing = false;
			blackAndWhite = false;
			raining = false;
			blurRegion = false;
			blurRegion2 = false;
			
			if (xml.hasOwnProperty("objects"))
			{
				if(xml.objects[0].hasOwnProperty("lightalpha"))
				{
					lightAlpha = minLightAlpha + Number(xml.objects[0].lightalpha.@alpha);
				}
				if (xml.objects[0].hasOwnProperty("daynight"))
				{
					dayNight = true;
				}
				if (xml.objects[0].hasOwnProperty("snow"))
				{
					snowing = true;
					blackAndWhite = true;
				}
				if (xml.objects[0].hasOwnProperty("blur"))
				{
					blurRegion = true;
				}
				if (xml.objects[0].hasOwnProperty("blur2"))
				{
					blurRegion2 = true;
				}
			}
			
			var tile:Tile;
			tiles = new Vector.<Vector.<Tile>>();
			for (var i:int = 0; i < FP.width / Tile.w; i++)
			{
				tiles.push(new Vector.<Tile>());
				for (var j:int = 0; j < FP.height / Tile.h; j++)
				{
					tiles[i].push(null);
				}
			}
			if (xml.hasOwnProperty("tiles"))
			{
				for each (o in xml.tiles[0].tile) 
				{
					if (Math.floor(o.@x / Tile.w) < tiles.length && Math.floor(o.@y / Tile.h) < tiles[0].length)
					{
						switch(Math.floor(o.@tx / Tile.w))
						{
							case 0:
								add(tile = new Tile(o.@x, o.@y, 0, false)); break;
							case 1:
								add(tile = new Tile(o.@x, o.@y, 0)); break;
							case 2:
								add(tile = new Tile(o.@x, o.@y, 1)); break;
							case 3:
								add(tile = new Tile(o.@x, o.@y, 2)); break;
							case 4:
								add(tile = new Tile(o.@x, o.@y, 3)); break;
							case 5:
								add(tile = new Tile(o.@x, o.@y, 4)); break;
							case 6:
								add(tile = new Tile(o.@x, o.@y, 5)); break;
							case 7:
								add(tile = new Tile(o.@x, o.@y, 6)); break;
							case 8:
								add(tile = new Tile(o.@x, o.@y, 7)); break;
							case 9:
								add(tile = new Tile(o.@x, o.@y, 8, false)); break;
							case 10:
								add(tile = new Tile(o.@x, o.@y, 8)); break;
							case 11:
								add(tile = new Tile(o.@x, o.@y, 9)); break;
							case 12:
								add(tile = new Tile(o.@x, o.@y, 10)); break;
							case 13:
								add(tile = new Tile(o.@x, o.@y, 11)); break;
							case 14:
								add(tile = new Tile(o.@x, o.@y, 12)); break;
							case 15:
								add(tile = new Tile(o.@x, o.@y, 13)); break;
							case 16:
								add(tile = new Tile(o.@x, o.@y, 14)); break;
							case 17:
								add(tile = new Tile(o.@x, o.@y, 15)); break;
							case 18:
								add(tile = new Tile(o.@x, o.@y, 16)); break;
							case 19:
								add(tile = new Tile(o.@x, o.@y, 17)); break;
							case 20:
								add(tile = new Tile(o.@x, o.@y, 18)); break;
							case 21:
								add(tile = new Tile(o.@x, o.@y, 19)); break;
							case 22:
								add(tile = new Tile(o.@x, o.@y, 20)); break;
							case 23:
								add(tile = new Tile(o.@x, o.@y, 21)); break;
							case 24:
								add(tile = new Tile(o.@x, o.@y, 22)); break;
							case 25:
								add(tile = new Tile(o.@x, o.@y, 23)); break;
							case 26:
								add(tile = new Tile(o.@x, o.@y, 24)); break;
							case 27:
								add(tile = new Tile(o.@x, o.@y, 25, false, null, false, true, false)); break;
							case 28:
								add(tile = new Tile(o.@x, o.@y, 25, false, null, false, false, false)); break;
							case 29:
								add(tile = new Tile(o.@x, o.@y, 25, false, null, true, false, false)); break;
							case 30:
								add(tile = new Tile(o.@x, o.@y, 25, false, null, true, true, false)); break;
							case 31:
								add(tile = new Tile(o.@x, o.@y, 25, false, null, false, true, true)); break;
							case 32:
								add(tile = new Tile(o.@x, o.@y, 25, false, null, false, false, true)); break;
							case 33:
								add(tile = new Tile(o.@x, o.@y, 26)); break;
							case 34:
								add(tile = new Tile(o.@x, o.@y, 27)); break;
							case 35:
								add(tile = new Tile(o.@x, o.@y, 28)); break;
							case 36:
								add(tile = new Tile(o.@x, o.@y, 29)); break;
							case 37:
								add(tile = new Tile(o.@x, o.@y, 30)); break;
							case 38:
								add(tile = new Tile(o.@x, o.@y, 31)); break;
							case 39:
								add(tile = new Tile(o.@x, o.@y, 32)); break;
							case 40:
								add(tile = new Tile(o.@x, o.@y, 33)); break;
							case 41:
								add(tile = new Tile(o.@x, o.@y, 34)); break;
							case 42:
								add(tile = new Tile(o.@x, o.@y, 35)); break;
							case 43:
								add(tile = new Tile(o.@x, o.@y, 36)); break;
							case 44:
								add(tile = new Tile(o.@x, o.@y, 37)); break;
							default:
								tile = null;
						}
						tiles[Math.floor(o.@x / Tile.w)][Math.floor(o.@y / Tile.h)] = tile;
					}
				}
			}
			if (xml.hasOwnProperty("cliffsides"))
			{
				for each (o in xml.cliffsides[0].tile) 
				{
					add(new CliffSide(o.@x, o.@y, Math.floor(o.@tx / Tile.w)));
				}
			}
			
			if (!menu)
			{
				var v:Vector.<Entity> = new Vector.<Entity>();
				getClass(Player, v);
				if (v.length > 0)
				{
					for each(var p:Player in v)
					{
						p.x = playerPosition.x;
						p.y = playerPosition.y;
						p.fallFromCeiling = setFallFromCeiling;
					}
				}
				else
				{
					if (xml.hasOwnProperty("objects"))
					{
						for each (o in xml.objects[0].player) 
						{ 
							playerPosition = new Point(o.@x, o.@y); 
						}
					}
					var player:Player;
					add(player = new Player(playerPosition.x, playerPosition.y));
					FP.camera.x = player.x - FP.screen.width / 2;
					FP.camera.y = player.y - FP.screen.height / 2;
					player.fallFromCeiling = setFallFromCeiling;
				}
			}
			if (xml.hasOwnProperty("objects"))
			{
				for each (o in xml.objects[0].control) //Used to be above the player block, so check if it will cause issues.
				{ 
					fallthroughLevel = o.@fallthrough;
					fallthroughOffset = new Point(o.@x, o.@y);
					var tempOffset:Point = new Point(o.@xOff, o.@yOff);
					fallthroughOffset = new Point(fallthroughOffset.x + tempOffset.x, fallthroughOffset.y + tempOffset.y);
					fallthroughSign = int(o.@sign) - 1;
				}
				for each(o in xml.objects[0].droplet)
				{
					raining = true;
					rainingHeaviness = o.@heaviness;
					rainingRect = new Rectangle(o.@x, o.@y, o.@width, o.@height);
					rainingRect.width = rainingRect.width != -1 ? rainingRect.width : FP.width;
					rainingRect.height = rainingRect.height != -1 ? rainingRect.height : FP.height;
					rainingHeight = o.@startheight;
					rainingColor = o.@color;
				}
				for each (o in xml.objects[0].bob) { add(new Bob(o.@x, o.@y)); }
				for each (o in xml.objects[0].bobsoldier) { add(new BobSoldier(o.@x, o.@y)); }
				for each (o in xml.objects[0].bobboss1) { add(new BobBoss(o.@x, o.@y, 0)); }
				for each (o in xml.objects[0].bobboss2) { add(new BobBoss(o.@x, o.@y, 1)); }
				for each (o in xml.objects[0].bobboss3) { add(new BobBoss(o.@x, o.@y, 2)); }
				for each (o in xml.objects[0].bosstotem) { add(new BossTotem(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].lightbosscontroller) { add(new LightBossController(o.@x, o.@y, o.@fliernum, o.@tag)); }
				for each (o in xml.objects[0].lavaboss) { add(new LavaBoss(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].finalboss) { add(new FinalBoss(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].flyer) { add(new Flyer(o.@x, o.@y)); }
				for each (o in xml.objects[0].jellyfish) { add(new Jellyfish(o.@x, o.@y)); }
				for each (o in xml.objects[0].lavarunner) { add(new LavaRunner(o.@x, o.@y)); }
				for each (o in xml.objects[0].bulb) { add(new Bulb(o.@x, o.@y)); }
				for each (o in xml.objects[0].tentaclebeast) { add(new TentacleBeast(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].drill) { add(new Drill(o.@x, o.@y)); }
				for each (o in xml.objects[0].sandtrap) { add(new SandTrap(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].icetrap) { add(new IceTrap(o.@x, o.@y)); }
				for each (o in xml.objects[0].lavatrap) { add(new LavaTrap(o.@x, o.@y)); }
				for each (o in xml.objects[0].darktrap) { add(new DarkTrap(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].turret) { add(new Turret(o.@x, o.@y)); }
				for each (o in xml.objects[0].iceturret) { add(new IceTurret(o.@x, o.@y)); }
				for each (o in xml.objects[0].beamtower) { add(new BeamTower(o.@x, o.@y, o.@direction, o.@rate, o.@speed)); }
				for each (o in xml.objects[0].grenade) { add(new Grenade(o.@x, o.@y)); }
				for each (o in xml.objects[0].bombpusher) { add(new BombPusher(o.@x, o.@y)); }
				for each (o in xml.objects[0].crusher) { add(new Crusher(o.@x, o.@y, o.@tset)); }
				for each (o in xml.objects[0].puncher) { add(new Puncher(o.@x, o.@y)); }
				for each (o in xml.objects[0].treelarge) { add(new TreeLarge(o.@x, o.@y)); }
				for each (o in xml.objects[0].tree) { add(new Tree(o.@x, o.@y)); }
				for each (o in xml.objects[0].treebare) { add(new Tree(o.@x, o.@y, true)); }
				for each (o in xml.objects[0].burnabletree) { add(new BurnableTree(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].opentree) { add(new OpenTree(o.@x, o.@y)); }
				for each (o in xml.objects[0].snowhill) { add(new SnowHill(o.@x, o.@y)); }
				for each (o in xml.objects[0].building) { add(new Building(o.@x, o.@y, 0)); }
				for each (o in xml.objects[0].building1) { add(new Building(o.@x, o.@y, 1)); }
				for each (o in xml.objects[0].building2) { add(new Building(o.@x, o.@y, 2)); }
				for each (o in xml.objects[0].building3) { add(new Building(o.@x, o.@y, 3)); }
				for each (o in xml.objects[0].building4) { add(new Building(o.@x, o.@y, 4)); }
				for each (o in xml.objects[0].building5) { add(new Building(o.@x, o.@y, 5)); }
				for each (o in xml.objects[0].building6) { add(new Building(o.@x, o.@y, 6)); }
				for each (o in xml.objects[0].building7) { add(new Building(o.@x, o.@y, 7)); }
				for each (o in xml.objects[0].building8) { add(new Building(o.@x, o.@y, 8)); }
				for each (o in xml.objects[0].wire) { add(new Wire(o.@x, o.@y, o.@img)); }
				for each (o in xml.objects[0].bed)  { add(new Bed(o.@x, o.@y)); }
				for each (o in xml.objects[0].dresser)  { add(new Dresser(o.@x, o.@y)); }
				for each (o in xml.objects[0].bar)  { add(new Bar(o.@x, o.@y)); }
				for each (o in xml.objects[0].barstool)  { add(new Barstool(o.@x, o.@y)); }
				for each (o in xml.objects[0].rock)  { add(new Rock(o.@x, o.@y, 0)); }
				for each (o in xml.objects[0].rock2) { add(new Rock(o.@x, o.@y, 1)); }
				for each (o in xml.objects[0].rock3) { add(new Rock(o.@x, o.@y, 2)); }
				for each (o in xml.objects[0].rock4) { add(new Rock(o.@x, o.@y, 3)); }
				for each (o in xml.objects[0].pole) { add(new Pole(o.@x, o.@y)); }
				for each (o in xml.objects[0].sword) { add(new Sword(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].feather) { add(new Feather(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].ghostspear) { add(new GhostSpear(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].ghostsword) { add(new GhostSword(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].darkshield) { add(new DarkShield(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].darksuit) { add(new DarkSuit(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].conch) { add(new Conch(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].shield) { add(new Shield(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].torchpickup) { add(new TorchPickup(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].fire) { add(new Fire(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].button) { add(new Button(o.@x, o.@y, o.@tset)); }
				for each (o in xml.objects[0].buttonroom) { add(new ButtonRoom(o.@x, o.@y, o.@tset, o.@tag, Boolean(int(o.@flip)), o.@room)); }
				for each (o in xml.objects[0].arrowtrap) { add(new ArrowTrap(o.@x, o.@y, o.@tset, Boolean(int(o.@shoot)))); }
				for each (o in xml.objects[0].bosskey) { add(new BossKey(o.@x, o.@y, o.@keyType)); }
				for each (o in xml.objects[0].totempart) { add(new BossTotemPart(o.@x, o.@y, o.@totempart)); }
				for each (o in xml.objects[0].health) { add(new HealthPickup(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].seed) { add(new Seed(o.@x, o.@y, false, o.@text, cutscene[2])); }
				for each (o in xml.objects[0].pull) { add(new Pull(o.@x, o.@y, o.@direction, o.@force)); } //o.@direction goes from 0-1
				for each (o in xml.objects[0].fallrock)  { add(new FallRock(o.@x, o.@y, o.@tset, o.@tag)); }
				for each (o in xml.objects[0].fallrocklarge)  { add(new FallRockLarge(o.@x, o.@y, o.@tset, o.@tag, Boolean(int(o.@bossrock)), Boolean(int(o.@thirdboss)))); }
				for each (o in xml.objects[0].rocklock) { add(new RockLock(o.@x, o.@y, o.@tset, o.@tag)); }
				for each (o in xml.objects[0].lock) { add(new Lock(o.@x, o.@y, o.@tset, o.@tag)); }
				for each (o in xml.objects[0].pulser) { add(new Pulser(o.@x, o.@y, o.@tset)); }
				for each (o in xml.objects[0].spinningaxe) { add(new SpinningAxe(o.@x, o.@y, o.@rate, o.@colortype)); }
				for each (o in xml.objects[0].lavachain) { add(new LavaChain(o.@x, o.@y, o.@dir)); }
				for each (o in xml.objects[0].cover) { add(new Cover(o.@x, o.@y, o.@tset)); }
				for each (o in xml.objects[0].grasslock) { add(new GrassLock(o.@x, o.@y, o.@tset, o.@tag)); }
				for each (o in xml.objects[0].shieldlocknorm) { add(new ShieldLock(o.@x, o.@y, o.@tag, 0)); }
				for each (o in xml.objects[0].shieldlock) { add(new ShieldLock(o.@x, o.@y, o.@tag, 1)); }
				for each (o in xml.objects[0].wandlock) { add(new WandLock(o.@x, o.@y, o.@tset, o.@tag)); }
				for each (o in xml.objects[0].bosslock) { add(new BossLock(o.@x, o.@y, o.@keyType, o.@tag)); }
				for each (o in xml.objects[0].magicallock) { add(new MagicalLock(o.@x, o.@y, o.@tag, 0)); }
				for each (o in xml.objects[0].magicallockfire) { add(new MagicalLock(o.@x, o.@y, o.@tag, 1)); }
				for each (o in xml.objects[0].moonrock) { add(new Moonrock(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].torch) { add(new Torch(o.@x, o.@y, o.@c)); }
				for each (o in xml.objects[0].bonetorch) { add(new BoneTorch(o.@x, o.@y, 0, o.@c, Boolean(int(o.@flip)))); }
				for each (o in xml.objects[0].bonetorch2) { add(new BoneTorch(o.@x, o.@y, 1, o.@c, Boolean(int(o.@flip)))); }
				for each (o in xml.objects[0].planttorch) { add(new PlantTorch(o.@x, o.@y, o.@c, Boolean(int(o.@flip)), o.@distance)); }
				for each (o in xml.objects[0].lightpole) { add(new LightPole(o.@x, o.@y, o.@tset, o.@tag, o.@c, Boolean(int(o.@invert)))); }
				for each (o in xml.objects[0].orb) { add(new Orb(o.@x, o.@y, o.@c)); }
				for each (o in xml.objects[0].breakablerock) { add(new BreakableRock(o.@x, o.@y, o.@tag, 0)); }
				for each (o in xml.objects[0].breakablerockghost) { add(new BreakableRock(o.@x, o.@y, o.@tag, 1)); }
				for each (o in xml.objects[0].chest) { add(new Chest(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].dungeonspire) { add(new DungeonSpire(o.@x, o.@y)); }
				for each (o in xml.objects[0].lightbosstotem) { add(new LightBossTotem(o.@x, o.@y)); }
				for each (o in xml.objects[0].littlestones) { add(new LittleStones(o.@x, o.@y)); }
				for each (o in xml.objects[0].whirlpool) { add(new Whirlpool(o.@x, o.@y)); }
				for each (o in xml.objects[0].pushableblock) { add(new PushableBlock(o.@x, o.@y)); }
				for each (o in xml.objects[0].pushableblockfire) { add(new PushableBlockFire(o.@x, o.@y)); }
				for each (o in xml.objects[0].pushableblockspear) { add(new PushableBlockSpear(o.@x, o.@y)); }
				for each (o in xml.objects[0].stairsup) { add(new Stairs(o.@x, o.@y, true, Boolean(int(o.@flip)), o.@to, o.@playerx, o.@playery, o.@sign)); }
				for each (o in xml.objects[0].stairsdown) { add(new Stairs(o.@x, o.@y, false, Boolean(int(o.@flip)), o.@to, o.@playerx, o.@playery, o.@sign)); }
				for each (o in xml.objects[0].teleporter) { add(new Teleporter(o.@x, o.@y, o.@to, o.@playerx, o.@playery, Boolean(int(o.@show)), String(o.@tag) == "" ? -1 : o.@tag, Boolean(int(o.@invert)), o.@sign)); }
				for each (o in xml.objects[0].shieldboss) { add(new ShieldBoss(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].introchar) { add(new IntroCharacter(o.@x, o.@y, o.@tag, o.@text, o.@frames)); }
				for each (o in xml.objects[0].rekcahdam) { add(new Rekcahdam(o.@x, o.@y, o.@tag, o.@text, o.@frames)); }
				for each (o in xml.objects[0].forestchar) { add(new ForestCharacter(o.@x, o.@y, o.@tag, o.@text, o.@frames)); }
				for each (o in xml.objects[0].karlore) { add(new Karlore(o.@x, o.@y, o.@tag, o.@text, o.@frames)); }
				for each (o in xml.objects[0].adnanchar) { add(new AdnanCharacter(o.@x, o.@y, o.@tag, o.@text, o.@frames)); }
				for each (o in xml.objects[0].watcher) { add(new Watcher(o.@x, o.@y, o.@tag, o.@text, o.@text1, o.@frames)); }
				for each (o in xml.objects[0].oracle) { add(new Oracle(o.@x, o.@y, o.@tag, o.@text, o.@text1, o.@frames)); }
				for each (o in xml.objects[0].witch) { add(new Witch(o.@x, o.@y, o.@tag, o.@text, o.@frames)); }
				for each (o in xml.objects[0].hermit) { add(new Hermit(o.@x, o.@y, o.@tag, o.@text, o.@frames)); }
				for each (o in xml.objects[0].yeti) { add(new Yeti(o.@x, o.@y, o.@tag, o.@text, o.@frames)); }
				for each (o in xml.objects[0].sensei) { add(new Sensei(o.@x, o.@y, o.@tag, o.@text, o.@frames)); }
				for each (o in xml.objects[0].sign) { add(new Sign(o.@x, o.@y, o.@tag, o.@text, o.@frames)); }
				for each (o in xml.objects[0].totem) { add(new Totem(o.@x, o.@y, o.@tag, o.@text, o.@frames)); }
				for each (o in xml.objects[0].wand) { add(new Wand(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].firewand) { add(new FireWand(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].brickpole) { add(new BrickPole(o.@x, o.@y)); }
				for each (o in xml.objects[0].statue1) { add(new Statue(o.@x, o.@y, 0, o.@text, o.@frames)); }
				for each (o in xml.objects[0].statue2) { add(new Statue(o.@x, o.@y, 1, o.@text, o.@frames)); }
				for each (o in xml.objects[0].brickwell) { add(new BrickWell(o.@x, o.@y)); }
				for each (o in xml.objects[0].finaldoor) { add(new FinalDoor(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].pod) { add(new Pod(o.@x, o.@y)); }
				for each (o in xml.objects[0].frozenboss) { add(new FrozenBoss(o.@x, o.@y)); }
				for each (o in xml.objects[0].moonrockpile) { add(new MoonrockPile(o.@x, o.@y)); }
				for each (o in xml.objects[0].shieldstatue) { add(new ShieldStatue(o.@x, o.@y)); }
				for each (o in xml.objects[0].oraclestatue) { add(new OracleStatue(o.@x, o.@y)); }
				for each (o in xml.objects[0].ruinedpillar) { add(new RuinedPillar(o.@x, o.@y)); }
				for each (o in xml.objects[0].wallflyer) { add(new WallFlyer(o.@x, o.@y)); }
				for each (o in xml.objects[0].spinner) { add(new Spinner(o.@x, o.@y, o.@tag)); }
				for each (o in xml.objects[0].lightray) { add(new LightRay(o.@x, o.@y, o.@color, o.@alpha, o.@width, o.@height)); }
				for each (o in xml.objects[0].shadow) { add(new Shadow(o.@x, o.@y, o.@color, o.@alpha, o.@width, o.@height)); }
				for each (o in xml.objects[0].rope) 
				{ 
					var pt:Point;
					//get the end point of the electricity (via nodes)
					for each (n in o.node)
					{
						pt = new Point(n.@x, n.@y);
					}
					add(new RopeStart(o.@x, o.@y, pt.x, o.@tset, o.@tag)); 
				}
			}
			setFallFromCeiling = false;
		}
		
	}

}