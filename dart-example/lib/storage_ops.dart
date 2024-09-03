import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:dart_example/constants.dart';
import 'package:xml/xml.dart';

extension StorageOps on AWSSigV4Signer {
  // Extension method to list objects in a bucket using the ListObjectsV2 API
  // and optionally sign them as well
  Future<Map<String, dynamic>> cephListObjectsV2(
      {required String bucketName,
      String? prefix,
      bool signAll = false}) async {
    if (StorageConstants.cephObjectGatewayHost.isEmpty) {
      throw Exception('Ceph Object Gatewat host is not set');
    }
    var result = <String, dynamic>{};
    try {
      final host = "https://${StorageConstants.cephObjectGatewayHost}";
      final serviceConfiguration = S3ServiceConfiguration();
      prefix ??= '';
      final listObjectsV2Request = AWSHttpRequest(
          method: AWSHttpMethod.get,
          uri: Uri.parse('$host/$bucketName/?list-type=2&prefix=$prefix'));
      final signedUrl = await sign(listObjectsV2Request,
          credentialScope: defaultCephBucketScope,
          serviceConfiguration: serviceConfiguration);
      final response = await signedUrl.send().response;
      final responseBody = await response.decodeBody();
      final document = XmlDocument.parse(responseBody);
      final keys = document.findAllElements('Key');

      final objectKeys =
          keys.map((keyElement) => keyElement.innerText).toList();
      // print(objectKeys);
      result['objectKeys'] = objectKeys;
      if (signAll) {
        var presignedUrls = [];
        for (var objectKey in objectKeys) {
          final getObjectRequest = AWSHttpRequest(
            method: AWSHttpMethod.get,
            uri: Uri.parse('$host/$bucketName/$objectKey'),
          );
          final signedGetObjectUrl = await presign(getObjectRequest,
              credentialScope: defaultCephBucketScope,
              expiresIn: const Duration(days: 1),
              serviceConfiguration: serviceConfiguration);
          // print('Presigned Object URL for $objectKey: $signedGetObjectUrl');
          presignedUrls.add({
            'objectKey': objectKey,
            'presignedUrl': signedGetObjectUrl.toString()
          });
        }
        result['presignedUrls'] = presignedUrls;
      }
      return result;
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }
}
