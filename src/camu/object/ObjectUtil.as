package camu.object
{
	import flash.utils.getQualifiedClassName;
	import camu.object.interfaces.IObjectWithQualifiedClassName;

	public class ObjectUtil
	{
		public function ObjectUtil()
		{
			throw new Error("ObjectUtil is a static class");
		}
		
		public static function getQualifiedClassName(value:*) : String
		{
			var key:String = null;		
			var obj:IObjectWithQualifiedClassName = value as IObjectWithQualifiedClassName;
			if (obj)
			{
				key = obj.getQualifiedClassName();
			}
			else
			{				
				key = flash.utils.getQualifiedClassName(value);
			}
			
			return key;
		}
	}
}