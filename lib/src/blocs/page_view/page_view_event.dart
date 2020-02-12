import 'package:meta/meta.dart';

@immutable
abstract class PageViewEvent {}

class PreviousPage extends PageViewEvent {}

class NextPage extends PageViewEvent {}

class SetPage extends PageViewEvent {
  SetPage(this.page);

  final int page;
}

class NotifyPageChange extends PageViewEvent {
  NotifyPageChange(this.page);

  final int page;
}
