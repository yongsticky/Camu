package camu.net
{
	import flash.utils.ByteArray;

	public interface ISplitAssist
	{
		function getPacketHeaderLength() : int;
		function resolvePacketBodyLength(bytes:ByteArray) : int;
	}
}