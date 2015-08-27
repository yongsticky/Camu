package camu.net
{
	import camu.object.IObjectCreator;
	
	public class PacketEventCreator implements IObjectCreator
	{
		public function PacketEventCreator()
		{
		}
		
		public function createObject(data:*):*
		{
			
			if (data is Packet)
			{
				return new PacketEvent(data);
			}
			else
			{
				throw new Error("Invalide Parameter.");
			}
		}
		
		public function setCreatedData(obj:*, data:*) : void
		{			
			var packetEvent:PacketEvent = obj as PacketEvent;
			if (packetEvent)
			{
				if (data is Packet)
				{
					packetEvent.packet = data;
				}
				else
				{
					throw new Error("Invalide Parameter.");
				}
			}
			else
			{
				throw new Error("Class Type Error.");
			}
		}
		
		public function destoryObject(obj:*):void
		{
			
		}
	}
}