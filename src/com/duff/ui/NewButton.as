package com.duff.ui {
	//_________________________________________________________________________ IMPORTS
	import flash.events.MouseEvent;
	import flash.display.MovieClip;


	/**
	 * @author borella
	 */
	public class NewButton extends MovieClip {
		
		//_________________________________________________________________________ VARS
		private static var _bts:Array = [];
		private static var _contagemId:int = 0;
		
		//_________________________________________________________________________ CONFIG BTN
		public static function config(_alvo:MovieClip, fClick:Function=null, fOver:Function=null, fOut:Function=null, _name:String="", btMode:Boolean=true, mChildren:Boolean=false):void
		{
		if(_name=="") _name=String("bt_"+_contagemId);
		_alvo.mouseChildren = mChildren;
		_alvo.buttonMode = btMode;
		//_alvo.name = _name;
		_alvo.id = _contagemId;
		_contagemId++;
		
		//___________________________________________________ prop
		var _tClick:* = null;
		var _tOver:* = null;
		var _tOut:* = null;
		
		//___________________________________________________ mouse handlers
		if(fClick){
			_alvo.addEventListener(MouseEvent.CLICK, fClick);
			_tClick = MouseEvent.CLICK;
		}
		
		if(fOver){
			_alvo.addEventListener(MouseEvent.MOUSE_OVER, fOver);
			_tOver = MouseEvent.MOUSE_OVER;
		}
		
		if(fOut){
			_alvo.addEventListener(MouseEvent.MOUSE_OUT, fOut);
			_tOut = MouseEvent.MOUSE_OUT;
		}
		
		//___________________________________________________ set some configs
		var obj:Object = {};
			obj.types = new Array(_tClick, _tOver, _tOut);
			obj.fns = new Array(fClick, fOver, fOut);
			_alvo.evt = obj;
			_bts.push(_alvo);
		}
		
		//________________________________________________________________________ DESTROY ITEM
		private static function destroyItem(_alvo:*):void
		{
			if(_alvo.types[2])_alvo.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT, true, false));
			_alvo.mouseChildren = true;
			_alvo.buttonMode = false;
			if(_alvo.types[0])_alvo.removeEventListener(_alvo.evt.types[0], _alvo.evt.fns[0]);
			if(_alvo.types[1])_alvo.removeEventListener(_alvo.evt.types[1], _alvo.evt.fns[1]);
			if(_alvo.types[2])_alvo.removeEventListener(_alvo.evt.types[2], _alvo.evt.fns[2]);
		}
		//_________________________________________________________________________ GET ARRAY WITH ALL BTS
		public static function getBts():Array{ return _bts;}
		//_________________________________________________________________________ DESTROY ITEM BY NAME
		public static function destroyByName(_name:String):void
		{
			var _total:Number = _bts.length;
			for (var i:int=0; i<_total; ++i) {
				if(_bts[i].name==_name){
					destroyItem(_bts[i]);
				}
			}
		}
		//_________________________________________________________________________ DESTROY ITEM BY ID
		public static function destroyById(_id:Number):void
		{
			var _total:Number = _bts.length;
			for (var i:int=0; i<_total; ++i) {
				if(_bts[i].id==_id){
					destroyItem(_bts[i]);
				}
			}
		}
		//_________________________________________________________________________ DESTROY ALL ITENS
		public static function destroy():void
		{
			var _total:Number = _bts.length;
			for (var i:int=0; i<_total; ++i) {
				destroyItem(_bts[i]);
			}
		}
		//_________________________________________________________________________ DISABLED All ITEMS BY ID
		public static function disabledById(_id:Number):void
		{
			var _total:Number = _bts.length;
			for (var i:int=0; i<_total; ++i) {
				if(_bts[i].id==_id){
					_bts[i].buttonMode = true;
					_bts[i].mouseEnabled = true;
				} else {
					_bts[i].buttonMode = false;
					_bts[i].mouseEnabled = false;
				}
			}
		}
		//_________________________________________________________________________ ENABLED All ITEMS BY ID
		public static function enabledById(_id:Number):void
		{
			var _total:Number = _bts.length;
			for (var i:int=0; i<_total; ++i) {
				if(_bts[i].id==_id){
					_bts[i].buttonMode = false;
					_bts[i].mouseEnabled = false;
				} else {
					_bts[i].buttonMode = true;
					_bts[i].mouseEnabled = true;
				}
			}
		}
	}
}
