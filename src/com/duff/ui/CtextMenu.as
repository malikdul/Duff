package com.duff.ui 
{
	import flash.display.MovieClip;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.net.navigateToURL;
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	

	public class CtextMenu
	{
		//_____________________________________________________________ VARS
		
		private static var _cm	: ContextMenu;
		private static var _link:String = "";
		
		//_____________________________________________________________ PUBLIC METHODS
		
		public static function build(_scope:*, texto:String, link:String):void
		{
			_link = link;
			setup(_scope);
			var pItem:ContextMenuItem = new ContextMenuItem(texto);
			pItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, linkH, false, 0, true);
			_cm.customItems.push(pItem);
			_scope.contextMenu = _cm;
		}
		
		//_____________________________________________________________ PRIVATE METHODS
		
		private static function linkH(e:ContextMenuEvent):void
		{
			navigateToURL(new URLRequest(_link), "_blank");
		}
		
		private static function setup(_scope:MovieClip):void
		{
			_cm = new ContextMenu();
			_cm.builtInItems.save = false;
			_cm.builtInItems.zoom = false;
			_cm.builtInItems.quality = false;
			_cm.builtInItems.play = false;
			_cm.builtInItems.loop = false;
			_cm.builtInItems.rewind = false;
			_cm.builtInItems.forwardAndBack = false;
			_cm.builtInItems.print = false;
			_scope.contextMenu = _cm;
		}
	}
}

