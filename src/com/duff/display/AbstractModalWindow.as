package com.duff.display {
	
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.display.Sprite;
	
	import com.greensock.easing.*;
	import com.greensock.TweenLite;
	
	import org.osflash.signals.Signal;
	
	/**
	 * @author bruno.borella
	 */
	 
	public class AbstractModalWindow extends Sprite {
		
		//_____________________________________________________________ VARS
		
		private var _scope:Sprite;
		private var _container:*;
		private var _bg:Sprite;
		private var _color:uint = 0x000000;
		private var _stage:Stage;
		private var _alpha:Number = .8;
		private var _autoOpen:Boolean = true;
		private var _transitionIn:Boolean = true;
		private var _transitionOut:Boolean = true;
		private var _transitionTime:Number = .7;
		private var _transitionEase:Function = Quint.easeOut;
		
		//_____________________________________________________________ SIGNALS
		
		public var _MODAL_INIT:Signal = new Signal();
		public var _MODAL_OPENED:Signal = new Signal();
		public var _MODAL_CLOSED:Signal = new Signal();
		public var _MODAL_DESTROYED:Signal = new Signal();
				
		//_____________________________________________________________ CONSTRUCTOR
		
		public function AbstractModalWindow() {};
		
		//_____________________________________________________________ PUBLIC METHODS
		
		public function build(container:*, stage:Stage, configs:Object=null):void
		{
			_scope = new Sprite();
			addChild(_scope);
			_container = container;
			_stage = stage;
			
			//-- setup configs
			if(configs){
				if(configs.color) _color = configs.color;
				if(configs.alpha) _alpha = configs.alpha;
				if(configs.autoOpen) _autoOpen = configs.autoOpen;
				if(configs.transitionIn) _transitionIn = configs.transitionIn;
				if(configs.transitionOut) _transitionOut = configs.transitionOut;
				if(configs.transitionTime) _transitionTime = configs.transitionTime;
				if(configs.transitionEase) _transitionEase = configs.transitionEase;
			}
			
			//-- build bg
			buildBg();
			
			//-- build container
			buildContainer();
			
			//-- align
			_stage.addEventListener(Event.RESIZE, align, false, 0, true);
			align();
			
			//-- auto open
			if(_autoOpen) open();
			
			//
			_MODAL_INIT.dispatch();
		}
		
		public function destroy():void
		{
			_stage.removeEventListener(Event.RESIZE, align);
			//
			_container =
			_bg =
			_scope =
			_stage = null;
			//
			_MODAL_DESTROYED.dispatch();
			//
			_MODAL_INIT.removeAll();
			_MODAL_CLOSED.removeAll();
			_MODAL_OPENED.removeAll();
			_MODAL_DESTROYED.removeAll();
			
			_MODAL_INIT =
			_MODAL_CLOSED = 
			_MODAL_OPENED =
			_MODAL_DESTROYED = null;
			
			//
		}
		
		public function close(e:Event=null):void
		{
			if(_transitionOut){
				TweenLite.to(_scope, .7, {alpha:0, ease:_transitionEase, onComplete:onCompleted});
			}else{
				onCompleted();
			}
			
			function onCompleted():void {
				_MODAL_CLOSED.dispatch();
				destroy();
			}
			
		}
		
		public function open(e:Event=null):void
		{
			if(_transitionIn){
				_bg.alpha = _container.alpha = 0;
				TweenLite.to(_bg, _transitionTime, {alpha:_alpha, ease:_transitionEase});
				TweenLite.to(_container, _transitionTime, {alpha:1, ease:_transitionEase, delay:.2, onComplete:_MODAL_OPENED.dispatch});
			}else{
				_bg.alpha =_alpha;
				 _container.alpha = 1;
				 _MODAL_OPENED.dispatch();
			}
					
		}
		
		//_____________________________________________________________ PRIVATE METHODS
		private function buildContainer() : void {
			_scope.addChild(_container);
			_container.alpha = 0;
		}

		private function buildBg() : void {
			_bg = new Sprite();
			_bg.cacheAsBitmap = true;
			_bg.graphics.beginFill(_color);
			_bg.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
			_bg.graphics.endFill();
			_bg.x = 0;
			_bg.y = 0;
			_bg.alpha = 0;
			_scope.addChild(_bg);
			//
			_bg.buttonMode = false;
			_bg.addEventListener(MouseEvent.MOUSE_UP, close, false, 0, true);
		}
		
		private function align(e:Event=null):void
		{
			_scope.x = _scope.y = 0;
			_bg.width = _stage.stageWidth;
			_bg.height = _stage.stageHeight;
			_bg.x = _bg.y = 0;
			//
			_container.x = Math.round((_stage.stageWidth *.5) - (_container.width *.5));
			_container.y = Math.round((_stage.stageHeight *.5) - (_container.height *.5));
		}
	}
}
