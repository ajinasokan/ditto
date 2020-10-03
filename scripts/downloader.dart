import 'dart:io';
import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;

const URL_OLAM = "https://olam.in/open/enml/olam-enml.csv.zip";
const URL_DATUK = "https://github.com/knadh/datuk/archive/master.zip";

void main() async {
  downloadOlam();
  downloadDatuk();
}

void downloadOlam() async {
  final olam = ZipDecoder()
      .decodeBytes((await http.get(URL_OLAM)).bodyBytes)
      .findFile("olam-enml.csv");

  if (olam.isCompressed) olam.decompress();

  File("olam.csv").writeAsBytes(olam.content);
}

void downloadDatuk() async {
  final olam = ZipDecoder()
      .decodeBytes((await http.get(URL_DATUK)).bodyBytes)
      .findFile("datuk-master/datuk.yaml");

  if (olam.isCompressed) olam.decompress();

  File("datuk.yaml").writeAsBytes(olam.content);
}
