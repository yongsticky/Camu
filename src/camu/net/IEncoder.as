package camu.net
{
	import flash.utils.ByteArray;

	public interface IEncoder
	{
		function encode(packet:Packet) : ByteArray;
	}
}