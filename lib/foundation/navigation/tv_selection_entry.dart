import 'package:flutter/widgets.dart';

@immutable
sealed class TvSelectionEntry {
  const TvSelectionEntry();
}

final class HeaderEntry extends TvSelectionEntry {
  const HeaderEntry();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeaderEntry && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'HeaderEntry';
}

final class ItemEntry extends TvSelectionEntry {
  const ItemEntry({required this.key});

  final Key key;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemEntry &&
          runtimeType == other.runtimeType &&
          key == other.key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() {
    return 'ItemEntry{key: $key}';
  }
}

final class FooterEntry extends TvSelectionEntry {
  const FooterEntry();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FooterEntry && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'FooterEntry';
}
