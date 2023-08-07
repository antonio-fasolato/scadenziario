import 'dart:io';

extension PlatformExtension on Platform {
  String get lineSeparator => Platform.isWindows
      ? '\r\n'
      : Platform.isMacOS
          ? '\r'
          : Platform.isLinux
              ? '\n'
              : '\n';
}
