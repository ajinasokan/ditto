import 'models.dart';
import 'parsers.dart';
import 'serializer.dart';
import 'utils.dart';

List<Entry> olam = [];
List<Entry> datuk = [];
List<Entry> alar = [];

void main() {
  olam = parseOlam();
  // datuk = parseDatuk();
  alar = parseAlar();

  log("olam", "sorting");
  olam.sort((a, b) => stem(a.word).compareTo(stem(b.word)));
  log("datuk", "sorting");
  datuk.sort((a, b) => stem(a.word).compareTo(stem(b.word)));
  log("alar", "sorting");
  alar.sort((a, b) => stem(a.word).compareTo(stem(b.word)));

  serialize(olam, "../assets/olam_defs.bin", "../assets/olam_words.bin");
  // serialize(datuk, "../assets/datuk_defs.bin", "../assets/datuk_words.bin");
  serialize(alar, "../assets/datuk_defs.bin", "../assets/datuk_words.bin");
}
