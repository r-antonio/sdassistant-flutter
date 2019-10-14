import 'dart:io';
import 'package:grpc/grpc.dart';
import 'package:sdassistant/common/grpc_commons.dart';
import 'package:sdassistant/model/sharing.pb.dart';
import 'package:sdassistant/model/sharing.pbgrpc.dart';

class SharingService {
  static Stream<Chunk> buffered(Stream<List<int>> source, int size) async* {
    List<int> partial = List();
    var first = true;
    var chunkSize = 0;
    await for (var chunk in source) {
      if (first) {
        chunkSize = chunk.length;
        first = false;
      }
      var diff = size-partial.length;
      if (chunk.length != chunkSize) {
        partial.addAll(chunk);
        Chunk c = Chunk();
        c.setField(1, partial);
        yield c;
      } else if (chunk.length < diff) {
        partial.addAll(chunk);
      } else {
        partial.addAll(chunk.sublist(0, diff));
        Chunk c = Chunk();
        c.setField(1, partial);
        partial = List<int>.from(chunk.sublist(diff));
        yield c;
      }
    }
  }

  static Chunk convert(List<int> input) {
    var c = Chunk();
    c.setField(1, input);
    return c;
  }

  static Future<Status> ShareLink(String addr, String url) async {
    var client = SharingServiceClient(GrpcClientSingleton(addr).client);
    Link l = Link();
    l.setField(1, url);
    return await client.shareLink(l);
  }

  static Future<Status> Upload(String addr, String path) async{
    var client = SharingServiceClient(GrpcClientSingleton(addr).client);
    var file = File(path);
    var stream = file.openRead();
    var chunkered = stream.map(convert);
    //var chunkered = buffered(stream, 655360);
    return await client.upload(chunkered, options: CallOptions(metadata: {'name': file.path.split("/").last}));
  }
}