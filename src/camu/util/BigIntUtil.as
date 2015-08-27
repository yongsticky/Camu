package camu.util
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class BigIntUtil
	{
		public function BigIntUtil()
		{
		}
	
	
	
		public static function writeBigInt(bytes:ByteArray, valueL:uint, valueH:uint) : void
		{			
			if (bytes.endian == Endian.BIG_ENDIAN)
			{
				bytes.writeUnsignedInt(valueH);
				bytes.writeUnsignedInt(valueL);
			}
			else if (bytes.endian == Endian.LITTLE_ENDIAN) 
			{
				bytes.writeUnsignedInt(valueL);
				bytes.writeUnsignedInt(valueH);				
			}
			else
			{
				throw new Error("Wrong Endian.");				
			}			
		}
		
		/*
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
		}*/
	}
}