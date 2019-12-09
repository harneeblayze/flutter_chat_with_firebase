import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ConversationScreen extends StatefulWidget {
  final String otherUserId;
  final String currentUserid;

  ConversationScreen({this.otherUserId, this.currentUserid});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  var listMessage;
  String commonChatId = "";

  bool isLoading;

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController chatScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    isLoading = false;

    super.initState();

    getCommonChatId();
  }

  void getCommonChatId() {
    if (widget.currentUserid.hashCode <= widget.otherUserId.hashCode) {
      commonChatId = '${widget.currentUserid}-${widget.otherUserId}';
    } else {
      commonChatId = '${widget.otherUserId}-${widget.currentUserid}';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          'CHAT',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[buildMessageList(), buildInput()],
          ),
          showLoading()
        ],
      ),
    );
  }

  Widget buildMessageList() {
    return Flexible(
      child: commonChatId == ""
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('Messages')
                  .document(commonChatId)
                  .collection(commonChatId)
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue)));
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(5.0),
                    itemBuilder: (context, index) =>
                        _buildChatItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    controller: chatScrollController,
                  );
                }
              },
            ),
    );
  }

  Widget showLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.lightBlue)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.black54, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey.shade300),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => handleSendMessage(textEditingController.text),
                color: Colors.lightBlue,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(
              top: new BorderSide(color: Color(0xffE8E8E8), width: 0.5)),
          color: Colors.white),
    );
  }

  _buildChatItem(int index, document) {
    if (document['from'] == widget.currentUserid) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Text(
                  document['message'],
                  style: TextStyle(color: Colors.white),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: 200.0,
                decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(5.0)),
                margin: EdgeInsets.only(bottom: 7.0, right: 10.0),
              ),
              Container(
                child: Text(
                  new DateFormat('EEE, MMM d hh:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.parse(document['timestamp']))),
                  style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic),
                ),
                margin: EdgeInsets.only(bottom: 5.0, right: 10),
              )
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  document['message'],
                  style: TextStyle(color: Colors.white),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: 200.0,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5.0)),
                margin: EdgeInsets.only(bottom: 7.0, right: 10.0, left: 10),
              ),
              Container(
                child: Text(
                  new DateFormat('EEE, MMM d hh:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.parse(document['timestamp']))),
                  style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic),
                ),
                margin: EdgeInsets.only(bottom: 5.0, left: 10),
              )
            ],
          ),
        ],
      );
    }
  }

  void handleSendMessage(String message) {
    if (message.trim().isNotEmpty) {
      textEditingController.clear();

      Map<String, String> messageMap = Map();
      messageMap["from"] = widget.currentUserid;
      messageMap["to"] = widget.otherUserId;
      messageMap["timestamp"] =
          DateTime.now().millisecondsSinceEpoch.toString();
      messageMap["message"] = message;

      var documentReference = Firestore.instance
          .collection('Messages')
          .document(commonChatId)
          .collection(commonChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      documentReference.setData(messageMap);

      chatScrollController.animateTo(10000.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Message must not be empty');
    }
  }
}
