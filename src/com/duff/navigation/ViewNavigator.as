package com.duff.navigation {

	import com.duff.display.ISectionView;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import com.duff.core.Configs;
	import com.duff.navigation.signals.ViewNavigatorSignal;
	import com.duff.log.Logger;
	
	/**
	 * @author borella
	 */
	 
	public class ViewNavigator{
		
		//______________________________________________________________________ GETTERS/SETERS
		
		public function get SWFAddressEnabled():Boolean {return _SWFAddressEnabled;};
		public function set SWFAddressEnabled(value:Boolean):void {_SWFAddressEnabled=value;};
		public static function get firstView():String {return _firstView;};
		public function set firstView(value:String):void {_firstView=value;};
		public function get nextView():String {return _nextView;};
		public function set nextView(value:String):void {_nextView=value;};
		public function get currentView():ISectionView {return _currentView;};
		public function set view404(value:String):void {_404View=value;};
		public function get view404():String {return _404View;};
		public function get history() : Array { return _history;}
		
		//______________________________________________________________________ VARS
		
		private var _currentViews:Dictionary = new Dictionary();
		private var _SWFAddressEnabled:Boolean;
		private static var _firstView:String;
		private var _currentView:ISectionView;
		private var _nextView:String;
		private var _scope:*;
		private var _404View:String;
		private var _history:Array = [];
		
		private var _hasInit:Boolean = false;
		
		// ___________________________________________________________________ CONSTRUCTOR
		
		public function ViewNavigator(){};
		
		//______________________________________________________________________ PUBLIC METHODS

		public function init(scope:*, views:Array, frtsView:String=null,SWFAddressEnabled:Boolean=true, page404:String=null):void
		{
			if (!_hasInit) {
				//--- set scope
				_scope = scope;
				
				//--- set SWFAddress
				_SWFAddressEnabled = SWFAddressEnabled;
				
				//--- set first view/section
				if(frtsView) _firstView = frtsView;
				 else _firstView = views[0].deepLink;
				 
				//---  set 404 view/section
				if(page404) _404View = page404;
				 else{_404View = _firstView;}
				 
				//--- add views
				for (var i:int=0; i<views.length; ++i) {
					addView(views[i].deepLink, views[i].label,views[i].viewClass, views[i].viewProps, views[i].scope);				
				}
				
				//--- add
				if(_SWFAddressEnabled) SWFAdressNavigator.init();
				
				//--- add signals	
				ViewNavigatorSignal._CALL_VIEW.add(call);	
				ViewNavigatorSignal._STARTED.dispatch();
			}else {
				Logger.warning("Class 'ViewNavigator' Has Started Previously");
			}
			
		}
		
		public function addView(deepLink:String, label:String, viewClass:String, viewProps:Object=null, scope:DisplayObjectContainer=null):void
		{
			//--- configs
			var tmpObject:Object = {};
			tmpObject.label = label;
			tmpObject.deepLink = deepLink;
			tmpObject.viewClassPath = viewClass;
			if(viewProps) tmpObject.viewProps = viewProps;
			if(scope) tmpObject.scope = scope;
			_currentViews[deepLink] = tmpObject;
		}
		
		public function call(label:String, transition:Boolean=true):void
		{
			//--- set next section
			_nextView = label;
			
			//--- check if next section exists / else call 404 page
			if(_currentViews[_nextView]){
			
					//--- check if _currentView exists
					if (_currentView) {
						
						destroyCurrentView(transition);
						ViewNavigatorSignal._CURRENT_VIEW_DESTROYED.addOnce(addNextViewAtScope);
						
					}else{
						addNextViewAtScope();
					}
			
			}else{
				add404ViewAtScope();
			}
			
			//-- add history
			_history.push(label);
		}
		
		//______________________________________________________________________ PRIVATE METHODS
		private function addNextViewAtScope():void
		{
			if(_currentViews[_nextView]){
				var ClassReference:Class = getDefinitionByName(_currentViews[_nextView].viewClassPath) as Class;
				var newSection:ISectionView = new ClassReference();
				Configs.scope.addChild(newSection);
				 newSection.build();
				_currentView = newSection;
			}else{
				add404ViewAtScope();
			}
		}
		
		private function add404ViewAtScope():void
		{
			if(_SWFAddressEnabled) SWFAdressNavigator.call(_404View);
			 else{call(_404View);};
		}
		
		private function destroyCurrentView(transition:Boolean=true):void
		{
			removeCurrentView();
		}
		
		private function removeCurrentView():void
		{
			ViewNavigatorSignal._CURRENT_VIEW_DESTROYED.addOnce(addNextViewAtScope);
			Configs.scope.removeChild(_currentView);
			_currentView.destroy();
		}

		
	
	}
}