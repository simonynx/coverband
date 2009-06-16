package components {
	import flash.display.Shape;

	public class Note extends Shape {
		private const LINE_WIDTH:uint = 3;

		private var tick:uint;
		private var lane:uint;
		private var color:uint;
		
		// The default width and height properties don't like to be set to nonzero.
		private var myWidth:Number;
		private var myHeight:Number;
		
		public function Note(tick:uint, lane:uint, color:uint, x:Number, y:Number, width:Number, height:Number) {
			super();
			this.tick = tick;
			this.lane = lane;
			this.color = color;
			this.x = x;
			this.y = y;
			this.myWidth = width;
			this.myHeight = height;
		}
		
		public function draw():void {
			graphics.clear();
			
			if (visible) {
				//graphics.lineStyle(LINE_WIDTH, 0xffffff, 1);
				graphics.beginFill(color);
				//graphics.drawRoundRect(0, 0, myWidth - LINE_WIDTH, myHeight - LINE_WIDTH, myWidth / 3, myWidth / 3);
				graphics.drawRect(0, 0, myWidth, myHeight);
				graphics.endFill();
			}
		}
	}
}