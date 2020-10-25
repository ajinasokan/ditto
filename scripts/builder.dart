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
    olam.sort((a, b) => stem(a.word).compareTo(stem(b.word)));
    serialize(olam, "../assets/defs.bin", "../assets/words.bin");
  }

  if (args.contains("alar")) {
    alar = parseAlar();
    // log("alar", "sorting");
    // alar.sort((a, b) => stem(a.word).compareTo(stem(b.word)));
    serialize(alar, "../assets/defs.bin", "../assets/words.bin");
  }
}
