/**
 Copyright 2009 Ben Longoria
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
package com {
	import mx.core.UIComponent;
	
	import flash.events.*;
	
	import com.enefekt.tubeloc.MovieSprite;
	import com.enefekt.tubeloc.event.*;
	
	/**
	 * Example class for MovieSprite class and the chromeless player
	 *
	 * @author Ben Longoria enefekt@gmail.com
	 */
	[SWF(backgroundColor="#FFFFFF")]
	public class MainChromeless extends UIComponent {
		private var youtubeMovie:MovieSprite;
		
		public function MainChromeless() {
			youtubeMovie = new MovieSprite(null, true);
			youtubeMovie.addEventListener(PlayerReadyEvent.PLAYER_READY, onPlayerReady);
			youtubeMovie.x = 10;
			youtubeMovie.y = 10;
			addChild(youtubeMovie);
		}
		
		private function onPlayerReady(event_p:PlayerReadyEvent):void {
			youtubeMovie.width = 640;
			youtubeMovie.height = 480;
			youtubeMovie.loadVideoById("7tTNOX8jfno");
		}
	}
}