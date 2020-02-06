import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grateful/src/repositories/feedback/feedback_repository.dart';
import 'package:meta/meta.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  @override
  FeedbackState get initialState => FeedbackInitial();

  @override
  Stream<FeedbackState> mapEventToState(
    FeedbackEvent event,
  ) async* {
    if (event is SubmitFeedback) {
      yield FeedbackSending();
      try {
        await FeedbackRepository().saveFeedback(event.feedback);
        yield FeedbackSent();
      } catch (e) {
        yield FeedbackSendError();
      }
    }
  }
}
