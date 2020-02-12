import 'dart:convert';

import 'package:grateful/src/models/photograph.dart';
import 'package:uuid/uuid.dart';

class JournalEntry {
  JournalEntry({
    String id,
    this.body,
    this.description,
    DateTime date,
    List<NetworkPhoto> photographs,
  })  : id = id ?? Uuid().v4(),
        date = date ?? DateTime.now(),
        photographs = photographs ?? <NetworkPhoto>[];

  String body;
  DateTime date;
  String description;
  String id;
  List<NetworkPhoto> photographs;

  @override
  int get hashCode {
    return id.hashCode ^
        body.hashCode ^
        description.hashCode ^
        date.hashCode ^
        photographs.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is JournalEntry &&
        other.id == id &&
        other.body == body &&
        other.description == description &&
        other.date == date &&
        other.photographs == photographs;
  }

  @override
  String toString() {
    return 'JournalEntry id: $id, body: $body, description: $description, date: $date, photographs: $photographs';
  }

  JournalEntry copyWith({
    String id,
    String body,
    String description,
    DateTime date,
    List<NetworkPhoto> photographs,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      body: body ?? this.body,
      description: description ?? this.description,
      date: date ?? this.date,
      photographs: photographs ?? this.photographs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'body': body,
      'description': description,
      'date': date.toUtc().toIso8601String(),
      'photographs': List<dynamic>.from(
          photographs.map<Map<String, dynamic>>((NetworkPhoto x) => x.toMap())),
    };
  }

  static DateTime _parseDate(dynamic datestamp) {
    if (datestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(datestamp);
    } else if (datestamp is String) {
      return DateTime.tryParse(datestamp).toLocal();
    }
    return null;
  }

  static JournalEntry fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return JournalEntry(
      id: map['id'] as String,
      body: map['body'] as String,
      description: map['description'] as String,
      date: _parseDate(map['date']),
      photographs: List<NetworkPhoto>.from(
          (map['photographs'] as Iterable<Map<String, dynamic>>)
              ?.map<NetworkPhoto>(
                  (Map<String, dynamic> x) => NetworkPhoto.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static JournalEntry fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}
