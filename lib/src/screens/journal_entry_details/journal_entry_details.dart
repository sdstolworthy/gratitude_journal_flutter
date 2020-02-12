import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/edit_journal_entry/bloc.dart';
import 'package:grateful/src/blocs/journal_feed/bloc.dart';
import 'package:grateful/src/config/config.dart';
import 'package:grateful/src/models/journal_entry.dart';
import 'package:grateful/src/models/photograph.dart';
import 'package:grateful/src/repositories/journal_entry/journal_entry_repository.dart';
import 'package:grateful/src/repositories/analytics/analytics_repository.dart';
import 'package:grateful/src/screens/main_page_view/main_page_view.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';
import 'package:grateful/src/widgets/background_gradient_provider.dart';
import 'package:grateful/src/widgets/photo_viewer.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class JournalEntryDetailArguments {
  JournalEntryDetailArguments({@required this.journalEntry});

  JournalEntry journalEntry;
}

class JournalEntryDetails extends StatefulWidget {
  const JournalEntryDetails(this.journalEntry);

  final JournalEntry journalEntry;

  @override
  State<StatefulWidget> createState() {
    return _JournalEntryDetails();
  }
}

class _JournalEntryDetails extends State<JournalEntryDetails>
    with TickerProviderStateMixin {
  JournalEntry journalEntry;
  List<NetworkPhoto> photographs;

  Animation<Offset> _animation;
  Animation<double> _animationController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_animation == null) {
      // _animationController = ModalRoute.of(context).animation;
      _animationController = ModalRoute.of(context).animation;
      setState(() {
        _animation = Tween<Offset>(
                begin: const Offset(0.0, 1.0), end: const Offset(0.0, 0.0))
            .animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.fastOutSlowIn,
        ));
        // _animationController.forward();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    // _animationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    journalEntry = widget.journalEntry;
    photographs = widget?.journalEntry?.photographs ?? <NetworkPhoto>[];
  }

  String _getShareText(BuildContext context, JournalEntry journalEntry) {
    return '${journalEntry.body}\n\n${AppLocalizations.of(context).shareJournalEntryText}\n${Config.oneLinkDownload}';
  }

  Widget _renderAppBar(BuildContext context) {
    final EditJournalEntryBloc _journalEntryBloc =
        BlocProvider.of<EditJournalEntryBloc>(context);
    final ThemeData theme = Theme.of(context);
    return SliverAppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: FlatButton(
          child:
              Icon(Icons.arrow_back, color: theme.appBarTheme.iconTheme.color),
          onPressed: () {
            rootNavigationService.goBack();
          }),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            showDialog<void>(
                context: context,
                builder: (BuildContext c) {
                  return AlertDialog(
                    title: Text(
                      AppLocalizations.of(context).deleteEntryHeader,
                      style: theme.accentTextTheme.body1,
                    ),
                    content: Text(
                        AppLocalizations.of(context).deleteEntryConfirmPrompt,
                        style: theme.accentTextTheme.body1),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(AppLocalizations.of(context).deleteEntryNo,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                          onPressed: () {
                            _journalEntryBloc
                                .add(DeleteJournalEntry(journalEntry));
                            Navigator.of(context).pop();
                          },
                          child: Text(
                              AppLocalizations.of(context).deleteEntryYes,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.error)))
                    ],
                  );
                });
          },
        ),
        IconButton(
          icon: Icon(
            Icons.edit,
            color: theme.colorScheme.onBackground,
          ),
          onPressed: () {
            rootNavigationService.navigateTo(FlutterAppRoutes.journalPageView,
                arguments: JournalPageArguments(entry: journalEntry));
          },
        ),
        IconButton(
          icon: Icon(Icons.share),
          color: theme.colorScheme.onBackground,
          onPressed: () {
            Share.share(_getShareText(context, journalEntry));
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final EditJournalEntryBloc _journalEntryBloc = EditJournalEntryBloc(
        analyticsRepository: AnalyticsRepository(),
        journalEntryRepository: JournalEntryRepository(),
        journalFeedBloc: BlocProvider.of<JournalFeedBloc>(context));
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (DragUpdateDetails panUpdateDetails) {
          if (panUpdateDetails.delta.dx > 0 && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
        child: BlocProvider<EditJournalEntryBloc>(
            create: (_) => _journalEntryBloc,
            child: BlocListener<EditJournalEntryBloc, EditJournalEntryState>(
              listener: (BuildContext context, EditJournalEntryState state) {
                if (state is JournalEntryDeleted) {
                  rootNavigationService.goBack();
                }
              },
              bloc: _journalEntryBloc,
              child: AnimatedBuilder(
                  animation: _animation,
                  builder: (BuildContext context, Widget animatedWidget) {
                    return LayoutBuilder(builder: (BuildContext context,
                        BoxConstraints viewportConstraints) {
                      return BackgroundGradientProvider(
                        child: SafeArea(
                          bottom: false,
                          child: NestedScrollView(
                            headerSliverBuilder:
                                (BuildContext context, bool isScrolled) {
                              return <Widget>[_renderAppBar(context)].toList();
                            },
                            body: ListView(
                              children: <Widget>[
                                _renderPhotoSlider(),
                                _renderContentSleigh(
                                    context: context,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: IntrinsicHeight(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Text(
                                                  DateFormat.yMMMMd().format(
                                                      journalEntry.date),
                                                  style: theme
                                                      .accentTextTheme.headline
                                                      .copyWith(
                                                          fontStyle: FontStyle
                                                              .italic)),
                                            ),
                                            Flexible(
                                                child: Text(journalEntry.body,
                                                    style: Theme.of(context)
                                                        .accentTextTheme
                                                        .body1)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    constraints: viewportConstraints),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  }),
            )),
      ),
    );
  }

  Widget _renderContentSleigh(
      {@required Widget child,
      @required BoxConstraints constraints,
      @required BuildContext context}) {
    final ThemeData theme = Theme.of(context);
    return FractionalTranslation(
        translation: _animation.value,
        child: Container(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 1,
                    blurRadius: 2.0,
                    offset: const Offset(0, 1),
                  )
                ],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: theme.colorScheme.onBackground),
            child: child));
  }

  Widget _renderPhotoSlider() {
    return Container(
      height: journalEntry.photographs != null &&
              journalEntry.photographs.isNotEmpty
          ? 250
          : 0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
            child: Center(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  ...Iterable<int>.generate(photographs.length)
                      .toList()
                      .map((int index) => CachedNetworkImage(
                            imageUrl: photographs[index]?.imageUrl,
                            placeholder: (BuildContext context, String image) {
                              return Container(
                                height: 250,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            imageBuilder: (BuildContext context,
                                ImageProvider<dynamic> image) {
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push<Route<dynamic>>(
                                        MaterialPageRoute<Route<dynamic>>(
                                            builder: (BuildContext c) =>
                                                PhotoViewer(
                                                  photographs: photographs,
                                                  initialIndex: index,
                                                )));
                                  },
                                  child: Image(
                                    height: 250,
                                    fit: BoxFit.cover,
                                    image: image,
                                  ),
                                ),
                              );
                            },
                          ))
                      .toList()
                ],
              )),
        )),
      ),
    );
  }
}
