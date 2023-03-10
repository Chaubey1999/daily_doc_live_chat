import 'dart:async';
import 'dart:convert';

import 'package:daily_doc/Utils/utility_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pagination_view/pagination_view.dart';
import '../Models/local_message_model.dart';
import '../Models/message_list_model.dart';
import '../Services/db_helper.dart';

class MessageArgs {
  String? id;
  String? title;
  String? sender;
  int messageId;
  MessageArgs({this.id, this.title, this.sender, required this.messageId});
}

class MessageList extends StatefulWidget {
  MessageArgs? args;
  MessageList({Key? key, this.args}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final TextEditingController messageController = TextEditingController();
  String senderId = "";
  List<String> list = [];
  bool isLoadingData = false;
  bool hasMoreData = true;
  final ScrollController _scrollController = ScrollController();
  int? page;
  PaginationViewType? paginationViewType;
  GlobalKey<PaginationViewState>? key;

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

  List<MessageListModel> messageList = [];
  List<MessageModel> _message = [];

  StreamSocket streamSocket = StreamSocket();

  Future<List<MessageModel>> getLoacalMessage() async {
    await DatabaseHelper.instance.insertDb(
        MessageModel(id: widget.args!.messageId, name: messageController.text));
    return _message;
  }


  Future<MessageListModel> getmessages() async {
    String url =
        "https://dd-chat-0.onrender.com/api/conversations/${widget.args!.id}/messages?nextCurser=${widget.args!.id}";
    final response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      messageList.add(MessageListModel.fromJson(data));
      print(url);
      return MessageListModel.fromJson(data);
    } else {
      throw Exception("Something went Wrong");
    }
  }

  _refreshNotes() async {
    final data = await DatabaseHelper.instance.getItems();
    setState(() {
      _message.addAll(data);
    });
  }

  late DatabaseHelper _sqliteService;
  void initState() {
    page = -1;
    paginationViewType = PaginationViewType.listView;
    key = GlobalKey<PaginationViewState>();
    _sqliteService = DatabaseHelper();
    _sqliteService.initDB().whenComplete(() async {
      await _refreshNotes();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ElevatedButton(onPressed: () async {
              //   var data = await DatabaseHelper.instance.queryDb();
              //   // String path = await getDatabasesPath();
              //   // print(path);
              //   print(data);
              // }, child: Text("Load")),
              StreamBuilder(
                  stream: getmessages().asStream(),
                  builder: (context, AsyncSnapshot<MessageListModel> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        controller: _scrollController,
                        itemCount: hasMoreData
                            ? snapshot.data!.data!.messages!.length
                            : snapshot.data!.data!.messages!.length,
                        itemBuilder: (context, index) {
                          // int firstIndex = _currentPage * _messagePerPage;
                          // int lastIndex = firstIndex + _messagePerPage - 1;
                          senderId = snapshot
                              .data!.data!.messages![index].conversation!
                              .toString();
                          // if (index >= firstIndex && index <= lastIndex) {
                          if (index < snapshot.data!.data!.messages!.length) {
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
                                        style: const TextStyle(
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
                                ],
                              ),
                            );
                          } else {
                            return ListTile(
                              title: Text("No more data"),
                            );
                          }
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 10,
                          );
                        },
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
              StreamBuilder(
                  stream: streamSocket.getResponse,
                  builder:
                      (context, AsyncSnapshot<List<MessageModel>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          print(_message[index].name);
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
                                      snapshot.data![index].name ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                                Text(
                                  "07:39",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 10,
                          );
                        },
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
              // StreamBuilder(
              //   stream: streamSocket.getResponse,
              //   builder: (BuildContext context, AsyncSnapshot<List<MessageModel>> snapshot) {
              //     if(snapshot.connectionState == ConnectionState.waiting){
              //       return Center(child: const CircularProgressIndicator());
              //     }else if(snapshot.hasError){
              //       return Text('error'+snapshot.error.toString());
              //     }else if(snapshot.connectionState == ConnectionState.active){
              //       return Expanded(
              //         child: ListView.builder(
              //             itemCount: snapshot.data!.length,
              //             itemBuilder: (context, index){
              //               return    Align(
              //                 alignment: Alignment.topRight,
              //                 child: Column(
              //                   children: [
              //                     Container(
              //                       decoration: BoxDecoration(
              //                           color: Colors.lightBlueAccent,
              //                           borderRadius: BorderRadius.circular(8)),
              //                       child: Padding(
              //                         padding: const EdgeInsets.all(8.0),
              //                         child: Text(
              //                           snapshot.data![index]
              //                               .name ??
              //                               "",
              //                           style: const TextStyle(
              //                               fontWeight: FontWeight.w500,
              //                               fontSize: 14),
              //                         ),
              //                       ),
              //                     ),
              //                     Text(
              //                       "07:32 AM",
              //                       style: TextStyle(
              //                           fontSize: 12,
              //                           fontWeight: FontWeight.w400),
              //                     ),
              //                   ],
              //                 ),
              //               );
              //             }
              //         ),
              //       );
              //     }else {
              //       return Text('some thing went wrong');
              //     }
              //   },
              // ),
              if (isLoadingData)
                Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator.adaptive()),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: sendMessageWidget(context, senderId))
            ],
          ),
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
        onPressed: () async {
          widget.args?.messageId++;
          _message.add(MessageModel(
              id: widget.args!.messageId, name: messageController.text));
          streamSocket.addResponse(_message);
          messageController.clear();
          // await DatabaseHelper.instance.insertDb({DatabaseHelper.columnName : messageController.text});
          await DatabaseHelper.instance.insertDb(MessageModel(
              id: widget.args!.messageId, name: messageController.text));
          sendMessage(messageController.text);
          messageController.clear();
        },
        icon: Icon(Icons.send),
      ),
    );
  }
}

class StreamSocket {
  final _socketResponse = StreamController<List<MessageModel>>.broadcast();
  void Function(List<MessageModel> event) get addResponse =>
      _socketResponse.sink.add;
  Stream<List<MessageModel>> get getResponse =>
      _socketResponse.stream.asBroadcastStream();
}
