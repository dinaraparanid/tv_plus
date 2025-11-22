import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:tv_plus/foundation/scroll/types.dart';

final class SliverTvGrid extends SliverMultiBoxAdaptorWidget {
  SliverTvGrid({
    super.key,
    required this.gridDelegate,
    required TvScrollItemBuilder itemBuilder,
    int? Function(Key)? findChildIndexCallback,
    required int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
  }) : super(
         delegate: SliverChildBuilderDelegate(
           itemBuilder,
           findChildIndexCallback: findChildIndexCallback,
           childCount: itemCount,
           addAutomaticKeepAlives: addAutomaticKeepAlives,
           addRepaintBoundaries: addRepaintBoundaries,
           addSemanticIndexes: addSemanticIndexes,
         ),
       );

  final SliverGridDelegate gridDelegate;

  @override
  RenderSliverMultiBoxAdaptor createRenderObject(BuildContext context) {
    final element = context as SliverMultiBoxAdaptorElement;
    return RenderSliverGrid(childManager: element, gridDelegate: gridDelegate);
  }
}
