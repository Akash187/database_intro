import 'package:flutter/material.dart';
import 'package:database_intro/utils/database_helper.dart';
import 'package:database_intro/modals/user.dart';

List _users;
void main() async{
  var db = new DatabaseHelper();

  await db.saveUser(new User("Bond","james"));
  int count = await db.getCount();
  print("Count: $count");

  _users = await db.getAllUsers();
  for(int i = 0; i < _users.length; i++){
    User user = User.map(_users[i]);
    print("ID : ${user.id}");
    print("Name : ${user.username}");

  }

  runApp(
      new MaterialApp(
        title: "Database",
        home: new Home(),
      )
  );
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Database"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: _users.length,
          itemBuilder: (BuildContext context, int position){
            return new Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                title: new Text("User: ${User.fromMap(_users[position]).username}"),
                subtitle: new Text("Id: ${User.fromMap(_users[position]).id}"),
              ),
            );
          }
      ),
    );
  }
}
