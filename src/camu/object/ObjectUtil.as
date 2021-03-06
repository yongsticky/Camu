package camu.object
{
	import flash.utils.getQualifiedClassName;
	
	import camu.errors.AbstractClassError;
	import camu.object.interfaces.IObjectWithQualifiedClassName;

	public class ObjectUtil
	{
		public function ObjectUtil()
		{			
			throw new AbstractClassError();
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