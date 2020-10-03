import 'package:ditto/app.dart';

class ToggleNightMode extends Mutation<OlamStore> {
  final bool enabled;

  ToggleNightMode(this.enabled);

  void exec() {
    store.nightMode = enabled;
    later(() => SaveStore());
  }
}

class ToggleEasyPaste extends Mutation<OlamStore> {
  final bool enabled;

  ToggleEasyPaste(this.enabled);

  void exec() {
    store.easyPaste = enabled;
    later(() => SaveStore());
  }
}

class CheckClippedString extends Mutation<OlamStore> {
  final String clip;

  CheckClippedString(this.clip);

  void exec() {
    if (!store.easyPaste) return;

    var text = clip ?? "";
    if (isAlpha(text) &&
        text.length > 0 &&
        text.length < 15 &&
        text != store.recent[0]?.word &&
        store.clippedString != text) {
      later(() => SetClippedString(clip));
    }
  }
}

class SetClippedString extends Mutation<OlamStore> {
  final String clip;

  SetClippedString(this.clip);

  void exec() {
    store.clippedString = clip;
    later(() => SaveStore());
  }
}
