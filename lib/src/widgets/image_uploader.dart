import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/image_handler/bloc.dart';
import 'package:grateful/src/models/photograph.dart';
import 'package:grateful/src/widgets/deletable_resource.dart';

typedef OnRemove = void Function(ImageHandlerBloc imageHandlerBloc);

class ImageUploader extends StatelessWidget {
  const ImageUploader({@required OnRemove onRemove}) : _onRemove = onRemove;

  final OnRemove _onRemove;

  Widget _makeImageDeletable(BuildContext context, Widget child) {
    return DeletableResource(
        child: child,
        onRemove: () {
          _onRemove(BlocProvider.of<ImageHandlerBloc>(context));
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageHandlerBloc, ImageHandlerState>(
        builder: (BuildContext context, ImageHandlerState state) {
          if (state is FileUploaded) {
            return _makeImageDeletable(
                context,
                CachedNetworkImage(
                    imageUrl: (state.photograph as NetworkPhoto).imageUrl,
                    placeholder: (BuildContext context, String url) {
                      return state.placeholder != null
                          ? Image.file(state.placeholder?.file)
                          : Container();
                    }));
          }
          return Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              if (state.photograph is FilePhoto)
                Image.file((state.photograph as FilePhoto).file)
              else
                _makeImageDeletable(
                    context,
                    CachedNetworkImage(
                      imageUrl: (state.photograph as NetworkPhoto).imageUrl,
                    )),
              if (state is UploadProgress)
                Positioned.fill(
                    child: Container(
                  color: Colors.black38,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.black38,
                      value: state.fileProgress,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ))
              else
                Container()
            ],
          );
        },
        bloc: BlocProvider.of<ImageHandlerBloc>(context));
  }
}
