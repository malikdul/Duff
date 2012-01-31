package com.duff.utils.display{
	import flash.geom.Point;
	import flash.geom.PerspectiveProjection;

	/**
	 * @author borella
	 */

	public class Reset3DRelativePoint
	{
		
		public static function start(target:*):void
		{
			target.transform.perspectiveProjection = new PerspectiveProjection();
			target.transform.perspectiveProjection.projectionCenter = new Point(target.x, target.y);
		}
		
	}
}
