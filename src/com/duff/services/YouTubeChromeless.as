package com.duff.services{	
	
	import flash.geom.Point;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.system.Security;
	
	/**
	 * @author borella
	 */
	 
	public class YouTubeChromeless{
			
		//___________________________________________________________________________________ VARS
		
		private var player:Object;
		private var loader:Loader;
		private var _scope:*;
		private var _id:Number;
		private var callBackReady:Function;
		private var _idVideo:String;
		private var _size:Point;
	
		//___________________________________________________________________________________ PUBLIC METHODS
		public function build(scope:*, size:Point, idVideo:String, ready:Function, id:Number=0):void
		{
			_scope = scope;
			_id = id;
			_size = size;
			_idVideo = idVideo;
			callBackReady = ready;
			setupSecurity();
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit, false, 0, true);
			loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			
		}
		
		public function destroy():void
		{
			player.destroy();
			loader.contentLoaderInfo.removeEventListener(Event.INIT, onLoaderInit);
			loader = null;
			player = null;
		}

		//___________________________________________________________________________________ PRIVATE METHODS
		private function setupSecurity():void
		{
			Security.allowDomain('www.youtube.com');
			Security.allowDomain('youtube.com');
			Security.allowDomain('s2.youtube.com');
			Security.allowDomain('s.ytimg.com');
			Security.allowDomain('i.ytimg.com');
			Security.allowDomain('i1.ytimg.com');
			Security.allowDomain('img.youtube.com');
			Security.allowDomain('s.ytimg.com/yt/swfbin/');
			Security.allowDomain('o-o.preferred.gvt-poa1.v20.lscache2.c.youtube.com');
			Security.allowDomain('*');
		}
		
		//_____________________________________________________________________________________ EVENTS
		
		
		private function onLoaderInit(event:Event):void 
		{
		    _scope.addChild(loader);
		    loader.content.addEventListener("onReady", onPlayerReady);
		    loader.content.addEventListener("onError", onPlayerError);
		    loader.content.addEventListener("onStateChange", onPlayerStateChange);
		    loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
			//
			
		}
		
		private function onPlayerReady(event:Event):void 
		{
		    player = loader.content;
		    player.setSize(_size.x, _size.y);
			player.loadVideoById(_idVideo);
			callBackReady();
		}
		
		private function onPlayerError(event:Event):void 
		{
		    trace("player error:", Object(event).data);
		}
		
		private function onPlayerStateChange(event:Event):void 
		{
		    trace("player state:", Object(event).data);
		}
		
		private function onVideoPlaybackQualityChange(event:Event):void 
		{
		    trace("video quality:", Object(event).data);
		}

	}
}
