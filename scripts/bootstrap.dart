import 'dart:io';
import 'package:path/path.dart' as path;

// idea from: https://github.com/onatcipli/rename/blob/master/lib/file_repository.dart

List<String> androidManifestPath = [
  "..",
  "android",
  "app",
  "src",
  "main",
  "AndroidManifest.xml"
];

void main(List<String> args) {
  changeAndroidIcon(args[0]);
}

void changeAndroidIcon(String icon) async {
  final fullPath = path.joinAll(androidManifestPath);
  List contentLineByLine = await File(fullPath).readAsLines();

  for (int i = 0; i < contentLineByLine.length; i++) {
    if (contentLineByLine[i].contains("android:icon")) {
      contentLineByLine[i] = "        android:icon=\"@mipmap/$icon\">";
      break;
    }
  }

  File(fullPath).writeAsStringSync(contentLineByLine.join('\n'));
}
