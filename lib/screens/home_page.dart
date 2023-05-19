import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/resources/database_service.dart';

import '../resources/auth_methods.dart';
import '../widgets/group_tile_widget.dart';
import '../widgets/rounded_input_field.dart';
import '../widgets/snackbar_widget.dart';
import 'login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseService databaseService = DatabaseService();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userMap;
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  String userName = "";


  void searchUser() async {
    await firebaseFirestore
        .collection("users")
        .where("name", isEqualTo: _searchController.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        print(userMap);
      });
    });
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }


  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await DatabaseService(uid: _auth.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        backgroundColor: Colors.lime[50],
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await AuthMethods().loginOut();
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LogInScreen();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.logout)),
          ],
          backgroundColor: Colors.lightGreenAccent[700],
          centerTitle: true,
          title: const Text("Chats"),
        ),
        body: groupList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.deepOrangeAccent,
          child: Icon(
            Icons.add,
            size: 30,),
        )
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Create a group",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                    child: CircularProgressIndicator(
                        color: Theme
                            .of(context)
                            .primaryColor),
                  )
                      : TextField(
                    onChanged: (val) {
                      setState(() {
                        groupName = val;
                      });
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor),
                            borderRadius: BorderRadius.circular(20)),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme
                                    .of(context)
                                    .primaryColor),
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme
                          .of(context)
                          .primaryColor),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(
                          uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(userName,
                          FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackbar(
                          context, Colors.green, "Group created successfully.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme
                          .of(context)
                          .primaryColor),
                  child: const Text("CREATE"),
                )
              ],
            );
          }));
        });
  }


  groupList() {
    Size size = MediaQuery
        .of(context)
        .size;
    return Center(
        child: Column(
        children: [
        Container(
        width: size.width - 90,
        height: size.height * 0.01,
    ),
    RoundedInputField(
    textEditingController: _searchController,
    hintText: 'Search by email',
    icon: Icons.search,
    onChanged: (String value) {},
    ),
    Container(
    padding: EdgeInsets.symmetric(horizontal: 150, vertical: 10),
    child: ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.lightGreenAccent[400],
//padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
    textStyle:
    TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    onPressed: () {
    searchUser();
    },
    child: Text(
    "Search".toUpperCase(),
    style: TextStyle(color: Colors.white),
    ),
    ),
    ),StreamBuilder(
    stream: groups,
    builder: (context, AsyncSnapshot snapshot) {
    // make some checks
    if (snapshot.hasData) {
    if (snapshot.data['groups'] != null) {
    if (snapshot.data['groups'].length != 0) {
    return ListView.builder(
    itemCount: snapshot.data['groups'].length,
    itemBuilder: (context, index) {
    int reverseIndex = snapshot.data['groups'].length - index - 1;
    return GroupTile(
    groupId: getId(snapshot.data['groups'][reverseIndex]),
    groupName: getName(snapshot.data['groups'][reverseIndex]),
    userName: snapshot.data['name']);
    },
    );
    } else {
    return noGroupWidget();
    }
    } else {
    return noGroupWidget();
    }
    } else {
    return Center(
    child: CircularProgressIndicator(
    color: Theme.of(context).primaryColor),
    );
    }
    },
    ),),);
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}


// SingleChildScrollView(
// child: Center(
// child: Column(
// children: [
// Container(
// width: size.width - 90,
// height: size.height * 0.01,
// ),
// RoundedInputField(
// textEditingController: _searchController,
// hintText: 'Search by email',
// icon: Icons.search,
// onChanged: (String value) {},
// ),
// Container(
// padding: EdgeInsets.symmetric(horizontal: 150, vertical: 10),
// child: ElevatedButton(
// style: ElevatedButton.styleFrom(
// backgroundColor: Colors.lightGreenAccent[400],
// //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
// textStyle:
// TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
// onPressed: () {
// searchUser();
// },
// child: Text(
// "Search".toUpperCase(),
// style: TextStyle(color: Colors.white),
// ),
// ),
// ),
// userMap?.isEmpty == false
// ? ListTile(
// onTap: () {},
// leading: Icon(Icons.account_box, color: Colors.black),
// title: Text(
// userMap!['name'],
// style: TextStyle(
// color: Colors.black,
// fontSize: 17,
// fontWeight: FontWeight.w500,
// ),
// ),
// subtitle: Text(userMap!['email']),
// trailing: Icon(Icons.chat, color: Colors.black),
// )
// : Container(),
// ],
// ),
// ),
// ),