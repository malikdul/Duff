package com.duff.core 
{
	import com.duff.loading.LoaderFactory;
	import com.duff.log.Logger;
	import com.hydrotik.queueloader.QueueLoader;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author borella
	 */
	
	public class AbstractLoaderApp extends AbstractApp
	{

		// ______________________________________________________________________ VARS
		
		private var _appName:String;
		private var _percentual:Number;
		private var _scope:Sprite;
		private var _itens:Array = [];
		private var _loader:LoaderFactory;
		private var _hasInit:Boolean = false;
		private var _onComplete:Function;

		// ______________________________________________________________________ CONSTRUCTOR
		
		public function AbstractLoaderApp(){};

		// ______________________________________________________________________ PUBLIC METHODS
		
		protected override function start():void
		{
			if (!_hasInit) {
				trace("init start AbstractLoader")
				build();
				_hasInit = true;
			}

		}
		
		protected override function init(hasInit:Boolean=true):void 
		{	
			start();
		}
		
		
		public function startLoader(itensToLoad:Array, onComplete:Function, onProgress:Function, onError:Function):void
		{
			_onComplete = onComplete;
			
			_itens = itensToLoad;
			_loader = new LoaderFactory();
			
			_loader._PROGRESS.add(onProgress);
			_loader._ERROR.addOnce(onError);
			_loader._LOADED.addOnce(complete);
			
			_loader.load(_itens);
		}
		
		protected function build():void
		{
			Logger.error("[com.duff.core.AbstractLoaderApp.as] build()");
			throw new Error("[com.duff.core.AbstractLoaderApp.as] build");
		};

		// ______________________________________________________________________ PRIVATE METHODS
		
		private function complete(value:*):void
		{
			_onComplete(value);
			//destroy();
			
		}
		
		private function destroy():void
		{
			_itens = null;
			if (_loader) {
				_loader.destroy();
				_loader = null;
			}
		}
		
	}

}