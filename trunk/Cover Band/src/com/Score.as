package com {
	import mx.core.UIComponent;
	
	[Bindable]
	public class Score {
		// Number of notes required to get to the next streak multiplier.
		private var NOTES_PER_STREAK_MULT:uint = 3;
		private var MAX_MULTIPLIER:uint = 4;

		private var _score:uint = 0;
		private var _totalNotesHit:uint = 0;
		private var _streak:uint = 0;
		private var _multiplier:uint = 1;
		
		public function Score() {
		}
		
		public function addToScore(note:Note):void {
			_score += _multiplier * note.score;
			_totalNotesHit++;
			streak++;
		}
		
		public function resetStreak():void {
			streak = 0;
		}
		
		//[Bindable]
		public function get score():uint {
			return _score;
		}
		
		public function set score(value:uint):void {
			_score = value;
		}
		
		//[Bindable]
		public function get totalNotesHit():uint {
			return _totalNotesHit;
		}
		
		public function set totalNotesHit(value:uint):void {
			_totalNotesHit = value;
		}
		
		//[Bindable]
		public function get streak():uint {
			return _streak;
		}
		
		public function set streak(value:uint):void {
			_streak = value;
			multiplier = _streak / NOTES_PER_STREAK_MULT + 1;
		}
		
		//[Bindable]
		public function get multiplier():uint {
			return _multiplier;
		}
		
		public function set multiplier(value:uint):void {
			_multiplier = Math.min(MAX_MULTIPLIER, value);
		}
	}
}