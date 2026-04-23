import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:tv_plus_cupertino/src/search/search.dart';
import 'package:tv_plus_cupertino/tv_plus_cupertino.dart';

final class CupertinoSearchBarSample extends StatefulWidget {
  const CupertinoSearchBarSample({super.key});

  static const items = [
    ('Crimson Red', CupertinoColors.systemRed),
    ('Emerald Green', CupertinoColors.systemGreen),
    ('Royal Blue', CupertinoColors.systemBlue),
    ('Bright Orange', CupertinoColors.systemOrange),
    ('Sunny Yellow', CupertinoColors.systemYellow),
    ('Deep Purple', CupertinoColors.systemPurple),
    ('Hot Pink', CupertinoColors.systemPink),
    ('Slate Grey', CupertinoColors.systemGrey),
    ('Cyan', CupertinoColors.systemCyan),
    ('Indigo', CupertinoColors.systemIndigo),
  ];

  static final localization = CupertinoTvSearchBarLocalization(
    supportedAlphabets: LinkedHashMap.of({
      const Locale('en', 'US'): 'abcdefghijklmnopqrstuvwxyz'.split(''),
      const Locale('en', 'UK'): 'abcdefghijklmnopqrstuvwxyz'.split(''),
      const Locale('ru'): 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя'.split(''),
    }),
    spaceTranslation: {
      const Locale('en', 'US'): 'SPACE',
      const Locale('en', 'UK'): 'SPACE',
      const Locale('ru'): 'ПРОБЕЛ',
    },
    keyboardLayoutTranslation: {
      const Locale('en', 'US'): 'English (US)',
      const Locale('en', 'UK'): 'English (UK)',
      const Locale('ru'): 'Русская',
    },
  );

  static const initialLocale = Locale('en', 'US');

  static const searchBarTheme = CupertinoTvSearchBarThemeData(
    queryStyle: TextStyle(
      fontSize: 32,
      color: Color(0xCCFFFFFF),
      fontWeight: FontWeight.w700,
    ),
    placeholderStyle: TextStyle(
      fontSize: 32,
      color: Color(0xCCC4C7C5),
      fontWeight: FontWeight.w700,
    ),
    letterTextStyle: WidgetStateProperty.fromMap({
      WidgetState.focused: TextStyle(
        fontSize: 24,
        color: Color(0xCC000000),
        fontWeight: FontWeight.w700,
      ),
      WidgetState.any: TextStyle(
        fontSize: 24,
        color: Color(0xCCC4C7C5),
        fontWeight: FontWeight.w700,
      ),
    }),
    buttonTextStyle: WidgetStateProperty.fromMap({
      WidgetState.focused: TextStyle(
        fontSize: 16,
        color: CupertinoColors.white,
        fontWeight: FontWeight.w700,
        height: 1.5,
      ),
      WidgetState.any: TextStyle(
        fontSize: 16,
        color: Color(0xCCC4C7C5),
        fontWeight: FontWeight.w700,
        height: 1.5,
      ),
    }),
    letterFocusDecoration: WidgetStateProperty.fromMap({
      WidgetState.focused: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4.8),
            blurRadius: 4.8,
            color: Color(0x40000000),
          ),
        ],
      ),
      WidgetState.any: BoxDecoration(),
    }),
    buttonContentColor: WidgetStateProperty.fromMap({
      WidgetState.focused: CupertinoColors.white,
      WidgetState.any: Color(0xCCC4C7C5),
    }),
    letterFocusPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    buttonFillPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    buttonFocusPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    buttonRadius: BorderRadius.all(Radius.circular(4)),
    switchLocaleIconSize: 24,
    spaceBetweenQueryAndInput: 24,
  );

  @override
  State<StatefulWidget> createState() => _CupertinoSearchBarSampleState();
}

final class _CupertinoSearchBarSampleState
    extends State<CupertinoSearchBarSample> {
  late final _controller = CupertinoTvSearchController(
    localization: CupertinoSearchBarSample.localization,
    currentLocale: CupertinoSearchBarSample.initialLocale,
  )..addListener(_listener);

  late final _gridScopeNode = FocusScopeNode();

  var _items = CupertinoSearchBarSample.items;

  void _listener() {
    setState(() {
      _items = _controller.query.isEmpty
          ? CupertinoSearchBarSample.items
          : CupertinoSearchBarSample.items.where((x) {
              return x.$1.toLowerCase().contains(_controller.query);
            }).toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _gridScopeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(brightness: Brightness.dark),
      home: CupertinoPageScaffold(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
              sliver: SliverToBoxAdapter(
                child: CupertinoTvSearchBar(
                  controller: _controller,
                  placeholder: 'Search by color name',
                  searchIcon: const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      CupertinoIcons.search,
                      size: 48,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  theme: CupertinoSearchBarSample.searchBarTheme,
                  onDown: (_, _, isOutOfScope) {
                    if (isOutOfScope) {
                      _gridScopeNode.requestFocus();
                      return KeyEventResult.handled;
                    }

                    return KeyEventResult.ignored;
                  },
                  onFocusChanged: (node, isFocused) {
                    final context = node.context;

                    if (context != null && isFocused) {
                      Scrollable.ensureVisible(context, alignment: 0.5);
                    }
                  },
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(
                vertical: 80,
                horizontal: 160,
              ),
              sliver: SliverTVScrollAdapter(
                focusScopeNode: _gridScopeNode,
                onUp: (_, _, isOutOfScope) {
                  if (isOutOfScope) {
                    _controller.requestFocusOnFirstLetter();
                    return KeyEventResult.handled;
                  }

                  return KeyEventResult.ignored;
                },
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    childCount: _items.length,
                    (context, index) => _Item(
                      autofocus: index == 0,
                      color: _items[index].$2,
                      name: _items[index].$1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _Item extends StatefulWidget {
  const _Item({
    required this.color,
    required this.name,
    required this.autofocus,
  });

  final Color color;
  final String name;
  final bool autofocus;

  @override
  State<StatefulWidget> createState() => _ItemState();
}

final class _ItemState extends State<_Item> {
  var _isScaled = false;

  static const _duration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return DpadFocus(
      autofocus: widget.autofocus,
      onFocusChanged: (_, isFocused) {
        setState(() => _isScaled = isFocused);
      },
      builder: (_, _) => AnimatedScale(
        scale: _isScaled ? 1.1 : 1,
        duration: _duration,
        child: Container(
          decoration: const BoxDecoration(
            color: CupertinoColors.darkBackgroundGray,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [BoxShadow(blurRadius: 10)],
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  ColoredBox(
                    color: widget.color,
                    child: const SizedBox(width: double.infinity, height: 100),
                  ),

                  Text(widget.name),
                ],
              ),

              Positioned.fill(
                child: AnimatedContainer(
                  duration: _duration,
                  color: _isScaled
                      ? const Color(0x1AFFFFFF)
                      : CupertinoColors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
