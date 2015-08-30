package camu.net
{
	public class Packet
	{		
		protected var _eventType:String = null;
		
		public function Packet()
		{
			_eventType = PacketEventTypeUtil.getEventTypeByObject(this);					
		}
		
		public function get eventType():String
		{
			return _eventType;
		}
	}
}