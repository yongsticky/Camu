package camu.net
{
	import flash.utils.ByteArray;

	public interface IDecoder
	{
		function decode(bytes:ByteArray) : IPacket;
	}
}