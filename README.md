# example-ceph-object-gateway
This repository contains some sample code to interact with Ceph Object Gateway using AWS SDKs. 

# Overview
Only has basic usage demonstrations of:
- S3's ListObjectsV2 API
- Generating Pre-signed URLs for temporary public access for Bucket Objects. 

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