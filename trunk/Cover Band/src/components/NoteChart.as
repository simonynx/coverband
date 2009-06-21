package components {
	import flash.display.Shape;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.getTimer;
	
	import mx.core.UIComponent;
	import mx.managers.IFocusManagerComponent;
	
	public class NoteChart extends UIComponent implements IFocusManagerComponent {
		public static const RED:uint = 0xff0000;
		public static const YELLOW:uint = 0xffff00;
		public static const BLUE:uint = 0x0000ff;
		public static const GREEN:uint = 0x00ff00;
		public static const ORANGE:uint = 0xff9900;
		
		public static const DRUMS:uint = 0;
		public static const GUITAR:uint = 1;
		public static const BASS:uint = 2;
		public static const LANE_COLORS:Array = [
			[RED, YELLOW, BLUE, GREEN, ORANGE],
			[GREEN, RED, YELLOW, BLUE, ORANGE],
			[GREEN, RED, YELLOW, BLUE, ORANGE]];
		
		private const LINE_WIDTH:uint = 2;
		private const LINE_COLOR:uint = 0xffffff;
		private const HEIGHT_RATIO:Number = 0.5;
		
		private const MILLISECONDS_PER_TICK:Number = 1000.0/10.0;
		private const SECONDS_PER_TICK:Number = MILLISECONDS_PER_TICK / 1000.0;
		private const TICKS_PER_SECOND:Number = 1.0 / SECONDS_PER_TICK;
		
		private var _backgroundColor:uint = 0x000000;
		private var _laneWidth:Number;
		private var _chartFilename:String;
		private var _paused:Boolean = true;
		
		private var instrument:uint;
		private var notes:Array;
		private var numLanes:uint = 0;
		private var prevTime:int = 0;
		private var curTick:Number = 0;

		/**
		 * Not much to do here.  Most of the initialization happens in init
		 * and finishInit, which deal with URL requests to get the necessary
		 * data.  init must be called separately.
		 * 
		 */		
		public function NoteChart() {
			super();
			// The rest of the functionality is handled by init.
		}
		
		/**
		 * Perform the real initialization here.  NoteChart depends on data
		 * that isn't present at creation time.  A lot of the work is passed
		 * off to completeURLRequestHandler since the rest depends on the chart
		 * file first being loaded.
		 * 
		 */		
		public function init(instrument:uint):void {
			this.instrument = instrument;
			
			var loader:URLLoader = new URLLoader();
			configureURLLoaderListeners(loader);
			
			var chartPath:String = "../src/charts/" + _chartFilename + ".chart";
			trace("Attempting to load chart file: " + chartPath);
			var request:URLRequest = new URLRequest(chartPath);
				
			try {
				loader.load(request);
			} catch (error:Error) {
				trace("Unable to load requested document.");
			}
		}
		
		/**
		 * Finish the initialization that couldn't be done without the chart
		 * file data.
		 *  
		 * @param chartData Array of strings representing lines in the chart
		 * file.
		 * 
		 */		
		public function finishInit(chartData:Array):void {
			// Parse the file and create the notes.
			parseChartData(chartData);
			
			// Add the graphical lane lines.
			var numLines:uint = numLanes + 1;
			for(var lineNum:uint = 0; lineNum < numLines; lineNum++) {
				var lineShape:Shape = new Shape();
				
				// Add one pixel to make everything line up properly.
				var x:uint = lineNum * (_laneWidth + LINE_WIDTH) + 1;
				lineShape.graphics.lineStyle(LINE_WIDTH, LINE_COLOR, 1, true);
				lineShape.graphics.moveTo(x, 0);
				lineShape.graphics.lineTo(x, height);
				
				addChild(lineShape);
			}
			
			focusManager.setFocus(this);
			// Setup the main updating event handler.
			addEventListener(Event.ENTER_FRAME, update);
			prevTime = getTimer();
		}
		
		/**
		 * Start (unpause) the game.
		 * 
		 */		
		public function play():void {
			_paused = false;
		}
		
		/**
		 * Pause the game.
		 * 
		 */		
		public function pause():void {
			_paused = true;
		}
		
		
		private var frames:uint = 0;
		[Bindable]
		public var fps:Number = 0;
		/**
		 * Main game updating logic.  Called each frame.
		 * 
		 */
		private function update(event:Event):void {
			var curTime:int = getTimer();
			var diffTime:int = curTime - prevTime;
			var ticks:Number = diffTime / MILLISECONDS_PER_TICK;
			curTick += ticks;
			prevTime = curTime;
			
			if (!_paused) {
				for each (var lane:Array in notes) {
					for each (var note:Note in lane) {
						// FIXME: Pull this mult out of the loop.
						note.y += ticks * note.myHeight;
						note.draw();
					}
				}
			}
			
			frames++;
			if (frames % 10 == 0) fps = 1.0 / (diffTime / 1000.0);
		}
		
		/**
		 * Unravel the chart file data and pass it to finishInit.
		 * 
		 * @param event Event containing the chart file data from the URL
		 * request.
		 * 
		 */		
		private function completeURLRequestHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			
			// Remove newlines (\n) and carriage returns (\r).  Do this in two
			// stages since the file may not contain carriage returns.
			var chartData:Array = (loader.data as String).split("\n");
			for (var i:uint = 0; i < chartData.length; i++)
				chartData[i] = (chartData[i] as String).replace("\r", "");
			
			finishInit(chartData);
		}
		
		/**
		 * Placeholder for now.
		 * 
		 */		
		override protected function createChildren():void {
		}

		/**
		 * Parse the chart file and create notes. 
		 * 
		 * @param chartData Lines from the chart file without newline
		 * characters.
		 * 
		 */
		private function parseChartData(chartData:Array):void {
			var tick:uint = 0;
			var curLine:String;
			
			var commentRE:RegExp = /\s*#.*/;
			var blankLineRE:RegExp = /^\s*$/;
			var multiplierRE:RegExp = /x[0-9]*/;
			
			for (var lineNum:uint = 0; lineNum < chartData.length; lineNum++) {
				var line:String = chartData[lineNum];
				var multiplier:uint = 1;
				
				// The number of lanes is a number at the beginning of the file.
				// Initialize the multi-dimensional Array of lanes X notes.
				if (lineNum == 0) {
					numLanes = parseInt(line);
					var numLines:uint = numLanes + 1;
					
					_laneWidth = (width - numLines * LINE_WIDTH) / numLanes;
					notes = new Array(numLanes);
					for (var i:uint = 0; i < numLanes; i++)
						notes[i] = new Array();
						
					continue;
				}
				
				trace(line);
				
				if (line.match(commentRE) || line.match(blankLineRE)) {
					trace("Comment or blank line detected");
					continue;
				}
				
				// Get the multiplier (number of times to execute this line).
				var searchIndex:int = line.search(multiplierRE);
				if (searchIndex != -1) {
					var substring:String = line.substr(searchIndex);
					trace("Found multiplier: " + substring);
					multiplier = parseInt(substring.substr(1));
				}
				
				// From here on out, each line should represent notes.
				// There must be at least as many notes as there are lanes.
				if (line.length < numLanes)
					throw new Error("Invalid chart file");
				
				// Extract the note data multiple times.
				for (var mult:uint = 0; mult < multiplier; mult++) {
					for (var lane:uint = 0; lane < numLanes; lane++) {
						var char:String = line.charAt(lane);
						
						if (char == '-')		// Blank note.
							continue;
						else if (char == 'n')	// Regular note.
							addNote(tick, lane);
						else					// TODO: Add more stuff!
							continue;
					}
					
					tick++;
				}
			}
		}
		
		private function addNote(tick:uint, lane:uint):void {
			var noteWidth:Number = _laneWidth;
			var noteHeight:Number = noteWidth * HEIGHT_RATIO;
			
			// +2 so everything lines up properly.
			var x:Number = lane * (LINE_WIDTH + _laneWidth) + 2;
			var y:Number = -(tick * noteHeight);
			var note:Note = new Note(tick, lane, LANE_COLORS[instrument][lane], x, y, noteWidth, noteHeight);
			(notes[lane] as Array).push(note);
			addChild(note);
		}
		
		private function configureURLLoaderListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, completeURLRequestHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            /*
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            */
		}
        
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event.text);
		}
		
		public function get paused():Boolean {
			return _paused;
		}
		
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
		}
		
		public function set chartFilename(value:String):void {
			_chartFilename = value;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			graphics.clear();
			graphics.beginFill(_backgroundColor, alpha);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
		}
	}
}