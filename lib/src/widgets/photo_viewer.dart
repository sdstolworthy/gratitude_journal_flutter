import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grateful/src/models/photograph.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer extends StatefulWidget {
  const PhotoViewer({this.photographs, this.initialIndex = 0});

  final int initialIndex;
  final List<NetworkPhoto> photographs;

  @override
  _PhotoViewerState createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialIndex);
  }

  Widget _renderPhotoView(NetworkPhoto photograph) {
    return PhotoView(
      imageProvider: CachedNetworkImageProvider(photograph.imageUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photographs.isEmpty) {}
    return Scaffold(
        body: Container(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          PageView(
            controller: pageController,
            children: widget.photographs
                .map((NetworkPhoto photograph) => _renderPhotoView(photograph))
                .toList(),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.black26,
            ),
          ),
        ],
      ),
    ));
  }
}
