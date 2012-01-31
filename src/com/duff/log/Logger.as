package com.duff.log 
{
	import com.junkbyte.console.Cc;
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author borella
	 */
	
	public class Logger 
	{
		
		//____________________________________________________________________ VARS
		private static var _hasInit:Boolean = false;
		private static var _password:String;
		private static var _stage:Stage;
		private static var _visible:Boolean;
		private static var _commandLineAllowed:Boolean;
		
		//______________________________________________________________________ CONSTRUCTOR
		public function Logger() { };
		
		//______________________________________________________________________ PUBLIC METHODS
		public static function init(__stage:Stage, __password:String="", __visible:Boolean=true, __commandLineAllowed:Boolean=true):void
		{
			if (!_hasInit) {
				_stage = __stage;
				_password = __password;
				_visible = __visible;
				_commandLineAllowed = __commandLineAllowed;
				
				Cc.startOnStage(_stage, _password);
				Cc.visible = _visible; 
				Cc.config.commandLineAllowed = _commandLineAllowed;
				Cc.config.tracing = true; 
				Cc.remotingPassword = null;
				Cc.remoting = true;
				Cc.commandLine = true;
				Cc.height = 220;

				_hasInit = true;
			}
		}
		
		public static function log(value:String):void
		{
			Cc.log(value);
		}
		
		public static function warning(value:String):void
		{
			Cc.log("[warning] "+value);
		}
		
		public static function error(value:String):void
		{
			Cc.log("[error] "+value);
		}
		
		public static function debug(iten:*, info:String = ""):void
		{
			Cc.debug(iten, info);
		}
		
		public static function clear():void
		{
			Cc.clear();
		}
		
		
	}

}