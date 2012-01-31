package com.duff.navigation {
	
	import com.duff.navigation.signals.ViewNavigatorSignal;
	import com.duff.log.Logger;
	
	import com.swfaddress.SWFAddressEvent;
	import com.swfaddress.SWFAddress;
	
	
	/**
	 * @author borella
	 */
	
	public class SWFAdressNavigator {
		
		//______________________________________________________________________ VARS
		
		private static var _hasInit:Boolean = false;
		
		//______________________________________________________________________ PUBLIC METHODS
		
		public static function init():void
		{
			if (!_hasInit) {
				SWFAddress.addEventListener(SWFAddressEvent.INIT, onSWFAddressInit);
				SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onSWFAddressChange);
				_hasInit = true;
			}
		}
		
		public static function call(value:String):void
		{
			SWFAddress.setValue(value);
		}
		
		//______________________________________________________________________ PRIVATE METHODS
		
		private static function onSWFAddressInit(event : SWFAddressEvent) : void {
			
			if(SWFAddress.getPath() == "/" ){
				 SWFAddress._value = ViewNavigator.firstView;
				 Logger.debug(SWFAddress._value, "< SWFAddressInit >");
			}
			
			SWFAddress.removeEventListener(SWFAddressEvent.INIT, onSWFAddressInit);
		}

		private static function onSWFAddressChange(e:SWFAddressEvent):void
		{
			ViewNavigatorSignal._CALL_VIEW.dispatch(SWFAddress.getPath());
			Logger.debug(SWFAddress._value, "< SWFAddress CHANGED >");
		}
		
	}
}
