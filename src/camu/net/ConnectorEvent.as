package camu.net
{
	import flash.events.Event;

	public class ConnectorEvent extends Event
	{
		public static const CONNECTED:String = "connected";
		public static const SERVER_CLOSED:String = "server_closed";
		public static const CLIENT_CLOSED:String = "client_closed";
		public static const IO_ERROR:String = "io_error";
		public static const SECURITY_ERROR:String = "security_error";

		public function ConnectorEvent(name:String)
		{
			super(name);
		}
	}
}