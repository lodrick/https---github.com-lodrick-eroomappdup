import '../utils.dart';
import 'package:eRoomApp/utils.dart';

class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {
  final String idFrom;
  final String idTo;
  final String content;
  final int type;
  final DateTime createdAt;

  const Message({
    required this.idFrom,
    required this.idTo,
    required this.content,
    required this.type,
    required this.createdAt,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
        idFrom: json['idFrom'],
        idTo: json['idTo'],
        content: json['content'],
        type: json['type'],
        createdAt: Utils.toDateTime(json['timestamp'])!,
      );

  Map<String, dynamic> toJson() => {
        'idFrom': idFrom,
        'idTo': idTo,
        'content': content,
        'type': type,
        'timestamp': Utils.fromDateTimeToJson(createdAt),
      };
}
