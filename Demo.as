package  {
	
	import flash.display.MovieClip;
	import tjenkinson.aniHelper.AniHelper;
	import flash.text.TextField;
	import tjenkinson.aniHelper.TweenerParams;
	import flash.events.Event;
	
	public class Demo extends MovieClip {
		
		// stage instanves
		public var t1:TextField;
		public var t2:TextField;
		public var t3:TextField;
		
		// create an instance of AniHelper which will manage the animations.
		// if you have several groups of stage objects that should be animated independantly of each other then you can create several of these.
		private var a1:AniHelper = new AniHelper();
		
		public function Demo() {
			
			// make sure that the elements on the stage have loaded before continuing
			if (!stage) {
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			else {
				onAddedToStage();
			}
		}
		
		public function onAddedToStage(e:Event=null)
		{
			// In this example you need to imagine that each of the calls to runGroup could happen at any time (from any function).
			// They could run from different INVOKE commands sent from CasparCG (http://casparcg.com/) for example.
			
			// run a group of animations
			// The first paramater requires an array. Each element of this array contains another array containing the TweenerParams for all the animations that should run at that point.
			// The paramaters for TweenerParams are identical to the ones on http://hosted.zeh.com.br/tweener/docs/en-us/ as this is what actually runs the tween.
			// The second paramater (optional) is an array containing the same amount of items as the outer array in the first paramater. Each element must be a boolean and true (default) means that if a new animation sequence has been called this one can be left before the tween(s) corresponding to this element are executed. False means that this tween must happen and the new sequence must wait.
			a1.runGroup([
						 	[
							 	// these tweens will run at the same time
							 	new TweenerParams(t1, {x: 0, time:5, transition:"linear"}),
								new TweenerParams(t2, {x: 0, time:4, transition:"linear"})
							],
							[
							 	// this tween will wait until the longer of the first 2 tweens has finished before starting
							 	new TweenerParams(t3, {x:0, time:2, transition:"linear"})
							],
						], [false, false]); // the 2 falses mean that the first and second part of the group must always be executed and cannot be interupted by a future runGroup call. The future runGroup call will wait.
						
						
						
			a1.runGroup([
						 	[
							 	// these tweens will run at the same time but will wait until all the tweens above have finished
							 	new TweenerParams(t1, {x: 400, time:1, transition:"linear"}),
								new TweenerParams(t2, {x: 300, time:3, transition:"linear"})
							],
							[
							 	new TweenerParams(t3, {x: 300, time:2, transition:"linear"})
							],
						], [false, true]); // the second part here is now optional and will not be executed if another runGroup has been called and is waiting.
						
						
			a1.runGroup([
						 	[
							 	// these tweens will not start after the first part of the last set of tweens has completed. The second part of the last group of tweens will not run for the reason explained above.
							 	new TweenerParams(t1, {y: 0, time:1, transition:"linear"}),
								new TweenerParams(t2, {y: 0, time:3, transition:"linear"})
							],
							[
							 	new TweenerParams(t3, {y: 0, time:2, transition:"linear", onComplete: function() {trace("onComplete handlers still work like normal.");}})
							],
						], [true, true]); // both these are true meaning if another runGroup was called it would start as soon as the current tween ends.
		}
	}
	
}
