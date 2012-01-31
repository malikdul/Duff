package com.duff.services{
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.system.Security;
	
	/**
	 * @author borella
	 * 
	 * EX: 
	 * var video:YouTube = new YouTube();
	   video.getPlayer(_scope, "DMQbzLrvwlE", {width:500, height:700});
	   or
	   var url:String = video.getImgPreviewUrl("DMQbzLrvwlE");
	 
	  * TODO _autoPLay;
	 */
	
	
	
	public class YouTube
	{
		//____________________________________________________________________ VARS
		private var _width:Number = 480;
		private var _height:Number = 385;
		private var _autoPlay:Boolean = true;
		private var _id:String;
		private var _pathImg:String = "http://img.youtube.com/vi/";
		private var _playerEnabled:Boolean = false;
		private var _loader:Loader;
		private var _hasInit:Boolean = false;
		private var _destroyAfterInit:Boolean = false;
		
		private static var _instance:YouTube;
		private var _container:*;
		
		public var _player:Object;
		
		private var _onStateChangeFn:Function;
		
		// ___________________________________________________________________ CONSTRUCTOR
		public function YouTube(){};
		// ___________________________________________________________________ PUBLIC METHODS
		
		public static function getInstance():YouTube
		{
			if(_instance==null){
				_instance = new YouTube();
			}
			return _instance;
		}
		
		/**
		 * getPlayer
		 * @param container:* (Sprite, MovieClip)
		 * @param id:String (YouTube video id)
		 * @param vars:Object (Width, height, autoPlay)
		 * 
		 * EX: 
		 * var video:YouTube = new YouTube();
		   video.getPlayer(_scope, "DMQbzLrvwlE", {width:500, height:700});
		 
		 * TODO _autoPlay;
		 */
		 
		public function getPlayer(container:*,id:String, vars:Object=null):void
		{
			_container = container;
			setupSecurity();
			
			if(vars){
				if(vars.width) _width = vars.width;
				if(vars.height) _height = vars.height;
				if(vars.autoPlay) _autoPlay = vars.autoPlay;
				if(vars.onStateChangeFn) _onStateChangeFn = vars.onStateChangeFn;
			}
			
			_id = id;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			var urlPlayer:String = String("http://www.youtube.com/v/"+_id+"?version=3");
			_loader.load(new URLRequest(urlPlayer));
			
			_playerEnabled = true;
			container.addChild(_loader);
		}
		
		public function loadNewVideo(id:String):void
		{
			if(_player)_player.loadVideoById(id);
		}
		
		/**
		 * getImgPreviewUrl
		 * @param id:String
		 * @param size:Number (1,2 or 3)
		 * 
		 * EX: 
		 * var url:String = video.getImgPreviewUrl("DMQbzLrvwlE");
		 */
		public function getImgPreviewUrl(id:String, size:Number=3):String
		{
			var imgUrl:String = (_pathImg+id+"/"+size+".jpg");
			return imgUrl;
		}
		
		public function destroy():void
		{
			if(_hasInit && _playerEnabled){
				_loader.content.removeEventListener("onReady", onPlayerReady);
			    _loader.content.removeEventListener("onError", onPlayerError);
			  	_player.destroy();
			    _container.removeChild(_loader);
				_loader = null;
				_player = null;
			}else{
				_destroyAfterInit = true;
			}
		}
		
		// ___________________________________________________________________ PRIVATE METHODS
		private function setupSecurity():void{
			Security.allowDomain('www.youtube.com');
			Security.allowDomain('youtube.com');
			Security.allowDomain('s2.youtube.com');
			Security.allowDomain('s.ytimg.com');
			Security.allowDomain('i.ytimg.com');
			Security.allowDomain('i1.ytimg.com');
			Security.allowDomain('img.youtube.com');
			Security.allowDomain('*');
		}
		
		// ___________________________________________________________________ EVENTS
		
		private function onLoaderInit(event:Event):void {
			_loader.contentLoaderInfo.removeEventListener(Event.INIT, onLoaderInit);
		    _loader.content.addEventListener("onReady", onPlayerReady);
		    _loader.content.addEventListener("onError", onPlayerError);
		    _loader.content.addEventListener("onStateChange", videoState);   
		}
		
		private function onPlayerReady(event:Event):void {
			
			_hasInit = true;
			
			if(!_destroyAfterInit){
				_player = _loader.content;
				_player.loadVideoById(_id);
				//-- set size
				_player.setSize(_width, _height);
			}else{
				_loader.content.removeEventListener("onReady", onPlayerReady);
			    _loader.content.removeEventListener("onError", onPlayerError);
			    _container.removeChild(_loader);
				_loader = null;
				_player = null;
			}
		}
		
		private function onPlayerError(event:Event):void {
		    trace("player error:", Object(event).data);
		}
		
		private function videoState(e:Event) : void {
			if(_onStateChangeFn!=null) _onStateChangeFn(Object(e).data);
		}
		
	}
}
