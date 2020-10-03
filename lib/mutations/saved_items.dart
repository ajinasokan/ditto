import 'package:ditto/app.dart';

class AddToRecent extends Mutation<OlamStore> {
  final Entry entry;

  AddToRecent(this.entry);

  void exec() {
    int index = store.recent.indexWhere((item) => item.word == entry.word);
    if (index != -1) store.recent.removeAt(index);
    store.recent.insert(0, entry);
    later(() => SaveStore());
  }
}

class RemoveFromRecent extends Mutation<OlamStore> {
  final int index;

  RemoveFromRecent(this.index);

  void exec() {
    store.recent.removeAt(index);
    later(() => SaveStore());
  }
}

class ClearRecent extends Mutation<OlamStore> {
  void exec() {
    store.recent.clear();
    later(() => SaveStore());
  }
}

class AddToBookmarks extends Mutation<OlamStore> {
  final Entry entry;

  AddToBookmarks(this.entry);

  void exec() {
    store.bookmarks.insert(0, entry);
    later(() => SaveStore());
  }
}

class RemoveFromBookmarks extends Mutation<OlamStore> {
  final int index;

  RemoveFromBookmarks(this.index);

  void exec() {
    store.bookmarks.removeAt(index);
    later(() => SaveStore());
  }
}

class ClearBookmarks extends Mutation<OlamStore> {
  void exec() {
    store.bookmarks.clear();
    later(() => SaveStore());
  }
}
