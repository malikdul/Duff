package com.duff.utils
{

	import flash.external.ExternalInterface;
	import flash.display.Sprite;
	

	public class SwfResize extends Sprite
	{
		
		private const JS_CODE:String = "function swfSelfResizeGetNode(){var nodeId='###';return document.getElementById(nodeId)}function swfSelfResizeResize(height,width){var node=swfSelfResizeGetNode();if(node){node.style.height=height+'px';node.style.width=width+'px'}}function swfSelfResizeAddHeight(addValue){swfSelfResizeResize((swfSelfResizeGetHeight()+parseInt(addValue)),swfSelfResizeGetWidth())}function swfSelfResizeAddWidth(addValue){swfSelfResizeResize(swfSelfResizeGetHeight(),(swfSelfResizeGetWidth()+parseInt(addValue)))}function swfSelfResizeGetHeight(){var node=swfSelfResizeGetNode();if(node.currentStyle)var height=node.currentStyle['height'];else if(window.getComputedStyle)var height=document.defaultView.getComputedStyle(node,null).getPropertyValue('height');return parseInt(height,10)}function swfSelfResizeGetWidth(){var node=swfSelfResizeGetNode();if(node.currentStyle)var width=node.currentStyle['width'];else if(window.getComputedStyle)var width=document.defaultView.getComputedStyle(node,null).getPropertyValue('width');return parseInt(width,10)}";
		private const JS_PATTERN:RegExp = /###/g;
	
		private var latestHeight:int;
		private var latestWidth:int;
		
		private static var _instance:SwfResize;
		
		// internal id to identify match
		private var swfId:String;
		
		public static function getInstance():SwfResize{
			if (!SwfResize._instance) SwfResize._instance = new SwfResize(new SingletonObligate());
			return SwfResize(SwfResize._instance);
		}
		
		
		public function SwfResize(singleton:SingletonObligate){}
		
		public function init():void
		{
			if( this.available() ){
				this.swfId = ExternalInterface.objectID; 
				
				// define callback handler
				ExternalInterface.addCallback("getSWFId",this.getSWFId);
				
				// injekt js code
				ExternalInterface.call("eval", this.getJSCode() );
			}
		}
		
	
		private function getJSCode():String{
			return this.JS_CODE.replace( this.JS_PATTERN, this.swfId );
		}
		
		/**
		 * @private
		 *  
		 * returns the internal swfid
		 * @return internal swfid
		 */
		public function getSWFId():String{
			return this.swfId;
		}
		 
		/**
		 * returns if this class is available, because ExternalInterface is equired 
		 * @return returns if this class is available
		 */
		public function available():Boolean{
			return ExternalInterface.available;
		}
		
		/**
		 * resizes the flash container to needed dimensions 
		 * @param height - new needed height 
		 * @param width - new needed with
		 */
		public function resize( height:int, width:int ):void{
			this.latestHeight = height;
			this.latestWidth = width;
			
			if( this.available() ){
				ExternalInterface.call("swfSelfResizeResize",height,width);
			}
		}
		
		/**
		 * adds a specific value (+/-) to current height
		 * @param valueHeight
		 */
		public function addHeight( valueHeight:int ):void{
			if( this.available() ){
				ExternalInterface.call("swfSelfResizeAddHeight",valueHeight);
			}	
		}
		
		/**
		 * adds a specific value (+/-) to current width
		 * @param valueHeight
		 */
		public function addWidth( valueWidth:int ):void{
			if( this.available() ){
				ExternalInterface.call("swfSelfResizeAddWidth",valueWidth);
			}
		}
		
		/**
		 * returns the current height of the flash container 
		 * @return current height of the flash container 
		 */		
		public function getCurrentHeight():int{
			if( this.available() ){
				return ExternalInterface.call("swfSelfResizeGetHeight");
			}else return -1;
		}	
		
		/**
		 * returns the current width of the flash container 
		 * @return current width of the flash container 
		 */	
		public function getCurrentWidth():int{
			if( this.available() ){
				return ExternalInterface.call("swfSelfResizeGetWidth");
			}else return -1;
		}
		
	}
}
class SingletonObligate {}