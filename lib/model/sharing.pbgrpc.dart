///
//  Generated code. Do not modify.
//  source: sharing.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'sharing.pb.dart' as $0;
export 'sharing.pb.dart';

class SharingServiceClient extends $grpc.Client {
  static final _$upload = $grpc.ClientMethod<$0.Chunk, $0.Status>(
      '/SharingService/Upload',
      ($0.Chunk value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Status.fromBuffer(value));
  static final _$shareLink = $grpc.ClientMethod<$0.Link, $0.Status>(
      '/SharingService/ShareLink',
      ($0.Link value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Status.fromBuffer(value));

  SharingServiceClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.Status> upload($async.Stream<$0.Chunk> request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$upload, request, options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Status> shareLink($0.Link request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$shareLink, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class SharingServiceBase extends $grpc.Service {
  $core.String get $name => 'SharingService';

  SharingServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Chunk, $0.Status>(
        'Upload',
        upload,
        true,
        false,
        ($core.List<$core.int> value) => $0.Chunk.fromBuffer(value),
        ($0.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Link, $0.Status>(
        'ShareLink',
        shareLink_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Link.fromBuffer(value),
        ($0.Status value) => value.writeToBuffer()));
  }

  $async.Future<$0.Status> shareLink_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Link> request) async {
    return shareLink(call, await request);
  }

  $async.Future<$0.Status> upload(
      $grpc.ServiceCall call, $async.Stream<$0.Chunk> request);
  $async.Future<$0.Status> shareLink($grpc.ServiceCall call, $0.Link request);
}
