package camu.loader
{
	import br.com.stimuli.loading.BulkProgressEvent;

	public class ResourceLoaderEvent extends BulkProgressEvent
	{
		public static const ITEM_COMPLETE:String = "ItemComplete";
		
		public static const SCENE_COMPLETE:String = "SceneComplete";
		
		
		private var _theId:String;
		
		public function ResourceLoaderEvent(name:String)
		{
			super(name);			
		}
		
		public function setTheId(id:String) : void
		{
			_theId = id;	
		}
		
		public function get theId() : String
		{
			return _theId;
		}
	}	
}
