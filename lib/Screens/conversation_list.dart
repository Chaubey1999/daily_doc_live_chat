import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/conversation_list_model.dart';
import '../Utils/utility_methods.dart';

class ConversationList extends StatefulWidget {
  const ConversationList({Key? key}) : super(key: key);

  @override
  State<ConversationList> createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {


  Future<ConversationListModel> getConversation() async {
    final response = await http.get(Uri.parse("https://dd-chat-0.onrender.com/api/conversations"));
    var data = jsonDecode(response.body.toString());
    if(response.statusCode==200){
      return ConversationListModel.fromJson(data);
    }else{
      throw Exception("Something went wrong");
    }
  }
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)
            ),
            width: Mq.width(context) * 0.6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(Icons.search,color: Colors.grey,),
                  SizedBox(width: 10,),
                  Text("Search Provider",style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey
                  ))
                ],
              ),
            ),
          ),
          bottom: TabBar(tabs: [
            Tab(text: "Message",),
            Tab(text: "Patients",),
          ]),
        ),
        body: TabBarView(
          children: [
            conversation(context, theme),
            conversation(context, theme),
          ],
        ),
      ),
    );
  }
  Widget conversation(BuildContext context,TextTheme theme){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue),
                color: Colors.white,
                borderRadius: BorderRadius.circular(16)
            ),
            width: Mq.width(context) * 0.7,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(Icons.search,color: Colors.grey,),
                  SizedBox(width: 15,),
                  Text("Search Sender by name",style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey
                  ))
                ],
              ),
            ),
          ),
          FutureBuilder(
              future: getConversation(),
              builder: (context, AsyncSnapshot<ConversationListModel> snapshot){
            if(snapshot.hasData){
              return Expanded(
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Container(
                                height: 70,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.lightBlueAccent.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                child: Icon(Icons.person_4,size: 20,),
                              ),
                              title: Text(snapshot.data!.data![index].title??"",style: TextStyle(
                                  fontWeight: FontWeight.w600
                              ),),
                              subtitle: Text(snapshot.data!.data![index].lastMessage??""),
                              trailing: Text(FormattingMethods.conversationDate(snapshot.data!.data![index].createdAt??DateTime.now())),
                            ),
                            Container(
                              color: Colors.grey.withOpacity(0.5),
                              height: 1,
                              width: double.infinity,
                            )
                          ],
                        ),
                      );
                    }),
              );
            }else{
              return Center(child: Text("Something went wrong"));
            }
          })

        ],
      ),
    );
  }
}
