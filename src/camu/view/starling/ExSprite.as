package camu.view.starling
{
	import starling.display.Sprite;
	import starling.events.Event;

	public class ExSprite extends Sprite
	{
		public function ExSprite()
		{
			stage ? initialize():addEventListener(Event.ADDED_TO_STAGE, function (event:Event) : void {
				event.target.removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
				initialize();
			});
		}

		protected function initialize() : void
		{
		}
	}
}