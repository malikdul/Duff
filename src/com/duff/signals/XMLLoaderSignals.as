package com.duff.signals{
	import org.osflash.signals.Signal;

	public class XMLLoaderSignals
	{
		public static var _INIT:Signal = new Signal();
		public static var _COMPLETE:Signal = new Signal(XML);
		public static var _PROGRESS:Signal = new Signal(Number);
		public static var _ERROR:Signal = new Signal(String);
	}
}
