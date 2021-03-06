package camu.net
{
	import flash.utils.getQualifiedClassName;
	
	import camu.errors.AbstractClassError;

	public class PacketEventTypeUtil
	{
		public function PacketEventTypeUtil()
		{			
			throw new AbstractClassError();
		}
		
		private static const _eventTypePrefix:String = "PacketEvent#";
		
		public static function getEventTypeByClass(cls:Class) : String
		{
			return _eventTypePrefix + getQualifiedClassName(cls);
		}
		
		public static function getEventTypeByObject(obj:Packet) : String
		{
			return _eventTypePrefix + getQualifiedClassName(obj);			
		}
	}
}