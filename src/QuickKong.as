package
{
	/**
	 * QuickKong by UnknownGuardian. August 26th 2011.
	 * Visit http://profusiongames.com/ and http://github.com/UnknownGuardian
	 *
	 * Copyright (c) 2010 ProfusionGames
	 *    All rights reserved.
	 *
	 * Permission is hereby granted, free of charge, to any person
	 * obtaining a copy of this software and associated documentation
	 * files (the "Software"), to deal in the Software without
	 * restriction, including without limitation the rights to use,
	 * copy, modify, merge, publish, distribute, sublicense, and/or sell
	 * copies of the Software, and to permit persons to whom the
	 * Software is furnished to do so, subject to the following
	 * conditions:
	 *
	 * ^ Attribution will be given to:
	 *  	UnknownGuardian http://www.kongregate.com/accounts/UnknownGuardian
	 *
	 * ^ Redistributions of source code must retain the above copyright notice,
	 * this list of conditions and the following disclaimer in all copies or
	 * substantial portions of the Software.
	 *
	 * ^ Redistributions of source code may not add to, subtract from, or in
	 * any other way modify the above copyright notice, this list of conditions,
	 * or the following disclaimer for any reason.
	 *
	 * ^ Redistributions in binary form must reproduce the above copyright
	 * notice, this list of conditions and the following disclaimer in the
	 * documentation and/or other materials provided with the distribution.
	 *
	 * THE SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
	 * IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
	 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
	 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
	 * OR COPYRIGHT HOLDERS OR CONTRIBUTORS  BE LIABLE FOR ANY CLAIM, DIRECT,
	 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
	 * OR OTHER LIABILITY,(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
	 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
	 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
	 * WHETHER AN ACTION OF IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
	 * NEGLIGENCE OR OTHERWISE) ARISING FROM, OUT OF, IN CONNECTION OR
	 * IN ANY OTHER WAY OUT OF THE USE OF OR OTHER DEALINGS WITH THIS
	 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * English: Use, distribute, etc to this with keeping credits and copyright
	 */
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.system.Security;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class QuickKong
	{		
		public static var api:* = null;
		
		public static var chat:* = null;
		public static var services:* = null;
		public static var stats:* = null;
		public static var mtx:* = null;
		public static var sharedContent:* = null;
		public static var images:* = null;
		
		public static var userName:String = "";
		public static var userId:String = "";
		public static var userToken:String = "";
		public static var isGuest:Boolean = false;

		private static var connectCallback:Function = null;
		
		public static var LOADED:Boolean = false;
		
		public function QuickKong()
		{
			throw new Error("[QuickKong] Error: Do not create an instance of this class, as it contains all static functions");				
		}
		
		/**
		 * connectToKong
		 * @description		Connects to Kongregate
		 * @param			s: The stage that the Kongregate API loader will be added too.
		 * @param			preConnectCallback: Optional param. Useful for Shared Content API.
		 */
		public static function connectToKong(s:Stage, preConnectCallback:Function=null):void
		{		
			trace("[QuickKong] connectToKong()");

			connectCallback = preConnectCallback;
			//grab the loaderinfo param
			var paramObj:Object = LoaderInfo(s.root.loaderInfo).parameters;
			
			// The API path. The "shadow" API will load if testing locally.
			var apiPath:String = paramObj.kongregate_api_path || "http://www.kongregate.com/flash/API_AS3_Local.swf";
			
			// Allow the API access to this SWF
			Security.allowDomain(apiPath);
			
			// Load the API
			var request:URLRequest = new URLRequest(apiPath);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, QuickKong.loadedAPI);
			loader.load(request);
			s.addChild(loader);
		}
		
		/**
		 * loadedAPI
		 * @description		Handles the loaded API, and extracts it
		 * @param			e: Event on load Completion
		 */
		private static function loadedAPI(e:Event):void
		{
			trace("[QuickKong] loadedAPI()");
			e.currentTarget.removeEventListener(Event.COMPLETE, QuickKong.loadedAPI);
			api = e.target.content;
			
			//preconnect callback. Use this for Shared Content API.
			if(connectCallback != null)
				connectCallback();
			
			//connect to Kongregate's API
			api.services.connect();
			
			chat = api.chat;
			services = api.services;
			stats = api.stats;
			mtx = api.mtx;
			sharedContent =  api.sharedContent;
			try	{ images = api.images; } catch (e:Error) { } //local cannot load images API
			
			//extract basic data.
			isGuest = services.isGuest();
			userName = services.getUsername();
			try	{ userId = services.getUserId(); } catch (e:Error) { } //local cannot load user id
			userToken = services.getGameAuthToken();
			
			trace("[QuickKong] Kong API Successfully loaded and extracted. Shadow Services alert should appear for local testing");
			
			LOADED = true;
		}
	}
}