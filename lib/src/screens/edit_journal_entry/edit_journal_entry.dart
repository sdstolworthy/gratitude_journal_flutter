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
  EditJournalEntry({this.item});

  final JournalEntry item;

  @override
  State<StatefulWidget> createState() {
    return _EditJournalEntryState(journalEntry: this.item);
  }

  bool get wantKeepAlive => true;
}

const double imageDimension = 125.0;

class _EditJournalEntryState extends State<EditJournalEntry>
    with AutomaticKeepAliveClientMixin {
  _EditJournalEntryState({JournalEntry journalEntry}) {
    this._journalEntry = journalEntry ?? JournalEntry();
    _journalEntryController.value = TextEditingValue(text: '');
    isEdit = journalEntry != null;
  }

  bool isEdit;

  EditJournalEntryBloc _editJournalEntryBloc;
  List<ImageHandlerBloc> _imageHandlerBlocs = [];
  JournalEntry _journalEntry;
  final TextEditingController _journalEntryController = TextEditingController();

  FileRepository fileRepository;

  bool get wantKeepAlive => true;

  initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      fileRepository = FileRepository(
          storageBucketUrl: AppEnvironment.of(context).cloudStorageBucket);
      _initializePhotographs(_journalEntry);
    });
    setState(() {
      _journalEntry = this._journalEntry;
    });
    _editJournalEntryBloc = EditJournalEntryBloc(
        analyticsRepository: new AnalyticsRepository(),
        journalFeedBloc: BlocProvider.of<JournalFeedBloc>(context));
    super.initState();
    _journalEntryController.value =
        TextEditingValue(text: _journalEntry.body ?? '');
  }

  _initializePhotographs(JournalEntry journalEntry) {
    journalEntry.photographs.forEach((photo) => _imageHandlerBlocs.add(
        new ImageHandlerBloc(
            fileRepository: fileRepository, photograph: photo)));
  }

  dispose() {
    _editJournalEntryBloc.close();
    this._imageHandlerBlocs.map((bloc) => bloc?.close());
    super.dispose();
  }

  clearEditState() {
    setState(() {
      _journalEntry = JournalEntry();
      isEdit = false;
      _imageHandlerBlocs = [];
      _journalEntryController.value =
          TextEditingValue(text: _journalEntry.body ?? '');
    });
  }

  build(c) {
    super.build(c);

    return _renderFullScreenGradientScrollView(
      child: Builder(builder: (context) {
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
            )
          ],
        );
      }),
    );
  }

  Widget _renderFullScreenGradientScrollView({@required Widget child}) {
    return NestedScrollView(
      headerSliverBuilder: (context, isScrolled) {
        return [_renderSliverAppBar(this.context)];
      },
      body: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(this.context).requestFocus(new FocusNode());
          },
          child: BackgroundGradientProvider(
            child: SafeArea(
              child: LayoutBuilder(builder: (context, layoutConstraints) {
                return ScrollConfiguration(
                  behavior: NoGlowScroll(showLeading: true),
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: layoutConstraints.maxHeight),
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
      ),
    );
  }

  void _handlePickDate(context) async {
    DateTime newDate = await showDatePicker(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          AppLocalizations.of(context).gratefulPrompt,
          style: Theme.of(context).primaryTextTheme.headline,
          textAlign: TextAlign.left,
        ),
        DateSelectorButton(
          onPressed: _handlePickDate,
          selectedDate: _journalEntry.date,
          locale: Localizations.localeOf(context),
        ),
        Divider(
          color: Colors.white,
        ),
        SizedBox(height: 10),
        JournalInput(
          onChanged: (text) {
            setState(() {
              _journalEntry.body = text;
            });
          },
          controller: _journalEntryController,
        ),
      ]),
    );
  }

  Widget _renderSliverAppBar(context) {
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
              color: Colors.white,
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

  _renderSaveCheck(BuildContext saveContext) {
    final isJournalEntryNull = this._journalEntry.body == null;
    return IconButton(
        padding: EdgeInsets.all(50),
        icon: Icon(Icons.check, size: 40),
        disabledColor: Colors.white38,
        onPressed: isJournalEntryNull
            ? null
            : () {
                _handleSavePress(saveContext);
              });
  }

  _handleSavePress(BuildContext saveContext) {
    final photosAreFinishedUploading =
        _imageHandlerBlocs.fold<bool>(true, (prev, curr) {
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
              .where((bloc) => bloc.photograph is NetworkPhoto)
              .map<NetworkPhoto>((bloc) => bloc.photograph)
              .toList())));
      this.clearEditState();
    }

    BlocProvider.of<PageViewBloc>(context).add(SetPage(1));
  }

  _handleSaveDisabledPress(BuildContext context) {
    return () {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content:
              Text('Please wait until all images have finished uploading.'),
        ));
    };
  }

  _renderPhotoBlocks() {
    final photoWidgets = _imageHandlerBlocs.map((_bloc) {
      return BlocProvider(
          create: (_) => _bloc,
          child: ImageUploader(
            onRemove: (ImageHandlerBloc bloc) {
              setState(() {
                bloc.close();
                this._imageHandlerBlocs.remove(_bloc);
              });
            },
          ));
    }).toList();

    return photoWidgets;
  }

  _handleAddPhotoPress(context) async {
    File file = await ImagePicker.pickImage(
        imageQuality: 35, source: ImageSource.gallery);
    if (file == null) {
      return;
    }
    final FilePhoto photo = new FilePhoto(file: file, guid: Uuid().v4());
    setState(() {
      _imageHandlerBlocs.add(new ImageHandlerBloc(
          photograph: photo, fileRepository: fileRepository));
    });
  }

  _renderAddPhotoButton(context) {
    final localizations = AppLocalizations.of(context);

    return FlatButton(
        onPressed: () {
          _handleAddPhotoPress(context);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add_a_photo,
              color: Colors.white,
            ),
            SizedBox(width: 15),
            Text(
              localizations.addPhotos,
              style: Theme.of(context).primaryTextTheme.body1,
            ),
          ],
        ));
  }
}
