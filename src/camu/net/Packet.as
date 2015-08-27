package camu.net
{	
	import flash.utils.ByteArray;
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
		
		// IEncoder
		public function encode(bytes:ByteArray) : Boolean
		{
			throw new Error("Abstract function!");
		}
		
		// IDecoder
		public function decode(bytes:ByteArray) : Boolean
		{
			throw new Error("Abstract function!");
		}
	}
}