package camu.util
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class ShortIntUtil
	{
		public function ShortIntUtil()
		{
		}
		
		public static function writeShortInt(bytes:ByteArray, value:int) : void
		{
			var low:int = value & 0xFF;
			var high:int = (value>>8) & 0xFF;
			if (bytes.endian == Endian.BIG_ENDIAN)
			{
				bytes.writeByte(high);
				bytes.writeByte(low);
			}
			else if (bytes.endian == Endian.LITTLE_ENDIAN) 
			{
				bytes.writeByte(low);
				bytes.writeByte(high);
			}
			else
			{
				throw new Error("Wrong Endian.");				
			}
		}
		
		public static function readShortInt(bytes:ByteArray) : int
		{
			if (bytes.bytesAvailable >= 2)
			{
				var low:int = bytes.readByte();
				var high:int = bytes.readByte();
				
				if (bytes.endian == Endian.BIG_ENDIAN)
				{				
					return int((low<<8) | high);
				}
				else if (bytes.endian == Endian.LITTLE_ENDIAN)
				{
					return int((high<<8) | low);
				}
				else
				{
					throw new Error("Wrong Endian.");
				}	
			}
			else
			{
				throw new Error("bytesAvailable not enough.");
			}			
		}
		
		public static function Test() : void
		{
			var bytes:ByteArray = new ByteArray();
			var bytes2:ByteArray = new ByteArray();
			
			bytes.endian = Endian.BIG_ENDIAN;
			bytes2.endian = Endian.BIG_ENDIAN;
			
			bytes.writeInt(0x11223344);			// HIGH -> LOW  0x11 0x22 0x00 0x00
			writeShortInt(bytes2, 0x1122);
			
			bytes2.position = 0;
			
			trace(readShortInt(bytes2));
			
			
			
						
			bytes.clear();
			bytes2.clear();
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes2.endian = Endian.LITTLE_ENDIAN;
			
			bytes.writeInt(0x11223344);		// HIGH -> LOW 0x00 0x00 0x22 0x11 
			writeShortInt(bytes2, 0x1122);
			
			bytes2.position = 0;
			trace(readShortInt(bytes2));
			
		}
	}
}