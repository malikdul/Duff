package com.duff.loading 
{
	import com.duff.log.Logger;
	import com.hydrotik.queueloader.QueueLoader;
	import com.hydrotik.queueloader.QueueLoaderConst;
	import com.hydrotik.queueloader.QueueLoaderEvent;
	import flash.utils.Dictionary;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author borella
	 */
	public class LoaderFactory 
	{
		
		//_______________________________________________________________________ SIGNALS
		
		public var _PROGRESS:Signal = new Signal(String);
		public var _LOADED:Signal = new Signal(Dictionary);
		public var _ERROR:Signal = new Signal(String);
		public var _INIT:Signal = new Signal();
		
		//_______________________________________________________________________ VARS
		
		private var _oLoader:QueueLoader = new QueueLoader();
		private var _autoDestroy:Boolean = true;
		private var _totalItens:Number;
		private var _itensLabel:Array = [];
		
		// ______________________________________________________________________ CONSTRUCTOR

		public function LoaderFactory() {}
		
		// ______________________________________________________________________ PUBLIC METHODS

		public function load(itens:Array, autoDestroy:Boolean=true):void
		{
			Logger.log("init load opa " + itens.length);
			//-- autoDestroy
			_autoDestroy = autoDestroy;
			
			//-- add files
			
			_totalItens = itens.length;
			
			for (var i:int = 0; i < _totalItens; ++i ) {
				_oLoader.addItem(itens[i].url, null, { title:itens[i].label, mimeType:getType(itens[i].type) } );
				_itensLabel[i] = itens[i].label;
			}
			
			//-- add listeners
			_oLoader.addEventListener(QueueLoaderEvent.QUEUE_COMPLETE, onLoaded, false, 0, true);
			_oLoader.addEventListener(QueueLoaderEvent.ITEM_ERROR, erro, false, 0, true);
			_oLoader.addEventListener(QueueLoaderEvent.ITEM_PROGRESS, onLoading, false, 0, true);
			
			//-- init loading
			_oLoader.execute();
			
			//-- dispatch INIT signal 
			_INIT.dispatch();
			
		}
		
		public function destroy():void
		{
			_oLoader.removeEventListener(QueueLoaderEvent.ITEM_PROGRESS, onLoading);
			_oLoader.removeEventListener(QueueLoaderEvent.QUEUE_COMPLETE, onLoaded);
			_oLoader.removeEventListener(QueueLoaderEvent.ITEM_ERROR, onLoading);
			_oLoader.dispose();
			_oLoader = null;
			_itensLabel = null;
		}

		//_______________________________________________________________________ PRIVATE METHODS
		
		private function getType(value:String):int
		{
			var _value:int;
			
			switch (value){

				case "swf":
					_value = QueueLoaderConst.FILE_SWF;
				break;
				case "img":
					_value = QueueLoaderConst.FILE_IMAGE;
				break;
				case "mp3":
					_value = QueueLoaderConst.FILE_MP3;
				break;
				case "wav":
					_value = QueueLoaderConst.FILE_WAV;
				break;
				case "xml":
					_value = QueueLoaderConst.FILE_XML;
				break;
				case "flv":
					_value = QueueLoaderConst.FILE_FLV;
				break;
				case "css":
					_value = QueueLoaderConst.FILE_CSS;
				break;
				case "zip":
					_value = QueueLoaderConst.FILE_ZIP;
				break;
				default:
					_value = QueueLoaderConst.FILE_GENERIC;
			}
			
			return _value;
			
		}
		
		private function getItensLoaded():Dictionary
		{
			
			
			var itens:Dictionary = new Dictionary();
			
			if (_oLoader) {
				for (var i:int = 0; i < _totalItens; ++i ) {
					//Logger.log("entrou no for " + i)
					//Logger.debug(_oLoader.getItemByTitle("app"), _itensLabel[i])
					itens[_itensLabel[i]] = _oLoader.getItemByTitle(_itensLabel[i]).content;
					
					
				}
			}else {
				Logger.error("[LoaderFactory.as] ERROR - _oLoader == null");
			}
			

			
			return itens;
		}
		
		// _________________________________________________________________________ EVENT HANDLERS
		
		private function onLoading(e:QueueLoaderEvent):void{
			_PROGRESS.dispatch( String( Math.round((e.bytesLoaded / e.bytesTotal ) * 100) ) );
		}
		

		private function onLoaded(e:QueueLoaderEvent):void {
			trace("completou")
			_LOADED.dispatch(getItensLoaded());
			
			//-- destroy
			if (_autoDestroy) destroy();
		}
		
		private function erro(event : QueueLoaderEvent) : void {
			
			_ERROR.dispatch(String("[LoaderFactory] ERROR " + event.info));
		}
		
		
	}

}