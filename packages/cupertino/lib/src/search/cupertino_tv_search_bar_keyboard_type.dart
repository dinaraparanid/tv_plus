part of 'search.dart';

enum CupertinoTvSearchBarKeyboardType { letters, numbers, special }

extension KeyboardTypeExt on CupertinoTvSearchBarKeyboardType {
  CupertinoTvSearchBarKeyboardType get next => switch (this) {
    CupertinoTvSearchBarKeyboardType.letters =>
      CupertinoTvSearchBarKeyboardType.numbers,

    CupertinoTvSearchBarKeyboardType.numbers =>
      CupertinoTvSearchBarKeyboardType.special,

    CupertinoTvSearchBarKeyboardType.special =>
      CupertinoTvSearchBarKeyboardType.letters,
  };
}
