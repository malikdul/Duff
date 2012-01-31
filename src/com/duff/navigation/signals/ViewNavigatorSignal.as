package com.duff.navigation.signals {
	
	import org.osflash.signals.Signal;
	
	/**
	 * @author borella
	 */
	
	public class ViewNavigatorSignal{
		
		public static var _CALL_VIEW:Signal = new Signal(String);
		public static var _CURRENT_VIEW_DESTROYED:Signal = new Signal();
		public static var _CURRENT_VIEW_TRANSITION_OUT_FINISHED:Signal = new Signal();
		public static var _STARTED:Signal = new Signal();
		public static var _SWF_ADRESS_STARTED:Signal = new Signal();
		
	}
}