import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:tv_plus/cupertino/constants.dart';

import '../../../assets/assets.gen.dart';
import '../../../foundation/foundation.dart';

final class CupertinoTvSidebarFloatingHeader extends StatelessWidget {
  const CupertinoTvSidebarFloatingHeader({
    super.key,
    required this.selectedItem,
    required this.controller,
  });

  static const _backgroundLight = Color(0x29FFFFFF);
  static const _backgroundDark = Color(0x801E1E1E);
  static const _borderLight = Color(0x1AFFFFFF);
  static const _borderDark = Color(0x29FFFFFF);
  static const _iconBackgroundLight = Color(0x4DFFFFFF);
  static const _iconBackgroundDark = Color(0x33FFFFFF);

  final TvNavigationMenuItem selectedItem;
  final TvNavigationMenuController controller;

  @override
  Widget build(BuildContext context) {
    final brightness =
        CupertinoTheme.of(context).brightness ?? Brightness.light;

    const radius = BorderRadius.all(Radius.circular(40));

    const widgetState = {WidgetState.focused, WidgetState.selected};

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Assets.icons.chevronRight.svg(
          width: 17,
          height: 24,
          package: 'tv_plus',
          colorFilter: ColorFilter.mode(switch (brightness) {
            Brightness.dark => CupertinoColors.white,
            Brightness.light => CupertinoColors.black,
          }, BlendMode.srcIn),
        ),

        ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: CupertinoTvConstants.blurSigma,
              sigmaY: CupertinoTvConstants.blurSigma,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: radius,
                border: BoxBorder.fromBorderSide(
                  BorderSide(
                    color: switch (brightness) {
                      Brightness.dark => _borderDark,
                      Brightness.light => _borderLight,
                    },
                  ),
                ),
                color: switch (brightness) {
                  Brightness.dark => _backgroundDark,
                  Brightness.light => _backgroundLight,
                },
                boxShadow: const [
                  BoxShadow(
                    color: CupertinoTvConstants.shadowColor,
                    offset: Offset(0, 10),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: switch (brightness) {
                          Brightness.dark => _iconBackgroundDark,
                          Brightness.light => _iconBackgroundLight,
                        },
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: selectedItem.icon.resolve(widgetState),
                      ),
                    ),
                  ),

                  SizedBox(width: selectedItem.iconSpacing),

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 12,
                      right: 30,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 198),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return selectedItem.builder(
                            context,
                            constraints,
                            widgetState,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
