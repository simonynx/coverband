package components {
	import flash.display.Shape;

	public class Note extends Shape {
		private const LINE_WIDTH:uint = 3;

		private var tick:uint;
		private var lane:uint;
		private var color:uint;
		
		// The default width and height properties don't like to be set to nonzero.
		private var _myWidth:Number;
		private var _myHeight:Number;
		
		public function Note(tick:uint, lane:uint, color:uint, x:Number, y:Number, width:Number, height:Number) {
			super();
			this.tick = tick;
			this.lane = lane;
			this.color = color;
			this.x = x;
			this.y = y;
			this._myWidth = width;
			this._myHeight = height;
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
		
		public function get myWidth():Number {
			return _myWidth;
		}
		
		public function get myHeight():Number {
			return _myHeight;
		}
	}
}