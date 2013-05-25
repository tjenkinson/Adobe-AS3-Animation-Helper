package tjenkinson.aniHelper {
	
	
	public class TweenerParams {
		
		private var element:Object;
		private var options:Object;
		
		public function TweenerParams(a:Object, b:Object) {
			element = a;
			options = b;
		}
		
		public function getElement():Object {
			return element;
		}
		
		public function getOptions():Object {
			return options;
		}
	}
}