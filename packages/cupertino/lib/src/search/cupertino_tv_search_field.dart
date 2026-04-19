part of 'search.dart';

final class _CupertinoTvSearchField extends StatefulWidget {
  const _CupertinoTvSearchField({
    required this.controller,
    required this.placeholder,
    required this.searchIcon,
  });

  final CupertinoTvSearchController controller;
  final String placeholder;
  final Widget? searchIcon;

  @override
  State<StatefulWidget> createState() => _CupertinoTvSearchFieldState();
}

final class _CupertinoTvSearchFieldState
    extends State<_CupertinoTvSearchField> {
  late final _inputNode = FocusNode(canRequestFocus: false);

  @override
  void initState() {
    widget.controller.addListener(_controllerListener);
    super.initState();
  }

  void _controllerListener() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    _inputNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTvSearchBarTheme.of(context);

    return Row(
      children: [
        ?widget.searchIcon,

        Expanded(
          child: CupertinoTextField(
            controller: widget.controller.textEditingController,
            focusNode: _inputNode,
            decoration: null,
            padding: EdgeInsets.zero,
            placeholder: widget.placeholder,
            placeholderStyle: theme.placeholderStyle,
            style: theme.queryStyle,
            readOnly: true,
            showCursor: false,
            textAlignVertical: TextAlignVertical.center,
          ),
        ),

        // TODO(paranid5): press hints
      ],
    );
  }
}
