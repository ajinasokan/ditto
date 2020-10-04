
ditto:
	flutter pub run rename --appname "ditto" --bundleId "com.ajinasokan.ditto"
	cd scripts; dart bootstrap.dart ditto_icon
	
olam:
	flutter pub run rename --appname "Olam" --bundleId "com.olam" --launcherIcon olam_icon
	cd scripts; dart bootstrap.dart olam_icon

alar:
	flutter pub run rename --appname "Alar" --bundleId "ink.alar" --launcherIcon alar_icon
	cd scripts; dart bootstrap.dart alar_icon

download:
	cd scripts; dart downloader.dart

db:
	cd scripts; dart builder.dart
