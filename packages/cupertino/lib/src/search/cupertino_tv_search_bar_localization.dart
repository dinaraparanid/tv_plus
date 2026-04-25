part of 'search.dart';

@immutable
final class CupertinoTvSearchBarLocalization {
  const CupertinoTvSearchBarLocalization({
    required this.supportedAlphabets,
    required this.keyboardTypeTranslation,
    required this.spaceTranslation,
    required this.keyboardLayoutTranslation,
  });

  /// Locales' positions are used during alphabet switching
  final LinkedHashMap<Locale, List<String>> supportedAlphabets;
  final Map<Locale, String> keyboardTypeTranslation;
  final Map<Locale, String> spaceTranslation;
  final Map<Locale, String> keyboardLayoutTranslation;
}
