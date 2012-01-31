package com.duff.display 
{
	import com.duff.navigation.signals.ViewNavigatorSignal;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author borella
	 */
	public class SectionView extends Sprite 
	{

		public function destroy():void
		{
			ViewNavigatorSignal._CURRENT_VIEW_DESTROYED.dispatch();
		}
		
	}

}