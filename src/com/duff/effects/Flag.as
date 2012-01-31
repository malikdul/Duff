package com.duff.effects{
	
	import flash.display.MovieClip;
	import flash.filters.BitmapFilter;
	import flash.geom.Rectangle;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;

	
	/**
	 * @author borella
	 */
	 
	public class Flag extends MovieClip
	{
		
		//______________________________________________________________________ VARS
		
		private static var ORIGIN: Point = new Point();
		private static var IDENTITY: Matrix = new Matrix();
		
		private var sourceBMP: BitmapData;
		private var outputBMP: BitmapData;
		private var flagBMP: BitmapData;
		private var flagOffset: Point;
		
		private var perlinNoiseSeed: Number;
		private var perlinNoiseOffset: Array;
		private var perlinNoiseFallOff: BitmapData; 
		private var perlinNoiseBitmapData: BitmapData;
		
		private var displacement: DisplacementMapFilter;
		
		private var grayFilter: ColorMatrixFilter;
		private var lightBMP: BitmapData;
		private var lightContrast: ColorTransform;
		
		//______________________________________________________________________ CONSTRUCTOR
		
		public function Flag(inputBMP:BitmapData, width:Number = 0, height:Number = 0)
		{
			var w:Number = width || inputBMP.width;
			var h:Number = height || inputBMP.height;
			
			var sx:Number = w / inputBMP.width;
			var sy:Number = h / inputBMP.height;
			var mtrx:Matrix = new Matrix();
			mtrx.scale(sx, sy);
			sourceBMP = new BitmapData(w, h, true, 0);
			sourceBMP.draw(inputBMP, mtrx, null, null, null, true);
			
			outputBMP = new BitmapData((1.2 * w)>>0, (1.2 * h)>>0, true, 0);
			addChild(new Bitmap(outputBMP));
			
			assemble();
			var timer:Timer = new Timer(30, 0);
			timer.addEventListener(TimerEvent.TIMER,render);
			timer.start();
		}
		
		//______________________________________________________________________ PRIVATE METHODS
		
		private function assemble(): void
		{
			var w:Number = outputBMP.width;
			var h:Number = outputBMP.height;
			
			flagBMP = new BitmapData( w, h, true, 0 );
			flagOffset = new Point( 0.1 * sourceBMP.width, 0.1 * sourceBMP.height );
			
			createGrayFilter();
			createPerlinNoiseFallOffGradient();
			flagBMP.copyPixels( sourceBMP, sourceBMP.rect, flagOffset );
			perlinNoiseBitmapData = new BitmapData( w, h, false, 0 );
			perlinNoiseOffset = [ new Point(), new Point() ];
			perlinNoiseSeed = Math.floor( Math.random() * 256 );
			displacement = new DisplacementMapFilter( perlinNoiseBitmapData, ORIGIN, 2, 4, 0.125 * sourceBMP.width, 0.2 * sourceBMP.height, 'ignore');
			lightBMP = new BitmapData( w, h, true, 0 );
			lightContrast = new ColorTransform( 4, 4, 4, 1, 0, 0, 0, 0 );
		}
		
		private function createGrayFilter(): void
		{
			grayFilter = new ColorMatrixFilter(
				[
					0, 0, .55, 0, 0,
					0, 0, .55, 0, 0,
					0, 0, .55, 0, 0,
					0, 0, .55, 0, 0
				]
			);
		}
		
		private function createPerlinNoiseFallOffGradient(): void
		{
			var w:Number = outputBMP.width;
			var h:Number = outputBMP.height;
			perlinNoiseFallOff = new BitmapData( w, h, true, 0 );
			var shape: Shape = new Shape();
			var gradientBox: Matrix = new Matrix();
			gradientBox.createGradientBox(w - flagOffset.x, h, 0, flagOffset.x, 0);
			var canvas:Graphics=shape.graphics;
			canvas.beginGradientFill( 'linear', [ 0x008080, 0x008080 ], [ 99, 0 ], [ 0, 0x60 ], gradientBox );
			canvas.drawRect(0,0,w,h);
			canvas.endFill();
			perlinNoiseFallOff.draw( shape );
		}
		
		private function render(event:TimerEvent):void	
		{
			var outputRect:Rectangle = outputBMP.rect;
			outputBMP.fillRect( outputRect, 0 );
			perlinNoiseOffset[0].x -= .04 * sourceBMP.width;
			perlinNoiseOffset[1].x -= .03 * sourceBMP.height;
			perlinNoiseBitmapData.perlinNoise( 0.618 * sourceBMP.width, 0.618 * sourceBMP.height, 2, perlinNoiseSeed, 
												false, true, 6, false, perlinNoiseOffset );
			perlinNoiseBitmapData.copyPixels( perlinNoiseFallOff, outputRect, ORIGIN, perlinNoiseFallOff, ORIGIN, true );
			outputBMP.applyFilter( flagBMP, outputRect, ORIGIN, BitmapFilter(displacement) );
			lightBMP.copyPixels( perlinNoiseBitmapData, outputRect, ORIGIN, outputBMP, ORIGIN );
			lightBMP.applyFilter( lightBMP, outputRect, ORIGIN, grayFilter );
			outputBMP.draw( lightBMP, IDENTITY, lightContrast, 'multiply' );
			event.updateAfterEvent();
		}
		
	}
}
