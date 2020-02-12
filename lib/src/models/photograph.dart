import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

abstract class Photograph {}

class NetworkPhoto extends Photograph {
  NetworkPhoto({
    this.title,
    this.description,
    this.imageUrl,
  });

  String description;
  String imageUrl;
  String title;

  @override
  int get hashCode => title.hashCode ^ description.hashCode ^ imageUrl.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is NetworkPhoto &&
        other.title == title &&
        other.description == description &&
        other.imageUrl == imageUrl;
  }

  @override
  String toString() =>
      'Photograph title: $title, description: $description, imageUrl: $imageUrl';

  NetworkPhoto copyWith({
    String title,
    String description,
    String imageUrl,
  }) {
    return NetworkPhoto(
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  static NetworkPhoto fromMap(Map<dynamic, dynamic> map) {
    if (map == null) {
      return null;
    }

    return NetworkPhoto(
      title: map['title'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  static NetworkPhoto fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}

class FilePhoto extends Photograph {
  FilePhoto({String guid, @required this.file, this.title, this.description})
      : guid = guid ?? Uuid().v4();

  final String description;
  final File file;
  final String guid;
  final String title;
}
