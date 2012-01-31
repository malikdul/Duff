package com.duff.signals{
	import org.osflash.signals.Signal;
	/**
	 * @author borella
	 */

	public class XMLFromServerSignals
	{
		public static var _LOADED:Signal = new Signal(XML);
		public static var _INIT:Signal = new Signal();
		public static var _PROGRESS:Signal = new Signal();
		public static var _ERROR:Signal = new Signal(String);
	}
}
