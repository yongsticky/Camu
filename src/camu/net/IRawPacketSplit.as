package camu.net
{
	import flash.utils.ByteArray;

	public interface IRawPacketSplit
	{
		function getPacketHeaderLength() : int;
		function resolvePacketBodyLength(bytes:ByteArray) : int;
	}
}