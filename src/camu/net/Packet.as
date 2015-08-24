package camu.net
{
	import flash.events.Event;	
	import flash.utils.getQualifiedClassName;

	public class Packet extends Event
	{
		protected const _eventTypePrefix:String = "PacketEvent_";
		protected var _eventType:String = null; 
		
		
		public function Packet()
		{
			_eventType = _eventTypePrefix + getQualifiedClassName(this);
			super(_eventType);
		}
		
		public function get eventType():String
		{
			return _eventType;
		}
	}
}