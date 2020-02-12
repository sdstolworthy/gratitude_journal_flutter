import 'package:meta/meta.dart';

@immutable
abstract class PageViewState {}

class CurrentPage extends PageViewState {
  CurrentPage(this.pageIndex);

  final int pageIndex;
}
