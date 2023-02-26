// To parse this JSON data, do
//
//     final conversationListModel = conversationListModelFromJson(jsonString);

import 'dart:convert';

ConversationListModel conversationListModelFromJson(String str) => ConversationListModel.fromJson(json.decode(str));

String conversationListModelToJson(ConversationListModel data) => json.encode(data.toJson());

class ConversationListModel {
  ConversationListModel({
    this.error,
    this.data,
  });

  bool? error;
  List<Datum>? data;

  factory ConversationListModel.fromJson(Map<String, dynamic> json) => ConversationListModel(
    error: json["error"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.participants,
    this.image,
    this.lastMessage,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  String? title;
  List<Participant>? participants;
  String? image;
  String? lastMessage;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    title: json["title"],
    participants: List<Participant>.from(json["participants"].map((x) => participantValues.map[x])),
    image: json["image"],
    lastMessage: json["lastMessage"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "participants": List<dynamic>.from(participants!.map((x) => participantValues.reverse[x])),
    "image": image,
    "lastMessage": lastMessage,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
  };
}

enum Participant { THE_63_CBBA28_BED83250_E51_DCC5_D, THE_63_CBBA1_FBED83250_E51_DCC59 }

final participantValues = EnumValues({
  "63cbba1fbed83250e51dcc59": Participant.THE_63_CBBA1_FBED83250_E51_DCC59,
  "63cbba28bed83250e51dcc5d": Participant.THE_63_CBBA28_BED83250_E51_DCC5_D
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
