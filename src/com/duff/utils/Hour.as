package com.duff.utils {
	import flash.display.Sprite;
	import flash.events.Event;


	/**
	 * @author borella
	 * !!!!incomplete!
	 */
	public class Hour extends Sprite{
		
		//_______________________________________________________________________ VARS
		public static var show24:Boolean;
		public static var showSeconds:Boolean;
		private static var _data:Date;
		private static var timeStr:String;
		private static var _horas:Number;
		private static var _minutos:Number;
		private static var _segundos:Number;
		private static var _minsecs:String;
		private static var ampm:String;
		

		public function getTime( e:Event ):void
		{
			
			_data = new Date( );
			var time:* = _data.toLocaleTimeString( );
			_horas = Number(time.substr( 0, 2 ));
			_minutos = Number(time.substr( 3, 2 ));
			_segundos = Number(time.substr( 5, 2 ));
			_minsecs = time.substr( 3, 6 );
			ampm = time.substr( 9, 2 );
			
			if ( ampm == 'PM' )
			{
				ampm = 'pm';
			}
			else
			{
				ampm = 'am';
			}
			
			if ( show24 && ampm == 'pm' )
			{
				_horas += 12;
			}
			
			if ( !showSeconds )
			{
				_minsecs = _minsecs.substr( 0, 2 );
			}
			
			timeStr = _horas.toString( ) + ':' + _minsecs + ampm;
			
		}
	}
}