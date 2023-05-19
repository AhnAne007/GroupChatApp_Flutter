import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../resources/database_service.dart';
import '../widgets/message_tile_widget.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage(
      {Key? key,
        required this.groupId,
        required this.groupName,
        required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin = "";
  final TextEditingController _message = TextEditingController();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  late String textToCopy;

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  //a future function to select a file from the gallery and then assigning to the picked file
  Future onPickFile() async {
    final file = await FilePicker.platform.pickFiles();
    if (file == null)
      return null;
    else {
      setState(() {
        pickedFile = file.files.first;
      });
    }
  }

  //A function to upload a file in firebase storage
  Future onUploadFile() async {
    try {
      final path = 'files/${pickedFile?.name}';
      final file2 = File(pickedFile!.path!);
      print("hi after the file is picked");
      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file2);
      print("hi after the file is uploaded");

      final snapshot = await uploadTask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      setState(() {
        _message.text = urlDownload;
      });
    } on FirebaseException catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:Colors.lime[50],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Colors.lightGreenAccent[700],
        actions: [
          IconButton(
              onPressed: () {
                // nextScreen(
                //     context,
                //     GroupInfo(
                //       groupId: widget.groupId,
                //       groupName: widget.groupName,
                //       adminName: admin,
                //     ));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Stack(
        children: <Widget>[
          chatMessages(),
          Container(
            //height: size.height / 10,
            width: size.width,
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              height: 70.0,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_file),
                    iconSize: 25.0,
                    color: Colors.black,
                    onPressed: () {
                      onPickFile();
                      // print(pickedFile?.name);
                      onUploadFile();
//                        onSendMessage();
                    },
                  ),
                  Expanded(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: _message,
                      onChanged: (value) {},
                      decoration: InputDecoration.collapsed(
                        hintText: 'Send a message...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    iconSize: 25.0,
                    color: Colors.grey,
                    onPressed: () {
                      sendMessage();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return MessageTile(
                message: snapshot.data.docs[index]['message'],
                sender: snapshot.data.docs[index]['sender'],
                sentByMe: widget.userName ==
                    snapshot.data.docs[index]['sender']);
          },
        )
            : Container();
      },
    );
  }

  sendMessage() {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": _message.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        _message.clear();
      });
    }
  }
}