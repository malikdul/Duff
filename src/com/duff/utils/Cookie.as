﻿package com.duff.utils {	import flash.external.ExternalInterface;public class Cookie{	//_____________________________________________________________ PUBLIC METHODS	public static function getCookie(cookieName:String):String	{		var r:String = "";		var search:String = cookieName + "=";		var js:String = "function get_cookie(){return document.cookie;}";		var o:Object = ExternalInterface.call(js);		var cookieVariable:String = o.toString();		if (cookieVariable.length > 0)		{			var offset:int = cookieVariable.indexOf(search);			if (offset != -1)			{				offset += search.length;				var end:int = cookieVariable.indexOf(";", offset);				if (end == -1)					end = cookieVariable.length;				r = unescape(cookieVariable.substring(offset, end));			}		}		return r;	}		public static function setCookie(cookieName:String, cookieValue:String):void	{		var js:String = "function sc(){";		js += "var c = escape('" + cookieName + "') + '=' + escape('" + cookieValue + "') + '; path=/';";		js += "document.cookie = c;";		js += "}";		ExternalInterface.call(js);	}	}}