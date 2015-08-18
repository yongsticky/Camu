package camu.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class DefaultConnection extends EventDispatcher 
		implements IEncoder, IDecoder, IObjectHeap, ITickElapse, ISplitAssist
	{
		
		public static const ConnectionEvent_Connected:String = "ConnectionEvent_Connected";
		public static const ConnectionEvent_ServerClosed:String = "ConnectionEvent_ServerClosed";
		public static const ConnectionEvent_ClientClosed:String = "ConnectionEvent_ClientClosed";
		public static const ConnectionEvent_IoError:String = "ConnectionEvent_IoError";
		public static const ConnectionEvent_SecurityError:String = "ConnectionEvent_SecurityError";
		
		
		private var _socket:Socket = null;		
		
		private var _hostIP:String = null;
		private var _port:int = 0;
		
		private var _sendBuf:Vector.<IPacket> = null;				// 待发送的Packet
		private var _rawRecvBuf:Vector.<ByteArray> = null;		// 接收到的原始字节
		private var _recvBuf:Vector.<ByteArray> = null;			// 经过编排后的ByteArray
		
		
		// FSM
		public static const FS_SPLIT_BEGIN:int = 0;
		public static const FS_SPLIT_HEADER:int = 1;
		public static const FS_SPLIT_BODY:int = 2;
		public static const FS_SPLIT_ONE:int = 3;
		public static const FS_SPLIT_NEXT:int = 4;
		public static const FS_SPLIT_END:int = 5;
		private var _splitFSMState:int = FS_SPLIT_BEGIN;
		private var _splitOneBuf:ByteArray = null;		
		
		
		public function DefaultConnection()
		{
			_socket = new Socket();

		
			_sendBuf = new Vector.<IPacket>();
			_rawRecvBuf = new Vector.<ByteArray>();
			_recvBuf = new Vector.<ByteArray>();
			
			
			_socket.addEventListener(Event.CONNECT, onConnect);
			_socket.addEventListener(Event.CLOSE, onClose);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
		}
		
		// EVENT HANDLER
		protected function onConnect(event:Event):void
		{			
			dispatchEvent(new Event(ConnectionEvent_Connected));
		}
		
		protected function onClose(event:Event):void
		{
			dispatchEvent(new Event(ConnectionEvent_ServerClosed));
			
			destroy();
		}
		
		protected function onSocketData(event:ProgressEvent):void
		{
			var rawBytes:ByteArray = objectNew(ByteArray);
			rawBytes.endian = Endian.LITTLE_ENDIAN;
			rawBytes.length = _socket.bytesAvailable;
			_socket.readBytes(rawBytes, 0, _socket.bytesAvailable);
			_rawRecvBuf.push(rawBytes);
			
		}
		
		protected function onSecurityError(event:SecurityErrorEvent):void
		{			
			dispatchEvent(new Event(ConnectionEvent_SecurityError));
		}
		
		protected function onIoError(event:IOErrorEvent):void
		{			
			dispatchEvent(new Event(ConnectionEvent_IoError));
		}
		
				
		// PUBLIC METHOD
		public function setTargetAddress(hostIP:String, port:int) : void
		{
			_hostIP = hostIP;
			_port = port;			
		}
		
		public function connect() : void
		{
			if (!!_socket && !_socket.connected)
			{
				if (!!_hostIP && _port > 1024)
				{
					_socket.connect(_hostIP, _port);	
				}
			}
		}
		
		public function disconnect() : void
		{
			if (!!_socket)
			{
				if (_socket.connected)
				{
					_socket.close();			
				}
				
				dispatchEvent(new Event(ConnectionEvent_ClientClosed));
				
				destroy();
			}
		}
			
		
		// IEncoder
		public function encode(packet:IPacket) : ByteArray
		{
			return null;
		}
		
		// IDecoder
		public function decode(bytes:ByteArray) : IPacket
		{
			return null;	
		}
		
		// IObjectHeap
		public function objectNew(cls:Class) : *
		{
			return new cls();
		}
		
		public function objectDelete(obj:*) : void
		{
			obj = null;
		}
		
		//ITickElapse
		public function onTickElapse() : void
		{
			handleSendBuffer();			
			handleRawRecvBuffer();			
			handleRecvBuffer();
		}
		
		// IPacketSplitInfo
		public function getPacketHeaderLength() : int
		{
			return 0;
		}
		
		public function resolvePacketBodyLength(bytes:ByteArray) : int
		{
			return 0;
		}
		
		// 
		private function destroy() : void
		{
			_socket.removeEventListener(Event.CONNECT, onConnect);
			_socket.removeEventListener(Event.CLOSE, onClose);
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_socket.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			
			_socket = null;
			
			for (var i:IPacket in _sendBuf)
			{
				objectDelete(i);
			}
			_sendBuf.length = 0;
			
			for (var j:ByteArray in _recvBuf)
			{
				j.clear();
				objectDelete(j);
			}
			_recvBuf.length = 0;
			
			for (var k:ByteArray in _rawRecvBuf)
			{
				k.clear();
				objectDelete(k);
			}
			_rawRecvBuf.length = 0;
		}
		
		private function handleSendBuffer() : void
		{
			if (!_socket.connected)
			{
				return;
			}
			
			while (!!_sendBuf.length)
			{
				var packet:IPacket = _sendBuf.shift();
				if (packet)
				{
					var bytes:ByteArray = encode(packet);				
					if (!!bytes)
					{
						_socket.writeBytes(bytes);
						_socket.flush();
						
						bytes.clear();
						objectDelete(bytes);
					}
				
					objectDelete(packet);
				}				
			}
		}
		
		private function handleRawRecvBuffer() : void
		{
			SplitRawBufferFSM();
		}
		
		private function handleRecvBuffer() : void
		{
			while (!!_recvBuf.length)
			{
				var bytes:ByteArray = _recvBuf.shift();
				if (bytes)
				{
					var packet:IPacket = decode(bytes);
					if (packet)
					{
						var event:Event = packet as Event;
						if (event)
						{
							dispatchEvent(event);
						}
					
						objectDelete(packet);
					}
				}
				
				bytes.clear();
				objectDelete(bytes);			
			}
		}			

		private function SplitRawBufferFSM() : void
		{
			var headerLength:int = 0;
			var rawPacketBuf:ByteArray = null;
			while (true)
			{
				switch (_splitFSMState)
				{
					case FS_SPLIT_BEGIN:
						_splitFSMState = FS_SPLIT_NEXT;
						_splitOneBuf = objectNew(ByteArray);
						headerLength = getPacketHeaderLength();
						break;
					
					case FS_SPLIT_HEADER:
						var readHeaderSize:int = headerLength - _splitOneBuf.bytesAvailable;	
						if (readHeaderSize > 0)	// need read header
						{							
							if (readHeaderSize <= rawPacketBuf.bytesAvailable)	// read header complete
							{
								rawPacketBuf.readBytes(_splitOneBuf, _splitOneBuf.position, readHeaderSize);
								_splitFSMState = FS_SPLIT_BODY;
							}
							else	// header need more raw buffer
							{
								rawPacketBuf.readBytes(_splitOneBuf, _splitOneBuf.position, rawPacketBuf.bytesAvailable);
								_splitFSMState = FS_SPLIT_NEXT;
							}
						}
						else
						{
							_splitFSMState = FS_SPLIT_BODY;
						}
						break;
					
					case FS_SPLIT_BODY:
						var readBodySize:int = resolvePacketBodyLength(_splitOneBuf) + headerLength - _splitOneBuf.bytesAvailable;						
						if (readBodySize > 0)
						{
							if (readBodySize <= rawPacketBuf.bytesAvailable)
							{
								rawPacketBuf.readBytes(_splitOneBuf, _splitOneBuf.position, readBodySize);
								_splitFSMState = FS_SPLIT_ONE;
							}
							else
							{
								rawPacketBuf.readBytes(_splitOneBuf, _splitOneBuf.position, rawPacketBuf.bytesAvailable);
								_splitFSMState = FS_SPLIT_NEXT;
							}	
						}
						else if (readBodySize == 0)
						{
							_splitFSMState = FS_SPLIT_ONE;
						}
						else
						{
							throw new Error("FS_SPLIT_BODY Error. readBodySize < 0");
						}						
						break;
					
					case FS_SPLIT_ONE:
						_recvBuf.push(_splitOneBuf);
						_splitOneBuf = objectNew(ByteArray);
						if (rawPacketBuf.bytesAvailable == 0)
						{
							_splitFSMState = FS_SPLIT_NEXT;
						}
						else
						{
							_splitFSMState = FS_SPLIT_HEADER;
						}
						headerLength = getPacketHeaderLength();
						break;
					
					case FS_SPLIT_NEXT:
						if (_rawRecvBuf.length == 0)
						{
							_splitFSMState = FS_SPLIT_END;
						}
						else
						{
							rawPacketBuf = _rawRecvBuf.shift();
							if (rawPacketBuf.bytesAvailable == 0)
							{
								objectDelete(rawPacketBuf);
							}
							else
							{
								_splitFSMState = FS_SPLIT_HEADER;
							}
						}
						break;
					
					case FS_SPLIT_END:
						_splitFSMState = FS_SPLIT_BEGIN;
						return;
						
					default:
						throw new Error("FSM State Error. Unknown _splitFSMState");
				}
			}
		}
	}
}