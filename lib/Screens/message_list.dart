import 'dart:convert';

import 'package:daily_doc/Utils/utility_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/message_list_model.dart';

class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  Future<MessageListModel> getmessages() async {
    final response = await http.get(Uri.parse(
        "https://dd-chat-0.onrender.com/api/conversations/63f5c489f32cc275764a7e0c/messages?nextCurser=63f5c489f32cc275764a7e0c"));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return MessageListModel.fromJson(data);
    } else {
      throw Exception("Something went Wrong");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: sendMessageWidget(context),
      appBar: AppBar(
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
                            return Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                children: [
                                  Container(
                                    decoration : BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                      borderRadius: BorderRadius.circular(8)
                              ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          snapshot.data!.data!.messages![index].text ?? "",style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14
                                      ),),
                                    ),
                                  ),
                                  Text(FormattingMethods.conversationDate(snapshot.data!.data!.messages![index].createdAt??DateTime.now()),style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400
                                  ),)
                                ],
                              ),
                            );
                          }, separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 10,); },),
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
                })
          ],
        ),
      ),
    );
  }
  Widget sendMessageWidget(BuildContext context){
    TextEditingController messageController = TextEditingController();
    return ListTile(
      leading: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(30)
      ),
        child: Icon(Icons.add,color: Colors.white,size: 20,),
      ),
      title: TextFormField(
        controller: messageController,
        decoration: InputDecoration(
          hintText: "Send a message"
        ),
      ),
      trailing: IconButton(onPressed: () {  }, icon: Icon(Icons.send),
        
      ),
    );
  }
}
