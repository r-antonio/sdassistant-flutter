///
//  Generated code. Do not modify.
//  source: sharing.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class StatusCode extends $pb.ProtobufEnum {
  static const StatusCode Unknown = StatusCode._(0, 'Unknown');
  static const StatusCode Ok = StatusCode._(1, 'Ok');
  static const StatusCode Failed = StatusCode._(2, 'Failed');

  static const $core.List<StatusCode> values = <StatusCode> [
    Unknown,
    Ok,
    Failed,
  ];

  static final $core.Map<$core.int, StatusCode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static StatusCode valueOf($core.int value) => _byValue[value];

  const StatusCode._($core.int v, $core.String n) : super(v, n);
}

