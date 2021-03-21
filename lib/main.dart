import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsc_bzu/Booklist.dart';
import 'package:dsc_bzu/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DSC',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Image.asset(
            'images/logo.png',
            width: 100,
          )),
      body: (loading == true)
          ? Container(
              alignment: Alignment.center,
              child: Center(
                heightFactor: 2.5,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.yellow[800])),
              ),
            )
          : BookList(),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          backgroundColor: Colors.red[500],
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 100,
                    child: AlertDialog(
                      insetPadding: EdgeInsets.all(5),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("Add Todo"),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Title: ",
                              textAlign: TextAlign.start,
                            ),
                          ),
                          TextField(
                            controller: titleController,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text("Description: "),
                          ),
                          TextField(
                            controller: descriptionController,
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: RaisedButton(
                            color: Colors.red,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Dismiss",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        //Add Button

                        RaisedButton(
                          color: Colors.blue[700],
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              loading = true;
                            });
                            //TODO: Firestore create a new record code
                            Map<String, dynamic> newTodo =
                                new Map<String, dynamic>();
                            newTodo["title"] = titleController.text;
                            newTodo["description"] = descriptionController.text;
                            FirebaseFirestore.instance
                                .collection("todos")
                                .add(newTodo)
                                .whenComplete(() {
                              setState(() {
                                loading = false;
                              });
                            });
                          },
                          child: Text(
                            "save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
          tooltip: 'Add Title',
          child: Icon(Icons.add),
        ),
        SizedBox(
          width: 20,
        ),
        FloatingActionButton(
          heroTag: "btn2",
          backgroundColor: Colors.yellow[700],
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            )
          },
          child: Icon(Icons.person),
        )
      ]),
    );
  }
}
