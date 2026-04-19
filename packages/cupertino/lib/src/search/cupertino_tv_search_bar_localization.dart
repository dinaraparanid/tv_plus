part of 'search.dart';

@immutable
final class CupertinoTvSearchBarLocalization {
  const CupertinoTvSearchBarLocalization({
    required this.supportedAlphabets,
    required this.spaceTranslation,
  });

  /// Locales' positions are used during alphabet switching
  final LinkedHashMap<Locale, List<String>> supportedAlphabets;
  final Map<Locale, String> spaceTranslation;
}
