package camu.view.starling
{	
	import flash.utils.Dictionary;

	import starling.display.DisplayObject;


	public class ExScene extends ExSprite
	{		
		protected var _id:String;
		protected static var _dictScene:Dictionary = new Dictionary(); 

		public static function getScene(id:String) : ExScene
		{
			if (_dictScene.hasOwnProperty(id))
			{
				return _dictScene[id];
			}
			else
			{
				return null;
			}
		}

		public static function disposeScene(id:String) : void
		{
			var scene:ExScene = getScene(id);
			if (scene)
			{
				scene.dispose();
				delete _dictScene[id];
			}
		}

		public function ExScene(id:String)
		{
			if (getScene(id))
			{
				throw new Error("Scene(" + id + ") already exist.");
			}

			_dictScene[id] = this;
		}

		override protected function initialize() : void
		{
			super.initialize();
		}

		public function get id() : String
		{
			return _id;
		}

		public function addLayer(name:String, layer:ExLayer) : ExLayer
		{
			if (layer)
			{
				layer.name = name;
				addChild(layer);
			}

			return layer;
		}

		public function addLayerAt(name:String, layer:ExLayer, index:int) : ExLayer
		{
			if (layer)
			{
				layer.name = name;
				addChildAt(layer, index);
			}

			return layer;
		}

		public function getLayerAt(index:int) : ExLayer
		{
			var child:DisplayObject = getChildAt(index);
			return child as ExLayer;
		}

		public function getLayerByName(name:String) : ExLayer
		{
			var child:DisplayObject = getChildByName(name);
			return child as ExLayer;
		}

		public function getLayerIndex(layer:ExLayer) : int
		{
			return getChildIndex(layer);
		}

		public function removeLayer(layer:ExLayer, dispose:Boolean = false) : ExLayer
		{			
			var child:DisplayObject = removeChild(layer, dispose);
			return child as ExLayer;
		}

		public function removeLayerAt(index:int, dispose:Boolean = false) : ExLayer
		{
			var child:DisplayObject = removeChildAt(index, dispose);
			return child as ExLayer;
		}

		public function removeLayers(beg:int, end:int, dispose:Boolean = false) : void
		{
			removeChildren(beg, end, dispose);
		}

		public function pauseAnimation() : void
		{
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var layer:ExLayer = getChildAt(i) as ExLayer;
				if (layer)
				{
					layer.pauseAnimation();
				}
			}
		}

		public function resumeAnimation() : void
		{
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var layer:ExLayer = getChildAt(i) as ExLayer;
				if (layer)
				{
					layer.resumeAnimation();
				}
			}
		}		
	}
}