package com.duff.net {
	
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	
	import com.duff.signals.XMLFromServerSignals;

	
	/**
	 * @author borella
	 * TODO TRY RELOAD
	 */
	
	public class XmlFromServer
	{
		// ___________________________________________________________________ VARS
		
		private static var _instance:XmlFromServer;
		private var _url:String = "";
		private var _urlLoader:URLLoader;
		private var _request:URLRequest;
		
		// ___________________________________________________________________ CONSTRUCTOR
		
		public function XmlFromServer(singleton:SingletonObligate){}
		
		// ___________________________________________________________________ PUBLIC METHODS
		
		public static function getInstance ():XmlFromServer
		{
			if (!XmlFromServer._instance) XmlFromServer._instance = new XmlFromServer(new SingletonObligate());
			return XmlFromServer(XmlFromServer._instance);
		}
		
		public function get(url:String, vars:Object=null):void
		{	
			_url = url;
			_request = new URLRequest(url);
			
			if(vars){
				var requestVars:URLVariables = new URLVariables();
				for (var key:String in vars){
					requestVars[key] = vars[key];
					trace("FOI ENVIADO>>>>", vars[key]);
				}
				_request.data = requestVars;
			}

			_request.method = URLRequestMethod.POST;
			
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			_urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler, false, 0, true);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, erro, false, 0, true);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			_urlLoader.load(_request);

			XMLFromServerSignals._INIT.dispatch();
		}
		
		public function destroy():void
		{
			//_urlLoader.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			//_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			//_urlLoader = null;
			//_request = null;
		}
		
		// ___________________________________________________________________ PRIVATE METHODS
		
		private function loaderCompleteHandler(e:Event):void
		{
			XMLFromServerSignals._LOADED.dispatch(XML(e.target.data));
			destroy();
		}

		private function securityErrorHandler(e:SecurityErrorEvent):void{
			XMLFromServerSignals._ERROR.dispatch("> securityErrorHandler:" + e);
		}
		
		private function erro(e:IOErrorEvent):void
		{
			XMLFromServerSignals._ERROR.dispatch(e.text);
		}


	}
}

class SingletonObligate {}
