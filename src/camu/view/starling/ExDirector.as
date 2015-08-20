package camu.view.starling
{		
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;

	public class ExDirector extends ExSprite
	{			
		public function ExDirector()
		{			
		}
		
		override protected function initialize() : void
		{
			super.initialize();			
		}
		
		override public function dispose() : void
		{
			super.dispose();
		}

		
		public function switchToScene(scene:ExScene) : void
		{			
			if (!scene)
			{
				return;
			}

			setSceneFadeInOut(scene, 0, 255, 1, Transitions.LINEAR, function () : void {
				removeChildren(0, numChildren-2, true);	
				});
			
			addChild(scene);
		}

		
		public function pushScene(scene:ExScene) : void
		{
			if (!scene)
			{
				return;
			}

			setSceneFadeInOut(scene, 0, 255, 1);

			addChild(scene);		
		}
		
		public function popScene() : ExScene
		{
			var popScene:ExScene = topScene;

			if (numChildren > 1)
			{
				var newTopScene:ExScene = getChildAt(numChildren-2) as ExScene;
				if (newTopScene)
				{
					setSceneFadeInOut(newTopScene, 0, 255, 1, Transitions.LINEAR, function() : void {
						removeChildAt(numChildren-2);
						});
				}

				swapChildrenAt(numChildren-1, numChildren-2);
			}
			else
			{
				removeChildAt(numChildren-1);
			}

			return popScene;
		}
		
		public function get topScene() : ExScene
		{
			var scene:ExScene = getChildAt(this.numChildren-1) as ExScene;
			return scene;			
		}

		private function setSceneFadeInOut(scene:ExScene, alphaFrom:Number, alphaTo:Number, time:Number, 
			transition:String = Transitions.LINEAR, completeHandler:Function = null) : void
		{
			scene.alpha = alphaFrom;

			var tn:Tween = new Tween(scene, time);
			tn.fadeTo(alphaTo);
			tn.transition = transition; 
			Starling.juggler.add(tn);
			if (completeHandler)
			{
				tn.onComplete = completeHandler;
			}			
		}
		
	}
}