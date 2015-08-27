package camu.net
{
	import camu.object.IObjectCreator;
	
	public class PacketEventCreator implements IObjectCreator
	{
		public function PacketEventCreator()
		{
		}
		
		public function createObject(...args):*
		{
			if (args.length == 1)
			{
				return new PacketEvent(args[0]);
			}
			else
			{
				throw new Error("Arguments Error.");
			}
		}
		
		public function setCreatedData(obj:*, ...args) : void
		{			
			var packetEvent:PacketEvent = obj as PacketEvent;
			if (packetEvent)
			{
				if (args.length == 1)
				{
					packetEvent.packet = args[0];
				}
				else
				{
					throw new Error("Arguments Error.");
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