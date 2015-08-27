package camu.net
{
	import flash.utils.ByteArray;

	public interface IRawPacketSplit
	{
		// 包头的长度，包头要包括能获取到包体长度的直接或间接数据
		function getPacketHeaderLength() : int;

		// 获取包体的长度
		function resolvePacketBodyLength(bytes:ByteArray) : int;		
	}
}