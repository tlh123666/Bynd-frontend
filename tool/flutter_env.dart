import 'dart:io';
import 'dart:convert';
import 'package:new_jcvital/core/config/app_config.dart';

/// Example: dart run tool/flutter_env.dart run demo -d chrome
/// Example: dart run tool/flutter_env.dart build prod appbundle
Future<void> main(List<String> arguments) async {
  if (arguments.length < 2 ||
      !{'run', 'build', 'test'}.contains(arguments[0]) ||
      !{'dev', 'test', 'prod', 'demo'}.contains(arguments[1])) {
    stderr.writeln(
      'Usage: dart run tool/flutter_env.dart <run|build|test> <dev|test|prod|demo> [Flutter arguments]',
    );
    exitCode = 64;
    return;
  }
  final root = File.fromUri(Platform.script).parent.parent;
  final action = arguments[0], environment = arguments[1];
  try {
    final values =
        (jsonDecode(
                  File(
                    '${root.path}/config/$environment.json',
                  ).readAsStringSync(),
                )
                as Map)
            .map((key, value) => MapEntry(key.toString(), value.toString()));
    AppConfig.resolve(defines: values, releaseMode: action == 'build');
  } on FormatException catch (error) {
    stderr.writeln('Invalid environment configuration: ${error.message}');
    exitCode = 78;
    return;
  }
  final rest = arguments.skip(2).where((arg) => arg != '--dry-run').toList();
  if (action == 'build' && rest.isEmpty) {
    stderr.writeln('Specify a build target: web, apk, appbundle, ios, ...');
    exitCode = 64;
    return;
  }
  final command = action == 'build'
      ? [
          action,
          rest.first,
          '--dart-define-from-file=config/$environment.json',
          ...rest.skip(1),
        ]
      : [action, '--dart-define-from-file=config/$environment.json', ...rest];
  final executable = Platform.environment['FLUTTER_BIN'] ?? 'flutter';
  if (arguments.contains('--dry-run')) {
    stdout.writeln('$executable ${command.join(' ')}');
    return;
  }
  try {
    final process = await Process.start(
      executable,
      command,
      workingDirectory: root.path,
      mode: ProcessStartMode.inheritStdio,
      runInShell: Platform.isWindows,
    );
    exitCode = await process.exitCode;
  } on ProcessException {
    stderr.writeln(
      'Flutter could not be started. Add the SDK bin directory to PATH or set FLUTTER_BIN.',
    );
    exitCode = 69;
  }
}
