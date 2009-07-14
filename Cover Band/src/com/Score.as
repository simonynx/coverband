package com {
	import mx.core.UIComponent;
	
	[Bindable]
	public class Score extends Object {
		// Number of notes required to get to the next streak multiplier.
		private var NOTES_PER_STREAK_MULT:uint = 3;
		private var MAX_MULTIPLIER:uint = 4;

		[Bindable(event="scoreChanged")]
		private var _score:uint = 0;
		private var _totalNotesHit:uint = 0;
		private var _streak:uint = 0;
		private var _multiplier:uint = 1;
		
		public function Score() {
			super();
		}
		
		public function addToScore(note:Note):void {
			score += _multiplier * note.score;
			totalNotesHit++;
			streak++;
		}
		
		public function resetStreak():void {
			streak = 0;
		}
		
		public function get score():uint {
			return _score;
		}
		
		public function set score(value:uint):void {
			_score = value;
		}
		
		public function get totalNotesHit():uint {
			return _totalNotesHit;
		}
		
		public function set totalNotesHit(value:uint):void {
			_totalNotesHit = value;
		}
		
		public function get streak():uint {
			return _streak;
		}
		
		public function set streak(value:uint):void {
			_streak = value;
			multiplier = _streak / NOTES_PER_STREAK_MULT + 1;
		}
		
		public function get multiplier():uint {
			return _multiplier;
		}
		
		public function set multiplier(value:uint):void {
			_multiplier = Math.min(MAX_MULTIPLIER, value);
		}
	}
}