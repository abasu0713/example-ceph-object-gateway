import 'package:args/command_runner.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:dart_example/storage_ops.dart';
import 'package:logging/logging.dart';

final log = Logger('main');

class ListObjectsV2Command extends Command {
  @override
  final name = "listObjectsV2";
  @override
  final description =
      "List objects in a bucket using the ListObjectsV2 API and optionally sign them as well";

  late final Logger logger;

  ListObjectsV2Command() {
    argParser.addOption('bucketName',
        mandatory: true,
        abbr: 'b',
        help: 'The name of the bucket to list objects from.');
    argParser.addOption('prefix',
        abbr: 'p', help: 'The prefix to filter objects by.');
    argParser.addFlag('presignAll',
        abbr: 's', help: 'Presign all objects.', defaultsTo: false);
    logger = log;
  }

  @override
  void run() async {
    final signer = AWSSigV4Signer(
        credentialsProvider: AWSCredentialsProvider.environment());
    try {
      final result = await signer.cephListObjectsV2(
          bucketName: argResults!.option('bucketName') as String,
          prefix: argResults!.option('prefix'),
          signAll: argResults!.flag('presignAll'));
      log.info(result);
    } on Exception catch (e) {
      log.severe(e);
      rethrow;
    }
  }
}

Future<CommandRunner> buildCommandRunner() async {
  return CommandRunner('dart-ceph-object-gateway',
      'A Dart CLI example application to interact with Ceph Object Gateway.')
    ..addCommand(ListObjectsV2Command())
    ..argParser.addFlag('verbose',
        abbr: 'v',
        negatable: false,
        help: 'Show additional command output.',
        defaultsTo: false, callback: (verbose) {
      if (verbose) {
        Logger.root.level = Level.ALL;
      } else {
        Logger.root.level = Level.INFO;
      }
    });
}

void main(List<String> arguments) async {
  final runner = await buildCommandRunner();
  try {
    runner.run(arguments);
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    log.severe(e.message);
  }
}
