import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BookList extends StatelessWidget {
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //TODO: Retrive all records in collection from Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('todos').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return new ListView(
              padding: EdgeInsets.only(bottom: 80),
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      child: Card(
                        color: Colors.green[700],
                        child: ListTile(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Update Dilaog"),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          "Title: ",
                                          textAlign: TextAlign.start,
                                        ),
                                        TextField(
                                          controller: titleController,
                                          decoration: InputDecoration(
                                            hintText: document['title'],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 20),
                                          child: Text("Description: "),
                                        ),
                                        TextField(
                                          controller: descriptionController,
                                          decoration: InputDecoration(
                                            hintText: document['description'],
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: RaisedButton(
                                          color: Colors.red,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "Undo",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      // Update Button
                                      RaisedButton(
                                        color: Colors.blue[700],
                                        onPressed: () {
                                          Map<String, dynamic> updateBook =
                                              new Map<String, dynamic>();
                                          updateBook["title"] =
                                              titleController.text;
                                          updateBook["description"] =
                                              descriptionController.text;

                                          // Updae Firestore record information regular way
                                          FirebaseFirestore.instance
                                              .collection("todos")
                                              .doc(document.id)
                                              .update(updateBook)
                                              .whenComplete(() {
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: Text(
                                          "update",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          title: new Text(
                            "Title : " + document['title'],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: new Text(
                            "Description : " + document['description'],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      actions: [
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () {
                            //TODO: Firestore delete a record code
                            FirebaseFirestore.instance
                                .collection("todos")
                                .doc(document.id)
                                .delete()
                                .catchError((e) {
                              print(e);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
