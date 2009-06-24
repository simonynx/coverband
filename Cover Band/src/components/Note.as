package components {
	import flash.display.Shape;

	public class Note extends Shape {
		private const LINE_WIDTH:uint = 3;


		private var lane:uint;
		private var color:uint;
		
		// The default width and height properties don't like to be set to nonzero.
		private var _myWidth:Number;
		private var _myHeight:Number;
		private var _enabled:Boolean = true;
		private var _tick:uint;
		private var _centerX:Number;
		private var _centerY:Number;
		
		// topLeftX and Y are aliases for the default x and y provided.
		private var _topLeftX:Number;
		private var _topLeftY:Number;
		
		public function Note(tick:uint, lane:uint, color:uint, width:Number,
			height:Number, x:Number = 0, y:Number = 0) {
			super();
			this._tick = tick;
			this.lane = lane;
			this.color = color;
			this._myWidth = width;
			this._myHeight = height;
			this.topLeftX = x;
			this.topLeftY = y;
		}
		
		public function draw():void {
			graphics.clear();
			
			if (visible) {
				//graphics.lineStyle(LINE_WIDTH, 0xffffff, 1);
				graphics.beginFill(color);
				graphics.drawRoundRect(0, 0, myWidth, myHeight, myWidth / 2, myWidth / 2);
				//graphics.drawRect(0, 0, myWidth, myHeight);
				graphics.endFill();
			}
		}
		
		public function highlight():void {
				graphics.beginFill(0xffffff);
				graphics.drawRoundRect(0, 0, myWidth, myHeight, myWidth / 2, myWidth / 2);
				graphics.endFill();
		}
		
		public function set centerX(value:Number):void {
			_centerX = value;
			topLeftX = _centerX - myWidth / 2.0;
		}
		
		public function get centerX():Number {
			return _centerX;
		}
		
		public function set centerY(value:Number):void {
			_centerY = value;
			topLeftY = _centerY - myHeight / 2.0;
		}
		
		public function get centerY():Number {
			return _centerY;
		}
		
		public function set topLeftX(value:Number):void {
			_topLeftX = value;
			_centerX = value + myWidth / 2.0;
			x = value;
		}
		
		public function set topLeftY(value:Number):void {
			_topLeftY = value;
			_centerY = value + myHeight / 2.0;
			y = value;
		}
		
		public function get myWidth():Number {
			return _myWidth;
		}
		
		public function get myHeight():Number {
			return _myHeight;
		}
		
		public function get tick():Number {
			return _tick;
		}
		
		public function set enabled(value:Boolean):void {
			_enabled = value;
		}
		
		public function get enabled():Boolean {
			return _enabled;
		}
	}
}