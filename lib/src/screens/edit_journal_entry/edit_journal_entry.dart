import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grateful/src/blocs/edit_journal_entry/bloc.dart';
import 'package:grateful/src/blocs/image_handler/bloc.dart';
import 'package:grateful/src/blocs/journal_feed/journal_feed_bloc.dart';
import 'package:grateful/src/blocs/page_view/bloc.dart';
import 'package:grateful/src/config/environment.dart';
import 'package:grateful/src/models/journal_entry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/models/photograph.dart';
import 'package:grateful/src/repositories/analytics/analytics_repository.dart';
import 'package:grateful/src/repositories/files/file_repository.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/widgets/background_gradient_provider.dart';
import 'package:grateful/src/widgets/date_select_button.dart';
import 'package:grateful/src/widgets/image_uploader.dart';
import 'package:grateful/src/widgets/journal_entry_input.dart';
import 'package:grateful/src/widgets/no_glow_configuration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class EditJournalEntryArgs {
  EditJournalEntryArgs({this.journalEntry});

  JournalEntry journalEntry;
}

class EditJournalEntry extends StatefulWidget {
  const EditJournalEntry({this.item});

  final JournalEntry item;

  @override
  State<StatefulWidget> createState() {
    return _EditJournalEntryState(journalEntry: item);
  }

  bool get wantKeepAlive => true;
}

const double imageDimension = 125.0;

class _EditJournalEntryState extends State<EditJournalEntry>
    with AutomaticKeepAliveClientMixin {
  _EditJournalEntryState({JournalEntry journalEntry}) {
    _journalEntry = journalEntry ?? JournalEntry();
    _journalEntryController.value = const TextEditingValue(text: '');
    isEdit = journalEntry != null;
  }

  bool isEdit;

  EditJournalEntryBloc _editJournalEntryBloc;
  List<ImageHandlerBloc> _imageHandlerBlocs = <ImageHandlerBloc>[];
  JournalEntry _journalEntry;
  final TextEditingController _journalEntryController = TextEditingController();

  FileRepository fileRepository;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      fileRepository = FileRepository(
          storageBucketUrl: AppEnvironment.of(context).cloudStorageBucket);
      _initializePhotographs(_journalEntry);
    });
    setState(() {
      _journalEntry = _journalEntry;
    });
    _editJournalEntryBloc = EditJournalEntryBloc(
        analyticsRepository: AnalyticsRepository(),
        journalFeedBloc: BlocProvider.of<JournalFeedBloc>(context));
    super.initState();
    _journalEntryController.value =
        TextEditingValue(text: _journalEntry.body ?? '');
  }

  void _initializePhotographs(JournalEntry journalEntry) {
    for (final NetworkPhoto photo in journalEntry.photographs) {
      _imageHandlerBlocs.add(
          ImageHandlerBloc(fileRepository: fileRepository, photograph: photo));
    }
  }

  @override
  void dispose() {
    _editJournalEntryBloc.close();
    _imageHandlerBlocs.map((ImageHandlerBloc bloc) => bloc?.close());
    super.dispose();
  }

  void clearEditState() {
    setState(() {
      _journalEntry = JournalEntry();
      isEdit = false;
      _imageHandlerBlocs = <ImageHandlerBloc>[];
      _journalEntryController.value =
          TextEditingValue(text: _journalEntry.body ?? '');
    });
  }

  @override
  Widget build(BuildContext c) {
    super.build(c);

    return _renderFullScreenGradientScrollView(
      child: Builder(builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _entryEditComponent(context),
            ),
            _photoSliderProvider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _renderAddPhotoButton(context),
                _renderSaveCheck(context),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _renderFullScreenGradientScrollView({@required Widget child}) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool isScrolled) {
        return <Widget>[_renderSliverAppBar(this.context)];
      },
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: BackgroundGradientProvider(
          child: SafeArea(
            child: LayoutBuilder(builder:
                (BuildContext context, BoxConstraints layoutConstraints) {
              return ScrollConfiguration(
                behavior: NoGlowScroll(showLeading: true),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: layoutConstraints.maxHeight),
                    child: IntrinsicHeight(
                      child: child,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<void> _handlePickDate(BuildContext context) async {
    final DateTime newDate = await showDatePicker(
      context: context,
      initialDate: _journalEntry.date ?? DateTime.now(),
      firstDate: DateTime.parse('1900-01-01'),
      lastDate: DateTime.now(),
    );
    if (newDate != null) {
      setState(() {
        _journalEntry.date = newDate;
      });
    }
  }

  Widget _entryEditComponent(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).gratefulPrompt,
              style: theme.primaryTextTheme.headline,
              textAlign: TextAlign.left,
            ),
            DateSelectorButton(
              onPressed: _handlePickDate,
              selectedDate: _journalEntry.date,
              locale: Localizations.localeOf(context),
            ),
            Divider(
              color: theme.colorScheme.onBackground,
            ),
            const SizedBox(height: 10),
            JournalInput(
              onChanged: (String text) {
                setState(() {
                  _journalEntry.body = text;
                });
              },
              controller: _journalEntryController,
            ),
          ]),
    );
  }

  Widget _renderSliverAppBar(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 0,
      floating: false,
      pinned: false,
      leading: Container(),
      actions: <Widget>[
        if (isEdit)
          FlatButton(
            child: Icon(
              Icons.clear,
              color: theme.colorScheme.onBackground,
            ),
            onPressed: clearEditState,
          )
      ],
    );
  }

  Widget _photoSliderProvider() {
    return _editablePhotoSlider(context, _renderPhotoBlocks());
  }

  Widget _editablePhotoSlider(BuildContext context, List<Widget> children) {
    return Container(
      height: imageDimension,
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _renderSaveCheck(BuildContext context) {
    final bool isJournalEntryNull = _journalEntry.body == null;
    final ThemeData theme = Theme.of(context);
    return IconButton(
        padding: const EdgeInsets.all(50),
        icon: Icon(Icons.check, size: 40),
        disabledColor: theme.colorScheme.onBackground.withOpacity(0.6),
        onPressed: isJournalEntryNull
            ? null
            : () {
                _handleSavePress(context);
              });
  }

  void Function() _handleSavePress(BuildContext saveContext) {
    final bool photosAreFinishedUploading =
        _imageHandlerBlocs.fold<bool>(true, (bool prev, ImageHandlerBloc curr) {
      if (prev == false) {
        return false;
      }
      return curr.isUploaded;
    });
    if (!photosAreFinishedUploading) {
      return _handleSaveDisabledPress(saveContext);
    }
    if (_journalEntry.body != null) {
      _editJournalEntryBloc.add(SaveJournalEntry(_journalEntry.copyWith(
          photographs: _imageHandlerBlocs
              .where((ImageHandlerBloc bloc) => bloc.photograph is NetworkPhoto)
              .map<NetworkPhoto>(
                  (ImageHandlerBloc bloc) => bloc.photograph as NetworkPhoto)
              .toList())));
      clearEditState();
    }

    BlocProvider.of<PageViewBloc>(context).add(SetPage(1));
    return () {};
  }

  void Function() _handleSaveDisabledPress(BuildContext context) {
    return () {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          content:
              Text('Please wait until all images have finished uploading.'),
        ));
    };
  }

  List<Widget> _renderPhotoBlocks() {
    final List<Widget> photoWidgets =
        _imageHandlerBlocs.map((ImageHandlerBloc _bloc) {
      return BlocProvider<ImageHandlerBloc>(
          create: (_) => _bloc,
          child: ImageUploader(
            onRemove: (ImageHandlerBloc bloc) {
              setState(() {
                bloc.close();
                _imageHandlerBlocs.remove(_bloc);
              });
            },
          ));
    }).toList();

    return photoWidgets;
  }

  Future<void> _handleAddPhotoPress(BuildContext context) async {
    final File file = await ImagePicker.pickImage(
        imageQuality: 35, source: ImageSource.gallery);
    if (file == null) {
      return;
    }
    final FilePhoto photo = FilePhoto(file: file, guid: Uuid().v4());
    setState(() {
      _imageHandlerBlocs.add(
          ImageHandlerBloc(photograph: photo, fileRepository: fileRepository));
    });
  }

  Widget _renderAddPhotoButton(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final ThemeData theme = Theme.of(context);
    return FlatButton(
        onPressed: () {
          _handleAddPhotoPress(context);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add_a_photo,
              color: theme.colorScheme.onBackground,
            ),
            const SizedBox(width: 15),
            Text(
              localizations.addPhotos,
              style: Theme.of(context).primaryTextTheme.body1,
            ),
          ],
        ));
  }
}
