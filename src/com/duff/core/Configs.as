package com.duff.core{
	
	import com.duff.signals.DisplaySignals;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import org.osflash.signals.Signal;
	
	import com.duff.log.Logger;
	import com.duff.core.Paths;
	import com.duff.loading.XMLLoader;
	import com.duff.signals.ConfigsSignals;
	import com.duff.signals.XMLLoaderSignals;
	import com.duff.ui.CtextMenu;
	

	public class Configs
	{
		//______________________________________________________________________ SIGNALS
		
		public static var _INIT:Signal = new Signal();
		public static var _FINISHED:Signal = new Signal();
		
		//______________________________________________________________________ VARS
		
		private static var _xmlLoad:XMLLoader = new XMLLoader();	
		private static var _hasInit:Boolean = false;	
		private static var _debugMode:Boolean = false;
		private static var _stageAlign: String 	= "";
		private static var _pathXml:String = "";
		private static var _stage:Stage;
		private static var _configs:Object = {};
		private static var _scope:*;
		private static var _xmlApp:*;
		
		//______________________________________________________________________ GET/SET

		public static function get hasInit():Boolean{return _hasInit;}
		public static function get debugMode():Boolean {return _debugMode;}
		public static function set XML (valor:*) : void {_pathXml = valor;}
		public static function get XML ():String {return _pathXml;}
		public static function get stage ():Stage { return _stage;}
		public static function set stage (stage_:Stage):void { _stage = stage_;}
		public static function get scope ():* { return _scope;}
		public static function set scope(scope:*):void { _scope = scope;}
		public static function get content ():Object {return _configs;}
		public static function get xmlApp():* {return _xmlApp;}
		
		// ______________________________________________________________________ PUBLIC METHODS
		
		public static function init(pathXml:String, stage_:Stage, scope:*=null):void
		{
			if (!_hasInit) {
				//---
				_pathXml = pathXml;
				_scope = scope;
				_stage = stage_;
				
				//--- load configs from xml
				_xmlLoad.load(_pathXml);
				XMLLoaderSignals._COMPLETE.addOnce(setup);
				XMLLoaderSignals._ERROR.addOnce(XMLError);
				
				//---
				_hasInit = true;
				ConfigsSignals._INIT.dispatch();
			}
		}
		
		// ______________________________________________________________________ PRIVATE METHODS
		
		private static function setup(xml:*):void
		{
			
			_xmlApp = xml;

			//---- define os valores no objeto
			_configs.frameRate = xml.settings[0].frame_rate[0].@value;
			_configs.creditsName = xml.settings[0].credits[0].@nome;
			_configs.creditsLink = xml.settings[0].credits[0].@link;
			_configs.pathGlobal = xml.settings[0].paths[0].@global;
			_configs.pathXml = xml.settings[0].paths[0].@xml;
			_configs.pathBackend = xml.settings[0].paths[0].@backend;
			_configs.pathImg = xml.settings[0].paths[0].@img;
			_configs.pathVideo = xml.settings[0].paths[0].@video;
			_configs.pathAudio = xml.settings[0].paths[0].@audio;
			_configs.pathSwf = xml.settings[0].paths[0].@swf;
			_configs.scaleMode = xml.settings[0].scaleMode[0].@value;
			_configs.align = xml.settings[0].align[0].@value;
			_configs.debugMode = xml.settings[0].debugMode[0].@value;
			
			//---- config app
			setupApp(_configs.frameRate, _configs.scaleMode, _configs.align);
			
			//---- config paths
			setupPaths();
			
			//---- config debugMode
			setupDebugMode();
			
			//-- add stage resize listener
			_stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			
			//---- config context menu
			if (_configs.creditsName != "" && _scope) CtextMenu.build(_scope, _configs.creditsName, _configs.creditsLink);
			
			//---- dispatch finished signal
			_FINISHED.dispatch();
		}
		
		private static function XMLError(e:String):void
		{
			Logger.error("ERRO! Problemas com o XML de configuração.");
			
		}
		
		private static function setupDebugMode():void
		{
			_debugMode = _configs.debugMode == "true" ? true : false;
			if (_debugMode) Logger.init(_stage);
		}
		
		private static function setupApp(_frameRate:*=31, _scaleMode:String=null, _align:String=null):void
		{
			//-- config frame rate
			_stage.frameRate = _frameRate;
			
			//-- config align/scale
			if(_scaleMode == "NO_SCALE") _stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
			setStageAlign(_align);
		}
		
		private static function setupPaths():void
		{
			Paths._Global = _configs.pathGlobal;
			Paths._Swf = _configs.pathSwf;
			Paths._Xml = _configs.pathXml;
			Paths._Backend = _configs.pathBackend;
			Paths._Img = _configs.pathImg;
			Paths._Video = _configs.pathVideo;
			Paths._Audio = _configs.pathAudio;
		}
		
		private static function setStageAlign(valor:String):void 
		{
			switch (valor) 
			{
				case "B":
					_stageAlign = flash.display.StageAlign.BOTTOM;
					break;
				
				case "BL":
					_stageAlign = flash.display.StageAlign.BOTTOM_LEFT;
					break;
				
				case "BR":
					_stageAlign = flash.display.StageAlign.BOTTOM_RIGHT;
					break;
				
				case "L":
					_stageAlign = flash.display.StageAlign.LEFT;
					break;
				
				case "R":
					_stageAlign = flash.display.StageAlign.RIGHT;
					break;
				
				case "T":
					_stageAlign = flash.display.StageAlign.TOP;
					break;
				
				case "TL":
					_stageAlign = flash.display.StageAlign.TOP_LEFT;
					break;
				
				case "TR":
					_stageAlign = flash.display.StageAlign.TOP_RIGHT;
					break;
			}
			_stage.align = _stageAlign;
		}
		
		// __________________________________________________________________ EVENT HANDLERS

		private static function onStageResize(e:Event):void 
		{
			DisplaySignals._SCREEN_RESIZE.dispatch();
		}
		
	}
}