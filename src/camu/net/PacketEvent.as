package camu.net
{
	import flash.events.Event;
	
	
	public class PacketEvent extends Event// implements IObjectInit
	{
		protected var _packet:Packet;
		
		public function PacketEvent(packet:Packet)
		{
			super(packet.eventType);
		}
		
		public function set packet(packet:Packet) : void
		{
			_packet = packet;
		}
		
		public function get packet() : Packet
		{
			return _packet;
		}
	}
}