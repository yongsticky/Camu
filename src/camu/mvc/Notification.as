package camu.mvc
{
	public class Notification
	{
		protected var _name:String;
		protected var _data:Object; 
		
		public function Notification(name:String, data:Object)
		{
			setName(name);
			setData(data);
		}
		
		public function getName() : String
		{
			return _name;
		}
		
		protected function setName(name:String) : void
		{
			if (!name)
			{
				throw new Error("Parameter is null.");
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