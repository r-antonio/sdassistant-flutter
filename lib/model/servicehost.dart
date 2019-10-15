import 'package:quiver/core.dart';

class ServiceHost {
  String name;
  String ip;
  int port;
  ServiceHost(this.name, this.ip, this.port);

  bool operator ==(o) => o is ServiceHost && o.ip == this.ip && o.port == this.port;

  int get hashCode => hash2(this.ip, this.port);
}