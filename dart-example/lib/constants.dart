import 'dart:io';

extension StorageConstants on Platform {
  static String get cephObjectGatewayHost =>
      Platform.environment['CEPH_OBJECT_GATEWAY_HOST']!;
}
