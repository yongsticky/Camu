package camu.net
{
	import flash.events.Event;
	
	
	public class PacketEvent extends Event
	{
		protected var _packet:Packet;
		
		public function PacketEvent(packet:Packet)
		{
			super(packet.eventType);
			_packet = packet;
		}
		
		public function set packet(packet:Packet) : void
		{
			_packet = packet;
		}
		
		public function get packet() : Packet
		{
			return _packet;
		}
		
		override public function clone() : Event
		{
			var e:PacketEvent = super.clone() as PacketEvent;
			e._packet = this._packet;
			
			return e;			
		}
	}
}