package camu.mvc
{
	import camu.errors.NullObjectError;

	public class Notification
	{
		protected var _name:String;
		protected var _data:Object; 
		
		public function Notification()
		{
		}
		
		public function getName() : String
		{
			return _name;
		}
		
		protected function setName(name:String) : void
		{
			if (!name)
			{
				throw new NullObjectError();
			}
			
			_name = name;
		}
		
		public function getData() : Object
		{			
			return _data;
		}
		
		protected function setData(data:Object) : void
		{			
			_data = data ? data:{};
		}
	}
}