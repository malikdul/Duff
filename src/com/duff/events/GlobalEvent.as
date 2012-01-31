package com.duff.events
{
	import flash.events.Event;

	public class GlobalEvent extends Event
	{
		public var property:*;
		public static const PROPERTY_CHANGED:String = "globalPropertyChanged";
	
		public function GlobalEvent(type:String, property:*, bubbles:Boolean = false, cancelable:Boolean = false) {
			this.property = property;
			super(type, bubbles, cancelable);
		}
	
		override public function clone():Event {
			return new GlobalEvent(type, property, bubbles, cancelable);
		}
	}
}