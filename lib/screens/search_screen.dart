
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/resources/auth_methods.dart';

import '../resources/database_service.dart';
import '../widgets/rounded_input_field.dart';
import '../widgets/snackbar_widget.dart';
import 'chat_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  QuerySnapshot? _searchSnapshot;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _hasUserSearched = false;
  String? _userName = AuthMethods().giveUserName();
  bool _isJoined = false;
  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName()async{
    user = (await _auth.currentUser)!;
  }


  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.lightGreenAccent[700],
        title: const Text(
          "Search",
          style: TextStyle(
              fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.lime[50],
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                RoundedInputField(
                  textEditingController: _searchController,
                  hintText: 'Search the group',
                  icon: Icons.search,
                  onChanged: (String value) {},
                ),
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreenAccent[400],
//padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      initiateSearchMethod();
                    },
                    child: Text(
                      "Search".toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isLoading
              ? Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          )
              : groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseService()
          .searchByName(_searchController.text)
          .then((snapshot) {
        setState(() {
          _searchSnapshot = snapshot;
          _isLoading = false;
          _hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return _hasUserSearched
        ? ListView.builder(
      shrinkWrap: true,
      itemCount: _searchSnapshot!.docs.length,
      itemBuilder: (context, index) {
        return groupTile(
          _userName!,
          _searchSnapshot!.docs[index]['groupId'],
          _searchSnapshot!.docs[index]['groupName'],
          _searchSnapshot!.docs[index]['admin'],
        );
      },
    )
        : Container();
  }

  joinedOrNot(
      String userName, String groupId, String groupname, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupname, groupId, userName)
        .then((value) {
      setState(() {
        _isJoined = value;
      });
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    // function to check whether user already exists in group
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.red[700],
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title:
      Text(groupName, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid)
              .toggleGroupJoin(groupId, userName, groupName);
          if (_isJoined) {
            setState(() {
              _isJoined = !_isJoined;
            });
            showSnackbar(context, Colors.green, "Successfully joined he group");
            Future.delayed(const Duration(seconds: 2), () {
              MaterialPageRoute(
                builder: (_) =>  ChatScreen(
                  groupId: groupId,
                  groupName: groupName,
                  userName: userName,
                ),
              );
            });
          } else {
            setState(() {
              _isJoined = !_isJoined;
              showSnackbar(context, Colors.red, "Left the group $groupName");
            });
          }
        },
        child: _isJoined
            ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            border: Border.all(color: Colors.white, width: 1),
          ),
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: const Text(
            "Joined",
            style: TextStyle(color: Colors.white),
          ),
        )
            : Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.amberAccent,
          ),
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: const Text("Join Now",
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}