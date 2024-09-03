import boto3

def get_parser():
    import argparse
    parser = argparse.ArgumentParser(description='Process some integers.', prog='python-ceph-object-gateway')
    parser.add_argument('--bucketName', type=str, help='S3 bucket name', required=True)
    parser.add_argument('--prefix', type=str, help='S3 object prefix', default='')
    parser.add_argument('--generateSignedUrl', action='store_true', help='Presign all objects in the bucket', default=False)
    return parser


def list_objects_v2(bucketName, prefix, generateSignedUrl = False) -> list:
    import os
    bucket_host = os.environ['CEPH_OBJECT_GATEWAY_HOST']
    if not bucket_host:
        print("Environment variable CEPH_OBJECT_GATEWAY_HOST required")
        exit(1)
    session = boto3.session.Session()
    s3_client = session.client('s3', endpoint_url='https://' + bucket_host)
    objects = s3_client.list_objects_v2(Bucket=bucketName, Prefix=prefix)
    result = []
    for obj in objects['Contents']:
        if generateSignedUrl:
            url = s3_client.generate_presigned_url('get_object', Params={'Bucket': bucketName, 'Key': obj['Key']}, ExpiresIn=86400)
            result.append({"key": obj['Key'], "signedUrl": url})
        else:
            result.append({"key": obj['Key']})
    return result


if __name__ == "__main__":
    parser = get_parser()
    args = parser.parse_args()
    if not args.bucketName:
        print("bucket name required")
        print(parser.usage)
        exit(1)
    objects = list_objects_v2(args.bucketName, args.prefix, args.generateSignedUrl)
    print("Bucket: ", args.bucketName)
    print("Prefix: ", args.prefix)
    print("Response: \n{}".format(objects))