package com.duff.loading{
	
	import flash.net.URLLoader;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.events.ProgressEvent;
	
	import com.duff.signals.XMLLoaderSignals;
	import org.osflash.signals.natives.NativeSignal;
	
	/**
	* @author borella
	*/

	public class XMLLoader
	{
		// ______________________________________________________________________ VARS
		
		private var _loader:URLLoader;
		private var _loadedSignal:NativeSignal;
		private var _progressSignal:NativeSignal;
		private var _errorSignal:NativeSignal;
		private var _hasInit:Boolean = false;
		
		// ______________________________________________________________________ CONSTRUCTOR
	
		public function XMLLoader(){};
		
		// ______________________________________________________________________ PUBLIC METHODS
		
		public function load(url:String):void 
		{
			
			if (!_hasInit) {
				
				_loader = new URLLoader();
				_loader.load(new URLRequest(url));
				
				_loadedSignal = new NativeSignal(_loader, Event.COMPLETE, Event);
				_loadedSignal.addOnce(onLoadComplete);
				
				_progressSignal = new NativeSignal(_loader, ProgressEvent.PROGRESS, Event);
				_progressSignal.add(onLoadProgress);
				
				_errorSignal = new NativeSignal(_loader, IOErrorEvent.IO_ERROR, Event);
				_errorSignal.addOnce(onIOError);
				
				XMLLoaderSignals._INIT.dispatch();
				_hasInit = true;
			
			}else {
				destroy();
				//	load();
			}
			
		}
		
		public function destroy():void
		{
			_progressSignal.removeAll();
			_progressSignal = null;
			
			//
			_loadedSignal.removeAll();
			_loadedSignal = null;
			
			//
			_errorSignal.removeAll();
			_errorSignal = null;
			
			//
			_loader = null;
			_hasInit = false;
		}
		
		// ______________________________________________________________________ PRIVATE METHODS
		
		private function onLoadProgress(e:ProgressEvent):void
		{
			XMLLoaderSignals._PROGRESS.dispatch(Number(e.bytesLoaded / e.bytesTotal));
		}
		
		private function onLoadComplete(e:Event):void
		{
			XMLLoaderSignals._COMPLETE.dispatch(XML(_loader.data));
		}
		
		private function onIOError(e:IOErrorEvent):void
		{
			XMLLoaderSignals._ERROR.dispatch(String("XMLLoader IOErrorEvent:" + e));
		}
	
	
	
	}

}