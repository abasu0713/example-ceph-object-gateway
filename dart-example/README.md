A sample CLI application to demonstrate interaction with AWS S3 compatible Ceph Object Gateway

# Prerequisite
- A working Ceph Cluster with a Rados/Object gateway enabled. Refer to this [article](https://medium.com/@arko.basu09/part-1-diy-globally-accessible-s3-compatible-object-store-1a625460e802) to setup your own globally accessible S3 Object Gateway

    > You can test this with a local deployment with Private IP from within the same network boundary as your Ceph Cluster if you like. 

# Usage

### Locally Testing
1. [Install Dart](https://dart.dev/get-dart)
1. Clone this repository and navigate inside and install dependencies
    ```bash
    git clone 
    cd 
    dart pub get
    ```
1. Setup environment variables:
    ```bash
    export CEPH_OBJECT_GATEWAY_HOST="https://<dns-or-private-ip-address>"
    ```
1. Run the sample script and check it's usage
    ```bash
    dart run lib/main.dart -h
    ```

    Example Usage to list bucket contents under a specific _prefix_:
    ```bash
    dart run lib/main.dart listObjectsV2 --bucketName "bucket-test" --prefix "images/public"
    ```
    You can exclude prefix to recursively list all contents within the bucket. 

    Example Usage to list bucket contents under a specific _prefix_ and sign them at the same time for 1 day:
    ```bash
    dart run lib/main.dart listObjectsV2 --bucketName "bucket-test" --prefix "images/public" -s
    ```

