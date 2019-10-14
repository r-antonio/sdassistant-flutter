import 'dart:io';
import 'package:multicast_dns/multicast_dns.dart';

class MulticastDNSService {
  static Future<List<String>> GetServices(String serviceName) async {
    final MDnsClient client = MDnsClient();
    await client.start();

    List<String> result = [];
    List<NetworkInterface> ifaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
    ifaces = ifaces.where((iface) => iface.name.startsWith("wlan")).toList();
    print(ifaces);
    await for (PtrResourceRecord ptr in client
        .lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(serviceName))) {

      print(ptr.domainName);
      await for (SrvResourceRecord srv in client
          .lookup<SrvResourceRecord>(ResourceRecordQuery.service(ptr.domainName))) {

        final String bundleId = ptr.domainName;
        print('Dart observatory instance found at: '
          '${srv.target}:${srv.port} for "$bundleId"');

        await for (IPAddressResourceRecord arec in client.lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv4(srv.target))) {
          print('IP found: ${arec.address.host}');
          result.add('${arec.address.host}:${srv.port}');
          break;
        }
      }
    }

    client.stop();
    return result.toSet().toList();
  }
}