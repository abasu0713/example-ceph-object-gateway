import 'package:args/command_runner.dart';
import 'package:logging/logging.dart';

late final Logger log;

class ListObjectsV2Command extends Command {
  @override
  final name = "listObjectsV2";
  @override
  final description =
      "List objects in a bucket using the ListObjectsV2 API and optionally sign them as well";

  ListObjectsV2Command() {
    argParser.addOption('bucketName',
        mandatory: true,
        abbr: 'b',
        help: 'The name of the bucket to list objects from.');
    argParser.addMultiOption('prefix',
        abbr: 'p', help: 'The prefix to filter objects by.');
    argParser.addFlag('presignAll',
        abbr: 's', help: 'Presign all objects.', defaultsTo: false);
  }

  @override
  void run() {
    throw UnimplementedError();
  }
}

CommandRunner buildCommandRunner() {
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

void main(List<String> arguments) {
  log = Logger('main');
  final runner = buildCommandRunner();
  try {
    runner.run(arguments);
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    log.severe(e.message);
  }
}
