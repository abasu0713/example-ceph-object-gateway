import 'dart:io';

import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';

final defaultCephBucketScope = AWSCredentialScope(
  region: 'default',
  service: AWSService.s3,
);

extension StorageConstants on Platform {
  static String get cephObjectGatewayHost =>
      Platform.environment['CEPH_OBJECT_GATEWAY_HOST']!;
}
