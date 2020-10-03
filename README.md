![ditto](https://raw.githubusercontent.com/ajinasokan/ditto/master/logo.svg)

A simple dictionary app built using Flutter. Like [knadh/dictmaker](https://github.com/knadh/dictmaker) but for mobile apps.

Powers [Olam](https://play.google.com/store/apps/details?id=com.olam) and upcoming Alar apps.

## Build

Olam, Datuk datasets are downloaded, processed and binary packed. This is added to the app assets.

To download data sets run:

```sh
$ make download
# output:
#   scripts/olam.csv
#   scripts/datuk.yaml
```

To process these and generate assets:

```sh
$ make db
# output:
#   assets/datuk_defs.bin
#   assets/datuk_words.bin
#   assets/olam_defs.bin
#   assets/olam_words.bin
```

Make targets `olam`, `alar` and `ditto` changes the app name, bundle ID and icon. This is to make use of the same codebase to build multiple apps.

To build Olam:

```sh
$ make olam
$ flutter build apk
```

To generate models ditto uses [dartgen](https://github.com/ajinasokan/dartgen), a WIP inline code generator collection for dart.

Install dartgen:

```sh
pub global activate --source git https://github.com/ajinasokan/dartgen
```

After changing models run:

```sh
$ dartgen
```

## License

ditto is licensed under the GPL 3.0 license