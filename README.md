# example-ceph-object-gateway
This repository contains some sample code to interact with Ceph Object Gateway's S3 API using AWS SDKs. 

# Overview
This repository only contains code that demonstrates implementation of the following:
- S3's ListObjectsV2 API
- Generating Pre-signed URLs for temporary public access of Bucket Objects. 

> Ceph's SQUID release supports almost all IAM and S3 APIs excepting some minor ACL related APIs which you won't most likely need unless you are doing some advanced IAM federation work. So this crude implementation should serve as a rough guide on how to use Ceph Object Gateway's S3 API as if you were using AWS S3 service itself. 

Languages covered (please check their respective directories):
1. Dart - `dart-example`
1. Python - `python-example`

> Note: Please let me know and I will be happy to add more language support

## Getting Started
1. Clone this repository and navigate inside and install dependencies
    ```bash
    git clone https://github.com/abasu0713/example-ceph-object-gateway.git
    ```
1. Setup environment variables:
    ```bash
    export CEPH_OBJECT_GATEWAY_HOST="https://<host-address>"
    export AWS_ACCESS_KEY_ID=<your-access-key-id>
    export AWS_SECRET_ACCESS_KEY=<your-secret-access-key>
    ```
    > _Note:_ If you ran AWS CLI Configure and want to test only the Python version then you don't need to export the AWS Credentials as environment variables. These env variables are only required by the dart version. 
1. Follow repository specific instructions