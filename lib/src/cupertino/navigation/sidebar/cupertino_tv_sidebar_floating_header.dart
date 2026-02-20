part of 'sidebar.dart';

final class CupertinoTvSidebarFloatingHeader extends StatelessWidget {
  const CupertinoTvSidebarFloatingHeader({
    super.key,
    required this.controller,
    this.iconSpacing = 12,
    required this.iconBuilder,
    required this.itemBuilder,
  });

  static const _backgroundLight = Color(0x29FFFFFF);
  static const _backgroundDark = Color(0x801E1E1E);
  static const _borderLight = Color(0x1AFFFFFF);
  static const _borderDark = Color(0x29FFFFFF);
  static const _iconBackgroundLight = Color(0x4DFFFFFF);
  static const _iconBackgroundDark = Color(0x33FFFFFF);

  final TvNavigationMenuController controller;
  final double iconSpacing;

  final WidgetStateProperty<Widget> Function(BuildContext context) iconBuilder;

  final Widget Function(
    BuildContext context,
    BoxConstraints itemConstraints,
    Set<WidgetState> itemStates,
  )
  itemBuilder;

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
                        child: iconBuilder(context).resolve(widgetState),
                      ),
                    ),
                  ),

                  SizedBox(width: iconSpacing),

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
                          return itemBuilder(context, constraints, widgetState);
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
