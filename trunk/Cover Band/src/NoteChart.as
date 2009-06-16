package {
	import components.Note;
	
	import flash.events.*;
	import flash.net.*;
	
	public class NoteChart {
		private var _notes:Array;
		private var _numLanes:uint = 0;
		
		private var noteChartDisplay:NoteChartDisplay;
		
		public function NoteChart(chartFilename:String) {
			// Load the chart source file from the given filename.
			var loader:URLLoader = new URLLoader();
			configureURLLoaderListeners(loader);
			var request:URLRequest = new URLRequest("../src/charts/" + chartFilename + ".chart");
			try {
				loader.load(request);
			} catch (error:Error) {
				trace("Unable to load requested document.");
			}
		}
		
		/**
		 * Parse the chart file and create the note chart display and notes. 
		 * 
		 * @param chartData Lines from the chart file without newline characters.
		 * 
		 */
		private function parseChartData(chartData:Array):void {
			var tick:uint = 0;
			var curLine:String;
			
			var commentRE:RegExp = /#.*/;
			var multiplierRE:RegExp = /.*x[0-9]*/;
			
			for (var lineNum:uint = 0; lineNum < chartData.length; lineNum++) {
				var line:String = chartData[lineNum];
				var multiplier:uint = 1;
				
				// The number of lanes is a number at the beginning of the file.
				// Initialize the multi-dimensional Array of lanes X notes.
				if (lineNum == 0) {
					_numLanes = parseInt(line);
					_notes = new Array(_numLanes);
					for (var i:uint = 0; i < _numLanes; i++)
						_notes[i] = new Array();
						
					continue;
				}
				
				// Ignore comment lines.
				if (line.match(commentRE)) {
					trace("Comment detected");
					continue;
				}
				
				// Get the multiplier (number of times to execute this line).
				var match:Array = line.match(multiplierRE);
				if (match != null)
					multiplier = parseInt((match[0] as String).substr(1));
				
				// From here on out, each line should represent notes.
				// There must be at least as many notes as there are lanes.
				if (line.length < _numLanes)
					throw new Error("Invalid chart file");
				
				// Extract the note data multiple times.
				for (var mult:uint = 0; mult < multiplier; mult++) {
					for (var lane:uint = 0; lane < _numLanes; lane++) {
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
		
		private function addNote(tick, lane):void {
			var noteDisplay:Note = noteChartDisplay.createNoteDisplay(tick, lane);
			var note:Note = new Note(tick, lane, noteDisplay);
			(_notes[lane] as Array).push(note);
		}

		private function completeURLRequestHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			var chartData:Array = (loader.data as String).split("\n");
			
			// Remove newline characters.
			for (var i:uint = 0; i < chartData.length; i++) {
				var line:String = chartData[i];
				chartData[i] = line.substr(0, line.length - 1);
			}

			// Parse the file and create the note chart display and notes.
			parseChartData(chartData);
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
		
		private function get notes():Array {
			return _notes;
		}
		
		private function get numLanes():uint {
			return _numLanes;
		}
	}
}