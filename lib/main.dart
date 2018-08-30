import 'package:flutter/material.dart';
import 'package:database_intro/utils/database_helper.dart';
import 'package:database_intro/modals/user.dart';
import 'package:flutter/services.dart';

List _user;
var db = new DatabaseHelper();

void main() async {
  var db = new DatabaseHelper();

  _user = await db.getAllUsers();
  for (int i = 0; i < _user.length; i++) {
    User user = User.map(_user[i]);
    print("ID : ${user.id}");
    print("Name : ${user.username}");
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Database",
      home: new Home(),
    ));
  });
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text("Database"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: new TextField(
                controller: usernameController,
                style: TextStyle(fontSize: 20.0, color: Colors.black87),
                decoration: InputDecoration(hintText: "Enter Name"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: new TextField(
                controller: passwordController,
                obscureText: true,
                maxLength: 12,
                style: TextStyle(fontSize: 20.0, color: Colors.black87),
                decoration: InputDecoration(hintText: "Enter Password"),
              ),
            ),
            RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: Colors.blueAccent,
              onPressed: (){
                setState(() {
                  db.saveUser(User(usernameController.text, passwordController.text));
                  usernameController.text = "";
                  passwordController.text = "";
                  FocusScope.of(context).requestFocus(new FocusNode());
                });
              },
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 16.0,
            ),
            updateCredentialWidget()
          ],
        ));
  }
}

Widget updateCredentialWidget() {
  return new FutureBuilder(
      future: db.getAllUsers(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        try{
          List _users = snapshot.data.toList();
          int length = _users.length - 1;
          return new Flexible(
            child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (BuildContext context, int position) {
                  return new Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: ListTile(
                      title: new Text(
                        "User: ${User.fromMap(_users[length - position]).username}",
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: new Text(
                        "Password: ${User.fromMap(_users[length - position]).password}",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  );
                }),
          );
        } catch(e) {
          debugPrint("Error Handling");
          return new Text(
              "No Credential Saved!",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white
              ),
          );
        }
      });
}
