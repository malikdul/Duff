package com.duff.utils
{
   import flash.external.ExternalInterface;

	public class QueryString {
		
		//_____________________________________________________________ VARS
		private var _queryString:String;
		private var _all:String;
		private var _params:Object;
	   
		//_____________________________________________________________ GET/SET
		public function get queryString():String{ return _queryString;}
		public function get url():String{return _all;}
		public function get parameters():Object{return _params;}               
	  
		//_____________________________________________________________ CONSTRUCTOR
		public function QueryString() 
		{
		   readQueryString();
		}
		
		//_____________________________________________________________ PRIVATE METHODS
		private function readQueryString():void
		{
		   _params = {};
		   
		   if (ExternalInterface.available) {
			   
			   _all =  ExternalInterface.call("window.location.href.toString");
			   _queryString = ExternalInterface.call("window.location.search.substring", 1);
			   
			   if(_queryString){
				   var params:Array = _queryString.split('&');
				   var length:uint = params.length; 
				   
				   for (var i:uint=0,index:int=-1; i<length; i++){
					   var kvPair:String = params[i];
					   if((index = kvPair.indexOf("=")) > 0){
						   var key:String = kvPair.substring(0,index);
						   var value:String = kvPair.substring(index+1);
						   _params[key] = value;
					   }
				   }
			   }
		   }
		   
		}
		
	}
}
