import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String COLLECTION = 'sample-1';

void main() => runApp(MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.cyan[600]),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    ));

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _name;
  String _description;
  double _price;

  void _updateName(String name) {
    _name = name;
    print('name: $_name');
  }

  void _updateDescription(String description) {
    _description = description;
    print('description: $_description');
  }

  void _updatePrice(String price) {
    _price = double.parse(price);
    print('price: $_price');
  }

  void _create() {
    Firestore.instance
        .collection(COLLECTION)
        .document(_name)
        .setData({'name': _name, 'description': _description, 'price': _price});
    print('create');
  }

  void _update() {
    Firestore.instance
        .collection(COLLECTION)
        .document(_name)
        .setData({'name': _name, 'description': _description, 'price': _price});
    print('update');
  }

  void _delete() {
    DocumentReference df =
        Firestore.instance.collection(COLLECTION).document(_name);
    df.delete().whenComplete(() {
      print('reference with name $_name was deleted');
    });
  }

  void _read() {
    DocumentReference df =
        Firestore.instance.collection(COLLECTION).document(_name);
    df.get().then((datasnapsht) {
      print(datasnapsht.data['name']);
      print(datasnapsht.data['description']);
      print(datasnapsht.data['price']);
    });
    print('read');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Firebase CRUD')),
        body: Column(children: <Widget>[
          TextField(
            decoration: InputDecoration(hintText: "Name"),
            onChanged: _updateName,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Description"),
            onChanged: _updateDescription,
          ),
          TextField(
              decoration: InputDecoration(hintText: "Price"),
              onChanged: _updatePrice,
              keyboardType: TextInputType.number),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            textDirection: TextDirection.ltr,
            children: <Widget>[
              RaisedButton(
                color: Colors.green,
                child: Text('Create'),
                onPressed: _create,
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text('Read'),
                onPressed: _read,
              ),
              RaisedButton(
                color: Colors.orange,
                child: Text('Update'),
                onPressed: _update,
              ),
              RaisedButton(
                color: Colors.red,
                child: Text('Delete'),
                onPressed: _delete,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder(
              stream: Firestore.instance.collection(COLLECTION).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: Text('Name')),
                        Expanded(child: Text('Description')),
                        Expanded(child: Text('Price')),
                      ],
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.documents[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(child: Text(ds['name'])),
                            Expanded(child: Text(ds['description'])),
                            Expanded(child: Text(ds['price'].toString())),
                          ],
                        );
                      }),
                ]);
                } else {
                  return Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ]));
  }
}
