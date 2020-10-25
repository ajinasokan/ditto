import 'dart:io';

import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;

import 'utils.dart';

const URL_OLAM = "https://olam.in/open/enml/olam-enml.csv.zip";
const URL_DATUK = "https://github.com/knadh/datuk/archive/master.zip";
const URL_ALAR = "https://github.com/alar-dict/data/archive/master.zip";

void main(List<String> args) async {
  bool all = args.isEmpty;

  log("download started");

  if (all || args.contains("olam")) {
    downloadFromZip(
      url: URL_OLAM,
      src: "olam-enml.csv",
      dst: "olam.csv",
    );
  }

  if (all || args.contains("datuk")) {
    downloadFromZip(
      url: URL_DATUK,
      src: "datuk-master/datuk.yaml",
      dst: "datuk.yaml",
    );
  }

  if (all || args.contains("alar")) {
    downloadFromZip(
      url: URL_ALAR,
      src: "data-master/alar.yml",
      dst: "alar.yaml",
    );
  }
}

void downloadFromZip({String url, String src, String dst}) async {
  log("Downloading $url");
  final zippedFile =
      ZipDecoder().decodeBytes((await http.get(url)).bodyBytes).findFile(src);

  if (zippedFile.isCompressed) zippedFile.decompress();

  File(dst).writeAsBytes(zippedFile.content);
  log("Finished downloading $dst");
}
