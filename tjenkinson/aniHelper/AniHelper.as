// created by Tom Jenkinson to help create complex animation sequences.
// Thanks go to the developers at https://code.google.com/p/tweener/ for making this possible.
package tjenkinson.aniHelper {
	
	import caurina.transitions.Tweener
	import caurina.transitions.*;
	
	public class AniHelper {
		
		private var groupsQueue:Vector.<Group> = new Vector.<Group>();
		private var currentGroup:Group = null;
		private var currentAnimation:uint = 0;
		private var animationsRunning:uint = 0;
		
		public function AniHelper() {}
		
		public function runGroup(tweenersA:Array, breakPointsA:Array):void {
			
			// generate the vectors from the arrays
			var tweeners:Vector.<Vector.<TweenerParams>> = new Vector.<Vector.<TweenerParams>>(tweenersA.length, true);
			for (var i:int; i<tweenersA.length; i++) {
				tweeners[i] = Vector.<TweenerParams>(tweenersA[i]);
			}
			var breakPoints:Vector.<Boolean> = Vector.<Boolean>(breakPointsA);
			
			groupsQueue.push(new Group(tweeners, breakPoints));
			if (currentGroup == null) {
				currentGroup = getNextGroup();
				currentAnimation = 0;
				animate();
			}
		}
		
		private function getNextGroup():Group {
			var group:Group = groupsQueue.length > 0 ? groupsQueue[0] : null;
			if (group != null) {
				groupsQueue.splice(0, 1);
			}
			return group;
		}
		
		private function animate():void {
			
			if (animationsRunning != 0) {
				return;
			}
			
			if (currentAnimation >= currentGroup.getTotalAnimations()) {
				currentGroup = getNextGroup();
				if (currentGroup != null) {
					currentAnimation = 0;
					animate();
				}
				return;
			}
			var animation:Animation = currentGroup.getAnimation(currentAnimation);
			if (animation.getBreakPoint() && groupsQueue.length > 0) {
				currentGroup = getNextGroup();
				currentAnimation = 0;
				animate();
				return;
			}
			
			var tParams:Vector.<TweenerParams> = animation.getTweenerParams();
			
			for (var i:int=0; i<tParams.length; i++) {
				var options:Object = tParams[i].getOptions();
				if (options.onComplete != null) {
					var originalOnComplete:Function = options.onComplete;
					var originalOnCompleteParams:Array = options.onCompleteParams;
					options.onCompleteParams = [];
					var originalScope:Object = options.onCompleteScope;
					options.onCompleteScope = this;
					
					options.onComplete = function() {
						originalOnComplete.apply(originalScope, originalOnCompleteParams);
						animationCompleted();
					};
				}
				else {
					options.onComplete = function() {
						animationCompleted();
					};
				}
				animationsRunning++;
				Tweener.addTween(tParams[i].getElement(), options);
			}
			currentAnimation++;
		}
		
		private function animationCompleted():void {
			animationsRunning--;
			animate();
		}
		
	}
}

import tjenkinson.aniHelper.TweenerParams;

class Group {
	
	private var animations:Vector.<Animation>;
	
	public function Group(a:Vector.<Vector.<TweenerParams>>, b:Vector.<Boolean>=null) {
		if (b == null) {
			b = new Vector.<Boolean>;
			for(var i:int=0; i<a.length; i++) {
				b.push(false);
			}
		}
		
		if (b.length != a.length) {
			throw new Error("The number of break points didn't match the number of tween operations.");
		}
		animations = new Vector.<Animation>(a.length, true);
		for(var i:int=0; i<a.length; i++) {
			animations[i] = new Animation(a[i], b[i]);
		}
	}
	
	public function getAnimation(a:uint) {
		return animations[a];
	}
	
	public function getTotalAnimations():uint {
		return animations.length;
	}
	
}

class Animation {
	
	private var tweenerParams:Vector.<TweenerParams>;
	private var breakPoint:Boolean;
	
	public function Animation(a:Vector.<TweenerParams>, b:Boolean) {
		tweenerParams = a;
		breakPoint = b;
	}
	
	public function getTweenerParams():Vector.<TweenerParams> {
		return tweenerParams;
	}
	
	public function getBreakPoint():Boolean {
		return breakPoint;
	}
}
