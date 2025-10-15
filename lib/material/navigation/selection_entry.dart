import 'package:flutter/widgets.dart';

@immutable
sealed class SelectionEntry {}


final class HeaderEntry extends SelectionEntry {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeaderEntry && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'HeaderEntry';
}

final class ItemEntry extends SelectionEntry {
  ItemEntry({required this.index});

  final int index;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemEntry &&
          runtimeType == other.runtimeType &&
          index == other.index;

  @override
  int get hashCode => index.hashCode;

  @override
  String toString() => 'ItemEntry{index: $index}';
}

final class FooterEntry extends SelectionEntry {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FooterEntry && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'FooterEntry';
}
