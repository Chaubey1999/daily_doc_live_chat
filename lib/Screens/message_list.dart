import 'dart:async';
import 'dart:convert';

import 'package:daily_doc/Utils/utility_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../Models/message_list_model.dart';

class MessageArgs {
  String? id;
  String? title;
  String? sender;
  MessageArgs({this.id, this.title, this.sender});
}

class MessageList extends StatefulWidget {
  MessageArgs? args;
  MessageList({Key? key, this.args}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  TextEditingController messageController = TextEditingController();
  String senderId = "";
  List<String> list = [];
  // int _currentPage = 0;
  // int _messagePerPage = 20;
  // List<MessageListModel> _message = [];

  void sendMessage(String text) async {
    String url =
        "https://dd-chat-0.onrender.com/api/conversations/63f5c489f32cc275764a7e15/messages";
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(url));
    request.body =
        json.encode({"text": text, "sender": "63cbba28bed83250e51dcc5d"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      print(url);
    } else {
      print(response.reasonPhrase);
      print(url);
    }
  }

  Future<MessageListModel> getmessages() async {
    String url =
        "https://dd-chat-0.onrender.com/api/conversations/${widget.args!.id}/messages?nextCurser=${widget.args!.id}";
    final response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      print(url);
      return MessageListModel.fromJson(data);
    } else {
      throw Exception("Something went Wrong");
    }
  }
  // Future<List<MessageListModel>> fetchMessgae(int a,int b) async {
  //   String url =
  //       "https://dd-chat-0.onrender.com/api/conversations/${widget.args!.id}/messages?nextCurser=${widget.args!.id}";
  //   final response = await http.get(Uri.parse(url));
  //   var data = jsonDecode(response.body.toString());
  //   if (response.statusCode == 200) {
  //     for(Map i in data){
  //       _message.add(MessageListModel.fromJson(jsonDecode(i as String)));
  //     }
  //     print(url);
  //     return _message;
  //   } else {
  //     throw Exception("Something went Wrong");
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: sendMessageWidget(context, senderId),
      appBar: AppBar(
        title: ListTile(
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30)),
              child: Icon(
                Icons.person_4,
                size: 20,
              ),
            ),
            title: Text(widget.args!.title ?? "")),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder(
                future: getmessages(),
                builder: (context, AsyncSnapshot<MessageListModel> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.separated(
                        itemCount: snapshot.data!.data!.messages!.length,
                        itemBuilder: (context, index) {
                          // int firstIndex = _currentPage * _messagePerPage;
                          // int lastIndex = firstIndex + _messagePerPage - 1;
                          senderId = snapshot
                              .data!.data!.messages![index].conversation!
                              .toString();
                          // if (index >= firstIndex && index <= lastIndex) {
                            return Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlueAccent,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        snapshot.data!.data!.messages![index]
                                                .text ??
                                            "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    FormattingMethods.conversationDate(
                                        DateTime.parse(snapshot.data!.data!
                                                .messages![index].createdAt ??
                                            "")),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  // ElevatedButton(onPressed: (){
                                  //   setState(() {
                                  //     // _currentPage++;
                                  //     // _message.addAll(fetchMessgae(_currentPage, _messagePerPage) as Iterable<MessageListModel>);
                                  //   });
                                  // }, child: Text("Load more"))
                                ],
                              ),
                            );
                          // }else{
                          //   return Container();
                          // }
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 10,
                          );
                        },
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Text("Something Went Wrong"),
                    );
                  }
                }),
            Align(
                alignment: Alignment.bottomCenter,
                child: sendMessageWidget(context, senderId))
          ],
        ),
      ),
    );
  }

  Widget sendMessageWidget(BuildContext context, String senderId) {
    return ListTile(
      leading: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(30)),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 20,
        ),
      ),
      title: TextFormField(
        controller: messageController,
        decoration: InputDecoration(hintText: "Send a message"),
      ),
      trailing: IconButton(
        onPressed: () {
          sendMessage(messageController.text);
          messageController.clear();
        },
        icon: Icon(Icons.send),
      ),
    );
  }
}



