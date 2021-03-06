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
	
	import camu.errors.AbstractFunctionError;
	import camu.errors.UnhandledBranchError;
	import camu.errors.ZeroLittleError;
	import camu.logger.ILogger;
	import camu.logger.LEVEL;
	import camu.logger.Logger;
	

	public class Connector extends EventDispatcher
	{	
		protected var _logger:ILogger;
		
		private var _socket:Socket = null;		
		
		private var _hostIP:String = null;
		private var _port:int = 0;
		
		private var _sendBuf:Vector.<Packet> = null;				// 待发送的Packet
		private var _rawRecvBuf:Vector.<ByteArray> = null;		// 接收到的原始包
		private var _recvBuf:Vector.<ByteArray> = null;			// 经过编排后的Packet
		
		
		// FSM
		public static const FS_SPLIT_BEGIN:int = 0;
		public static const FS_SPLIT_HEADER:int = 1;
		public static const FS_SPLIT_BODY:int = 2;
		public static const FS_SPLIT_ONE:int = 3;
		public static const FS_SPLIT_NEXT:int = 4;
		public static const FS_SPLIT_END:int = 5;
		private var _splitFSMState:int = FS_SPLIT_BEGIN;
		private var _splitOneBuf:ByteArray = null;		
		
		
		public function Connector()
		{
			_logger = Logger.createLogger(Connector, LEVEL.WARNING);
			
			_socket = new Socket();

		
			_sendBuf = new Vector.<Packet>();
			_rawRecvBuf = new Vector.<ByteArray>();
			_recvBuf = new Vector.<ByteArray>();
			
			// for debug
			//loadFakeRecvData(_recvBuf);
			
			
			_socket.addEventListener(Event.CONNECT, onConnect);
			_socket.addEventListener(Event.CLOSE, onClose);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
		}
		
		// EVENT HANDLER
		protected function onConnect(event:Event):void
		{
			_logger.log(this, "onConnect", LEVEL.DEBUG);
			
			dispatchEvent(new ConnectorEvent(ConnectorEvent.CONNECTED));
		}
		
		protected function onClose(event:Event):void
		{
			_logger.log(this, "onClose", LEVEL.DEBUG);
			
			dispatchEvent(new ConnectorEvent(ConnectorEvent.SERVER_CLOSED));
			
			destroy();
		}
		
		protected function onSocketData(event:ProgressEvent):void
		{
			_logger.log(this, "onSocketData", LEVEL.INFO);

			var rawBytes:ByteArray = newObject(ByteArray);
			rawBytes.endian = Endian.BIG_ENDIAN;
			rawBytes.length = _socket.bytesAvailable;
			_socket.readBytes(rawBytes, 0, _socket.bytesAvailable);			
			_rawRecvBuf.push(rawBytes);		
		}
		
		protected function onSecurityError(event:SecurityErrorEvent):void
		{
			_logger.log(this, "onSecurityError", LEVEL.ERROR);

			dispatchEvent(new ConnectorEvent(ConnectorEvent.SECURITY_ERROR));
		}
		
		protected function onIoError(event:IOErrorEvent):void
		{
			_logger.log(this, "onIoError", LEVEL.ERROR);

			dispatchEvent(new ConnectorEvent(ConnectorEvent.IO_ERROR));
		}
		
		protected function loadFakeRecvData(recvBuf:Vector.<ByteArray>) : void
		{
			
		}
		
				
		// PUBLIC METHOD
		public function setTargetAddress(hostIP:String, port:int) : void
		{			
			_hostIP = hostIP;
			_port = port;
			
			_logger.log(this, "setTargetAddress ip:[", _hostIP, "], port:[", port.toString(), "]", LEVEL.INFO);	
		}
		
		public function connect() : void
		{
			_logger.log(this, "user call connect.", LEVEL.INFO);

			if (_socket && !_socket.connected)
			{
				if (_hostIP && _port > 1024)
				{
					_logger.log(this, "connect to server.", LEVEL.DEBUG);
					_socket.connect(_hostIP, _port);	
				}
				else
				{
					_logger.log(this, "Server Address Wrong.", LEVEL.ERROR);
				}
			}
		}
		
		public function disconnect() : void
		{
			_logger.log(this, "user call disconnect.", LEVEL.INFO);
			
			if (_socket)
			{
				if (_socket.connected)
				{
					_socket.close();			
				}
				
				dispatchEvent(new ConnectorEvent(ConnectorEvent.CLIENT_CLOSED));
				
				destroy();
			}
		}
		
		public function send(packet:Packet) : void
		{			
			if (packet)
			{		
				_sendBuf.push(packet);
				
				_logger.log(this, "send, push packet into send buffer.", LEVEL.DEBUG);
			}
		}
		
		//ITickElapse
		public function advanceTime(time:Number) : void
		{
			handleSendBuffer();			
			handleRawRecvBuffer();			
			handleRecvBuffer();
		}
			
		
		// IEncoder
		protected function encode(packet:Packet) : ByteArray
		{
			throw new AbstractFunctionError();
		}
		
		// IDecoder
		protected function decode(bytes:ByteArray) : Packet
		{
			throw new AbstractFunctionError();
		}
				
		protected function newObject(cls:Class, data:* = null) : *
		{
			throw new AbstractFunctionError();
		}
		
		protected function deleteObject(obj:*) : void
		{
			throw new AbstractFunctionError();
		}
				
		protected function getPacketHeaderLength() : int
		{
			throw new AbstractFunctionError();
		}
		
		protected function resolvePacketBodyLength(bytes:ByteArray) : int
		{
			throw new AbstractFunctionError();
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
			
			for (var packet:Packet in _sendBuf)
			{
				deleteObject(packet);
			}
			_sendBuf.length = 0;
			
			for (var j:ByteArray in _recvBuf)
			{
				j.clear();
				deleteObject(j);
			}
			_recvBuf.length = 0;
			
			for (var k:ByteArray in _rawRecvBuf)
			{
				k.clear();
				deleteObject(k);
			}
			_rawRecvBuf.length = 0;
		}
		
		private function handleSendBuffer() : void
		{
			if (!_socket || !_socket.connected)
			{
				return;
			}
						
			while (_sendBuf.length)
			{
				_logger.log(this, "handleSendBuffer, _sendBuf length:",_sendBuf.length, LEVEL.DEBUG);
				
				var packet:Packet = _sendBuf.shift();
				if (packet)
				{
					var bytes:ByteArray = encode(packet);				
					if (bytes)
					{					
						_logger.log(this, "handleSendBuffer, writeBytes length=", bytes.bytesAvailable, LEVEL.DEBUG);						
												
						_socket.writeBytes(bytes, 0, bytes.bytesAvailable);						
						_socket.flush();
						
						bytes.clear();
						deleteObject(bytes);
					}
				
					deleteObject(packet);
				}				
			}
		}
		
		protected function dispatchPacketEvent(packet:Packet) : void
		{	
			
			var event:PacketEvent =  new PacketEvent(packet);
						
			if (event)
			{
				_logger.log(this, "dispatchPacketEvent eventType=[", packet.eventType, "]", LEVEL.INFO);
				
				dispatchEvent(event);
				
				event = null;
			}
		}
		
		private function handleRawRecvBuffer() : void
		{
			if (_rawRecvBuf.length > 0)
			{
				SplitRawBufferFSM();
			}
		}
		
		private function handleRecvBuffer() : void
		{
			while (_recvBuf.length)
			{
				_logger.log(this, "handleRecvBuffer, recvBuf length=", _recvBuf.length.toString(), LEVEL.DEBUG);
				
				var bytes:ByteArray = _recvBuf.shift();
				if (bytes)
				{
					var packet:Packet = decode(bytes);
					if (packet)
					{
						dispatchPacketEvent(packet);
						
						deleteObject(packet);
					}
					
					bytes.clear();
					deleteObject(bytes);
				}							
			}
		}			

		private function SplitRawBufferFSM() : void
		{
			_logger.log(this, "SplitRawBufferFSM", LEVEL.DEBUG);

			var headerLength:int = 0;
			var rawPacketBuf:ByteArray = null;
			while (true)
			{
				switch (_splitFSMState)
				{
					case FS_SPLIT_BEGIN:						
						_splitFSMState = FS_SPLIT_NEXT;
						if (!_splitOneBuf)
						{							
							_splitOneBuf = newObject(ByteArray);
						}
						_logger.log(this, "FSMState = BEGIN, goto NEXT", LEVEL.DEBUG);
						break;

					case FS_SPLIT_HEADER:
						_logger.log(this, "FSMState = HEADER, _splitOneBuf.length = ", _splitOneBuf.length, LEVEL.DEBUG);
						var readHeaderSize:int = getPacketHeaderLength() - _splitOneBuf.length;
						if (readHeaderSize > 0)	// need read size
						{
							_logger.log(this, "FSMState = HEADER, completely header need read size = ", readHeaderSize, LEVEL.DEBUG);							
							if (readHeaderSize <= rawPacketBuf.bytesAvailable)	// can read header complete?
							{
								_logger.log(this, "FSMState = HEADER,  length enough for completely header, read and goto BODY", LEVEL.DEBUG);
								rawPacketBuf.readBytes(_splitOneBuf, _splitOneBuf.position, readHeaderSize);
								_splitOneBuf.position += readHeaderSize;
								_splitFSMState = FS_SPLIT_BODY;								
							}
							else	// header need more raw buffer
							{
								_logger.log(this, "FSMState = HEADER,  length not enough for completely header, read and goto NEXT", LEVEL.DEBUG);
								rawPacketBuf.readBytes(_splitOneBuf, _splitOneBuf.position, rawPacketBuf.bytesAvailable);
								_splitOneBuf.position += rawPacketBuf.bytesAvailable;
								_splitFSMState = FS_SPLIT_NEXT;								
							}
						}
						else
						{
							_logger.log(this, "FSMState = HEADER,  header is complete already, goto BODY", LEVEL.DEBUG);
							_splitFSMState = FS_SPLIT_BODY;
						}
						break;
					
					case FS_SPLIT_BODY:
						_logger.log(this, "FSMState = BODY, _splitOneBuf.length = ", _splitOneBuf.length, LEVEL.DEBUG);
						var readBodySize:int = resolvePacketBodyLength(_splitOneBuf) + getPacketHeaderLength() - _splitOneBuf.length;
						if (readBodySize > 0)	// need read size
						{
							_logger.log(this, "FSMState = BODY, completely body need read size = ", readBodySize, LEVEL.DEBUG);
							if (readBodySize <= rawPacketBuf.bytesAvailable)		// can read body complete?
							{
								_logger.log(this, "FSMState = BODY,  length enough for completely body, read and goto ONE", LEVEL.DEBUG);
								rawPacketBuf.readBytes(_splitOneBuf, _splitOneBuf.position, readBodySize);
								_splitOneBuf.position += readBodySize;
								
								_splitFSMState = FS_SPLIT_ONE;								
							}
							else
							{
								if (rawPacketBuf.bytesAvailable > 0)
								{
									rawPacketBuf.readBytes(_splitOneBuf, _splitOneBuf.position, rawPacketBuf.bytesAvailable);
									_splitOneBuf.position += rawPacketBuf.bytesAvailable;								
								}

								_logger.log(this, "FSMState = BODY, length not enough for completely body, read and goto NEXT", LEVEL.DEBUG);
								_splitFSMState = FS_SPLIT_NEXT;
							}
						}
						else if (readBodySize == 0)
						{
							_logger.log(this, "FSMState = BODY, completely body already, goto ONE", LEVEL.DEBUG);
							_splitFSMState = FS_SPLIT_ONE;
						}
						else
						{							
							throw new ZeroLittleError();
						}
						break;
					
					case FS_SPLIT_ONE:
						_logger.log(this, "FSMState = ONE, push packet into recvBuf.", LEVEL.DEBUG);
						_splitOneBuf.position = 0;
						_recvBuf.push(_splitOneBuf);						
						_splitOneBuf = newObject(ByteArray);
						if (rawPacketBuf.bytesAvailable == 0)
						{
							_logger.log(this, "FSMState = ONE, rawPacketBuf empty, goto NEXT", LEVEL.DEBUG);
							_splitFSMState = FS_SPLIT_NEXT;
						}
						else
						{
							_logger.log(this, "FSMState = ONE, rawPacketBuf remain some data, goto HEADER", LEVEL.DEBUG);
							_splitFSMState = FS_SPLIT_HEADER;
						}						
						break;
					
					case FS_SPLIT_NEXT:						
						if (_rawRecvBuf.length == 0)
						{							
							_splitFSMState = FS_SPLIT_END;

							_logger.log(this, "FSMState = NEXT, _rawRecvBuf.length = 0, goto END", LEVEL.DEBUG);
						}
						else
						{
							rawPacketBuf = _rawRecvBuf.shift();							
							_splitFSMState = FS_SPLIT_HEADER;

							_logger.log(this, "FSMState = NEXT, shift 1 rawPacketBuf, goto HEADER", LEVEL.DEBUG);							
						}
						break;
					
					case FS_SPLIT_END:
						_logger.log(this, "FSMState = END, return.", LEVEL.DEBUG);
						_splitFSMState = FS_SPLIT_BEGIN;
						return;
						
					default:
						throw new UnhandledBranchError();						
				}
			}
		}
	}
}