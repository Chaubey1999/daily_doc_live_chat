// To parse this JSON data, do
//
//     final messageListModel = messageListModelFromJson(jsonString);

import 'dart:convert';

MessageListModel messageListModelFromJson(String str) => MessageListModel.fromJson(json.decode(str));

String messageListModelToJson(MessageListModel data) => json.encode(data.toJson());

class MessageListModel {
  MessageListModel({
    this.error,
    this.data,
  });

  bool? error;
  Data? data;

  factory MessageListModel.fromJson(Map<String, dynamic> json) => MessageListModel(
    error: json["error"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.nextCurser,
    this.messages,
  });

  String? nextCurser;
  List<Message>? messages;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    nextCurser: json["nextCurser"],
    messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "nextCurser": nextCurser,
    "messages": List<dynamic>.from(messages!.map((x) => x.toJson())),
  };
}

class Message {
  Message({
    this.id,
    this.text,
    this.conversation,
    this.sender,
    this.material,
    this.v,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? text;
  Conversation? conversation;
  Sender? sender;
  String? material;
  int? v;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["_id"],
    text: json["text"],
    conversation: conversationValues.map[json["conversation"]],
    sender: senderValues.map[json["sender"]],
    material: json["material"],
    v: json["__v"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "text": text,
    "conversation": conversationValues.reverse[conversation],
    "sender": senderValues.reverse[sender],
    "material": material,
    "__v": v,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}

enum Conversation { THE_63_F5_C489_F32_CC275764_A7_E0_C }

final conversationValues = EnumValues({
  "63f5c489f32cc275764a7e0c": Conversation.THE_63_F5_C489_F32_CC275764_A7_E0_C
});

enum Sender { THE_63_CBBA1_FBED83250_E51_DCC59, THE_63_CBBA28_BED83250_E51_DCC5_D }

final senderValues = EnumValues({
  "63cbba1fbed83250e51dcc59": Sender.THE_63_CBBA1_FBED83250_E51_DCC59,
  "63cbba28bed83250e51dcc5d": Sender.THE_63_CBBA28_BED83250_E51_DCC5_D
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
