class MessageListModel {
  bool? error;
  Data? data;

  MessageListModel({this.error, this.data});

  MessageListModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? nextCurser;
  List<Messages>? messages;

  Data({this.nextCurser, this.messages});

  Data.fromJson(Map<String, dynamic> json) {
    nextCurser = json['nextCurser'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nextCurser'] = this.nextCurser;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  String? sId;
  String? text;
  String? conversation;
  String? sender;
  String? material;
  int? iV;
  String? createdAt;
  String? updatedAt;

  Messages(
      {this.sId,
        this.text,
        this.conversation,
        this.sender,
        this.material,
        this.iV,
        this.createdAt,
        this.updatedAt});

  Messages.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    text = json['text'];
    conversation = json['conversation'];
    sender = json['sender'];
    material = json['material'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['text'] = this.text;
    data['conversation'] = this.conversation;
    data['sender'] = this.sender;
    data['material'] = this.material;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}