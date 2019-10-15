import 'package:grpc/grpc.dart';
import 'package:sdassistant/model/servicehost.dart';

class GrpcClientSingleton {
  ClientChannel client;

  static final GrpcClientSingleton _singleton =
  GrpcClientSingleton._internal();

  factory GrpcClientSingleton(ServiceHost host) {
    _singleton.client = ClientChannel(host.ip,
        port: host.port,
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