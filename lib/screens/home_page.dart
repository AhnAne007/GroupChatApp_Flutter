import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/resources/database_service.dart';

import '../resources/auth_methods.dart';
import '../widgets/rounded_input_field.dart';
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Center(
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
                      textStyle: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    searchUser();
                  },
                  child: Text(
                    "Search".toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              userMap?.isEmpty == false
                  ? ListTile(
                onTap: () {
                },
                leading: Icon(Icons.account_box, color: Colors.black),
                title: Text(
                  userMap!['name'],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(userMap!['email']),
                trailing: Icon(Icons.chat, color: Colors.black),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
