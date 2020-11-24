import 'models.dart';
import 'parsers.dart';
import 'serializer.dart';
import 'utils.dart';

List<Entry> olam = [];
List<Entry> alar = [];

void main(List<String> args) {
  if (args.contains("olam")) {
    olam = parseOlam();
    olam.addAll(parseDatuk());
    log("olam", "sorting");
    olam.sort((a, b) => a.word.compareTo(b.word));
    serialize(olam, "../assets/defs.bin", "../assets/words.bin");
    olam.sort((a, b) => a.hash.compareTo(b.hash));
    serializeHashes(olam, "../assets/hashes.bin");
  }

  if (args.contains("alar")) {
    alar = parseAlar();
    log("alar", "sorting");
    alar.sort((a, b) => a.word.compareTo(b.word));
    alar = alar.where((element) {
      if (element.word.codeUnitAt(0) >= 3200 &&
          element.word.codeUnitAt(0) <= 3327) {
        return true;
      }
      print("removing ${element.word}");
      return false;
    }).toList();
    serialize(alar, "../assets/defs.bin", "../assets/words.bin");
    alar.sort((a, b) {
      if (a.hash != b.hash)
        return a.hash.compareTo(b.hash);
      else
        return a.index.compareTo(b.index);
    });
    serializeHashes(alar, "../assets/hashes.bin");
  }
}
