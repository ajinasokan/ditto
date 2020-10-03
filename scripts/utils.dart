void log(Object tag, [Object extra = ""]) {
  if (extra != "") {
    print("$tag: $extra");
  } else {
    print("$tag");
  }
}

String stem(String input) {
  return input.toLowerCase().split(" ").join();
}
