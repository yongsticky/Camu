package camu.net
{		
	import flash.utils.getQualifiedClassName;

	public class Packet
	{
		protected const _eventTypePrefix:String = "PacketEvent_";
		protected var _eventType:String = null;
		
		public function Packet()
		{
			_eventType = _eventTypePrefix + getQualifiedClassName(this);			
		}
		
		public function get eventType():String
		{
			return _eventType;
		}		
	}
}