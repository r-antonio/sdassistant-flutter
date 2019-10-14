import 'package:grpc/grpc.dart';

class GrpcClientSingleton {
  ClientChannel client;
  String addr;
  int port;
  static final GrpcClientSingleton _singleton =
  GrpcClientSingleton._internal();

  factory GrpcClientSingleton(String addr) {
    var ipPort = addr.split(":");
    _singleton.addr = ipPort.elementAt(0);
    _singleton.port = int.parse(ipPort.elementAt(1));
    _singleton.client = ClientChannel(ipPort.elementAt(0),
        port: int.parse(ipPort.elementAt(1)),
        options: ChannelOptions(
          //TODO: Change to secure with server certificates
          credentials: ChannelCredentials.insecure(),
          connectionTimeout: Duration(seconds: 10),
          idleTimeout: Duration(minutes: 1),
        ));
    return _singleton;
  }

  GrpcClientSingleton._internal();
}