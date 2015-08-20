package camu.object
{
	import flash.utils.getQualifiedClassName;

	public class ObjectUtil
	{
		public function ObjectUtil()
		{
			throw new Error("ObjectUtil is a static class");
		}
		
		public static function getQualifiedSubclassName(value:*) : String
		{
			var key:String = null;		
			var obj:IObjectWithQualifiedSubclassNameMethod = value as IObjectWithQualifiedSubclassNameMethod;
			if (obj)
			{
				key = obj.getQualifiedSubclassName();
			}
			else
			{				
				key = getQualifiedClassName(value);
			}
			
			return key;
		}
	}
}