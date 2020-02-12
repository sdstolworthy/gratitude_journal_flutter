import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

const int animationDurationInMilliseconds = 60;

class PageViewBloc extends Bloc<PageViewEvent, PageViewState> {
  PageViewBloc({PageController pageController, this.pages, int initialPage}) {
    this.initialPage = initialPage ?? 0;
    this.pageController =
        pageController ?? PageController(initialPage: this.initialPage);
  }

  int initialPage;
  PageController pageController;
  Map<String, int> pages;

  @override
  PageViewState get initialState => CurrentPage(0);

  @override
  Stream<PageViewState> mapEventToState(
    PageViewEvent event,
  ) async* {
    if (event is NextPage) {
      pageController.nextPage(
          curve: const ElasticInCurve(),
          duration:
              const Duration(milliseconds: animationDurationInMilliseconds));
    } else if (event is PreviousPage) {
      pageController.previousPage(
          curve: const ElasticInCurve(),
          duration:
              const Duration(milliseconds: animationDurationInMilliseconds));
    } else if (event is NotifyPageChange) {
      yield CurrentPage(pageController.page.toInt());
    } else if (event is SetPage) {
      pageController.animateToPage(event.page,
          curve: const ElasticInOutCurve(),
          duration: const Duration(milliseconds: 400));
    }
    yield CurrentPage(pageController.page.toInt());
  }
}
