package camu.net
{
	import flash.utils.getQualifiedClassName;

	public class PacketEventTypeUtil
	{
		public function PacketEventTypeUtil()
		{
			throw new Error("Abstract class, , you must extned it.");
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