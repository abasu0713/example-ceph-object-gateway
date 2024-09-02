import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:dart_example/constants.dart';
import 'package:xml/xml.dart';

extension StorageOps on AWSSigV4Signer {
  Future<Map<String, dynamic>> cephListObjectsV2(
      {required String bucketName,
      String? prefix,
      bool gatewayWithVirtualHosting = false,
      bool signAll = false}) async {
    print(
        'In function cephListObjectsV2: bucketName: $bucketName, prefix: $prefix');
    if (StorageConstants.cephObjectGatewayHost.isEmpty) {
      print('Ceph Object Gatewat host is not set');
      throw Exception('Ceph Object Gatewat host is not set');
    }
    try {
      // final bucketName = StorageConstants.bucketName;
      final host = "https://${StorageConstants.cephObjectGatewayHost}";
      final serviceConfiguration = S3ServiceConfiguration();
      AWSHttpRequest listObjectsV2Request;
      if (gatewayWithVirtualHosting) {
        listObjectsV2Request = AWSHttpRequest(
          method: AWSHttpMethod.get,
          uri: Uri.parse('$host/?list-type=2&prefix=$prefix'),
          headers: {
            AWSHeaders.host: '$bucketName.$host',
          },
        );
      } else {
        listObjectsV2Request = AWSHttpRequest(
          method: AWSHttpMethod.get,
          uri: Uri.parse('$host/$bucketName/?list-type=2&prefix=$prefix'),
          headers: {},
        );
      }
      // final signedUrl = await presign(
      //   listObjectsV2Request,
      //   credentialScope: defaultCephBucketScope,
      //   serviceConfiguration: serviceConfiguration,
      //   expiresIn: const Duration(seconds: 10),
      // );
      final signedUrl = await sign(listObjectsV2Request,
          credentialScope: defaultCephBucketScope,
          serviceConfiguration: serviceConfiguration);
      print('Signed ListObjectsV2 URL: $signedUrl');
      final response = await signedUrl.send().response;
      print(response.statusCode);
      final responseBody = await response.decodeBody();
      // print(responseBody);
      final document = XmlDocument.parse(responseBody);
      final keys = document.findAllElements('Key');

      final filenames = keys.map((keyElement) => keyElement.innerText).toList();
      print(filenames);
      return {};
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }
}
