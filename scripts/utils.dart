void log(Object tag, [Object extra = ""]) {
  if (extra != "") {
    print("$tag: $extra");
  } else {
    print("$tag");
  }
}
