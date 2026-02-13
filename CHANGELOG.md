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
