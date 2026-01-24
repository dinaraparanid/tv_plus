part of 'menu.dart';

@immutable
sealed class TvNavigationMenuSelectionEntry {
  const TvNavigationMenuSelectionEntry();
}

final class HeaderEntry extends TvNavigationMenuSelectionEntry {
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

final class ItemEntry extends TvNavigationMenuSelectionEntry {
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

final class FooterEntry extends TvNavigationMenuSelectionEntry {
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
