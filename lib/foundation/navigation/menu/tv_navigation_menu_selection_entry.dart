import 'package:flutter/widgets.dart';

@immutable
sealed class TvNavigationMenuSelectionEntry {
  const TvNavigationMenuSelectionEntry({required this.key});

  final Key key;
}

final class HeaderEntry extends TvNavigationMenuSelectionEntry {
  const HeaderEntry({required super.key});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeaderEntry && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'HeaderEntry';
}

final class ItemEntry extends TvNavigationMenuSelectionEntry {
  const ItemEntry({required super.key});

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

final class FooterEntry extends TvNavigationMenuSelectionEntry {
  const FooterEntry({required super.key});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FooterEntry && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'FooterEntry';
}
