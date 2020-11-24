bool isAlpha(String string) {
  return !string.split("").any((char) => !isAlphabet(char));
}

bool isAlphabet(String char) {
  int charCode = char.toLowerCase().codeUnitAt(0);
  return charCode >= "a".codeUnitAt(0) && charCode <= "z".codeUnitAt(0);
}

List<Map<String, String>> md2map(String md) {
  List<Map<String, String>> items = [];
  RegExp linkRegex = new RegExp(r"\[(.*?)\]\((.*?)\)");

  int pos = 0;
  for (var match in linkRegex.allMatches(md)) {
    items.add({
      "type": "text",
      "value": md.substring(pos, match.start),
    });
    items.add({
      "type": "link",
      "value": match.group(1),
      "link": match.group(2),
    });
    pos = match.end;
  }
  if (pos < md.length)
    items.add({
      "type": "text",
      "value": md.substring(pos, md.length),
    });

  return items;
}
