import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'heroku.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'rebootr',
      theme: new ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: new MyHomePage(title: 'rebootr'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<App> apps;
  Client client;
  String lastMessage;
  String apiToken;

  void _getApps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.apiToken = prefs.getString("api_token");

    this.client = new Client(
      "https://api.heroku.com",
      this.apiToken,
    );

    this.client.listApps().then((apps) {
      setState(() {
        this.apps = apps;
        this.lastMessage = "refreshed app view";
        print(this.lastMessage);
      });
    });
  }

  List<Widget> listApps(BuildContext ctx) {
    List<Widget> result = [];

    if (this.lastMessage != null) {
      Container ctr = new Container(
        child: Text(
          lastMessage,
          style: new TextStyle(color: Colors.black54),
        ),
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      );

      result.add(ctr);
    }

    if (this.apps == null && this.apiToken != null) {
      this._getApps();
      result.add(Text("Refreshing..."));
      return result;
    }

    if (this.apiToken == null) {
      result.add(Text("Please configure this app in settings."));
      return result;
    }

    this.apps.forEach((app) {
      String appName = app.name;

      Container ctr = new Container(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: 8.0,
          bottom: 8.0,
        ),
        child: Row(
          children: <Widget>[
            new Icon(Icons.star, color: Colors.purple[500]),
            new Expanded(
              child: Text("$appName"),
            ),
            new RaisedButton(
              onPressed: () {
                this.client.killApp(appName);
                setState(() {
                  this.lastMessage = "$appName was restarted";
                  print(this.lastMessage);
                });

                Scaffold.of(ctx).showSnackBar(
                  new SnackBar(
                    content: Text(this.lastMessage),
                  ),
                );
              },
              child: Text("Restart"),
            ),
          ],
        ),
      );

      result.add(ctr);
    });

    return result;
  }

  Widget settings(BuildContext ctx) {
    TextField apiTokenField = new TextField(
      autocorrect: false,
      autofocus: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Put the API Token type 4 uuid here",
      ),
      onSubmitted: (String token) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("api_token", token);
        print("api token changed to " + token);
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
      ),
      body: new Container(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: 8.0,
          bottom: 8.0,
        ),
        child: new ListView(children: <Widget>[
          Text("Heroku API Token is $apiToken"),
          apiTokenField,
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              Navigator.push(
                ctx,
                new MaterialPageRoute(builder: settings)
              );
            },
            tooltip: "Settings",
            icon: new Icon(Icons.settings),
          ),
          new IconButton(
            onPressed: _getApps,
            tooltip: 'Refresh Apps',
            icon: new Icon(Icons.refresh),
          ),
        ],
      ),
      body: new Builder(builder: (BuildContext ctx) {
        return new ListView(children: this.listApps(ctx));
      }),
    );
  }
}
