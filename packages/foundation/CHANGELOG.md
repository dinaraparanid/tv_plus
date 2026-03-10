## 0.5.1

 - **FIX**: imports. ([02c6640c](https://github.com/dinaraparanid/tv_plus/commit/02c6640c2d791a7a7a77400c14de10cc092ecfc1))
 - **FIX**: imports ([#29](https://github.com/dinaraparanid/tv_plus/issues/29)). ([4476df00](https://github.com/dinaraparanid/tv_plus/commit/4476df00513bd8ca303b990534c26655607eed31))
 - **FEAT**: sandstone tab layouts ([#31](https://github.com/dinaraparanid/tv_plus/issues/31)). ([faf071e5](https://github.com/dinaraparanid/tv_plus/commit/faf071e5f61271b683fc6ac2c1df0672d57d66cf))
 - **FEAT**: navigation menu specify mainAxisSize, crossAxisAlignment & menuItemsBuilder ([#30](https://github.com/dinaraparanid/tv_plus/issues/30)). ([96e1f200](https://github.com/dinaraparanid/tv_plus/commit/96e1f200f223651643861e3038af25af3d15589c))
 - **FEAT**: melos ([#26](https://github.com/dinaraparanid/tv_plus/issues/26)). ([9788ea88](https://github.com/dinaraparanid/tv_plus/commit/9788ea8890e8c417188bf98f07ba6f993bf33a15))

# 0.5.0
* feat: click selection for tabs & navigation menus
* feat: navigation menu specify mainAxisSize, crossAxisAlignment & menuItemsBuilder
* fix: carousel controller triggered listeners on same selection
* chore: melos & SonarQube integrations; tests improvements

# 0.4.0
* feat: scrollable carousel pager
* feat: added onKeyEvent parameter for TvListView & TvGridView
* chore: multi-modularity support for different design systems
* chore: multiple improvements related to stability, performance, and code quality

## 0.3.0
* fix: select key for Tizen TV
* feat: added hasFocus flag to onFocusChanged() of ScrollGroupDpadFocus & TvTab
* feat: added onKeyEvent() for ScrollGroupDpadFocus & TvTab
* feat: OneUiNavigationDrawer for Tizen TV (+ test case)
* chore: major refactor of all navigation menus for better customization support and animations integration
* chore: added nearest context parameter for DpadFocusScope's builder()
* feat: migration from spacing to separator builder for all TabBar widgets

## 0.2.0
* chore: replace ScrollGroupDpadEventHandler with DpadEventCallback; replace ScrollGroupDpadEventCallback with DpadScopeEventCallback
* chore: rename NavigationMenu's mediatorFocusNode -> mediatorNode
* feat: add static of() / maybyOf() methods for NavigationMenu to retrieve the controller
* chore:  make focus scope node public in NavigationMenu's controller
* chore: allow scroll items to accept any child widget
* feat: improved separator by type in NavigationMenu
* feat: make carousel pager common in foundation
* feat: added CarouselDpadEventCallback for onLeft / onRight to handle case when first / last carousel item was shown
* fix: carousel pager onRight was calling onLeft
* chore: remove SliverTvList & SliverTvGrid (use SliverList and SliverGrid with SliverTVScrollAdapter)

## 0.1.0
* chore: library structure improvements
* chore: remove requirement for FocusScopeNode in TvNavigationMenuController constructor
* chore: navigation menu (drawer + sidebar) refactoring;
* feat: dpad focus added flag to rebuild on focus change
* feat: navigation menu item remove icon requirement + isSelectable flag
* feat: navigation menu item add canRequestFocus flag
* chore: navigation menu item make decoration optional
* chore: navigation menu item decoration from BoxDecoration to Decoration
* feat: navigation drawer & sidebar states public
* fix: navigation drawer & sidebar key management
* chore: tab bar make state public
* chore: dpad focus scope events refactor + dpad_scope_events
* chore: dpad focus builder refactor

## 0.0.3
* Remove requirement of FocusScopeNode in TvNavigationMenuController constructor
* Navigation menu (drawer + sidebar) refactoring
* Added flag for DpadFocus to rebuild on each focus change

## 0.0.2

* Basic focus management with D-pad
* Scrolling widgets
* Navigation widgets for Material and Cupertino themes
* Integration tests coverage
