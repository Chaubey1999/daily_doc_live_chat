// import 'dart:convert';
//
// MessageModel messageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));
//
// String messageModelToJson(MessageModel data) => json.encode(data.toJson());
//
// class MessageModel {
//   MessageData? data;
//   // final int id;
//   // final String name;
//   MessageModel({this.data});
//
//   factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
//     data: MessageData.fromJson(json["data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "data": data?.toJson(),
//   };
// }
// class MessageData{
//
//   GetAllMessage? getAllMessage;
//   MessageData({this.getAllMessage});
//
//   factory MessageData.fromJson(Map<String, dynamic> json)=>MessageData(
//     getAllMessage: GetAllMessage.fromJson(json["getAllMessage"]),
//   );
//   Map<String, dynamic> toJson() =>{
//     "getAllMessage" : getAllMessage!.toJson(),
//   };
// }
// class GetAllMessage{
//   List<Item>? items;
//   GetAllMessage({this.items});
//   factory GetAllMessage.fromJson(Map<String,dynamic> json)=>GetAllMessage(
//     items: List<Item>.from(json["items"].map((x)=>x.toJson())),
//   );
//
//   Map<String,dynamic> toJson()=>{
//     "items" : List<dynamic>.from(items!.map((e) => e.toJson())),
//   };
// }
// class Item{
//   int? id;
//   String? message;
//
//   Item({this.id,this.message});
//
//   factory Item.fromJson(Map<String,dynamic> json)=>Item(
//       id: json["id"],
//       message: json["message"]
//   );
//   Map<String,dynamic> toJson()=>{
//     "id":id,
//     "message":message,
//   };
// }
class MessageModel{
  final int id;
  final String name;

  MessageModel({required this.id, required this.name});

  MessageModel.fromMap(Map<String, dynamic> item):
        id=item["id"], name= item["name"];

  Map<String, Object> toMap(){
    return {'id':id,'name': name};
  }
}