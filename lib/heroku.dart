import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'heroku.g.dart';

@JsonSerializable()
/// App is a Heroku Application. See https://devcenter.heroku.com/articles/platform-api-reference#app
class App extends Object with _$AppSerializerMixin {
  App(this.created_at, this.id, this.name, this.released_at, this.updated_at);

  String created_at;
  String id;
  String name;
  String released_at;
  String updated_at;

  factory App.fromJson(Map<String, dynamic> json) => _$AppFromJson(json);
}

class Client extends Object {
  Client(this.urlBase, this.apiToken);

  String urlBase;
  String apiToken;

  Map<String, String> headers() {
    Map<String, String> result = {};
    result["Authorization"] = "Bearer " + this.apiToken;
    result["Accept"] = "application/vnd.heroku+json; version=3";
    return result;
  }

  Future<List<App>> listApps() async {
    final response = await http.get(this.urlBase + "/apps", headers: this.headers());
    final responseJson = json.decode(response.body) as List<dynamic>;

    List<App> result = [];
    responseJson.forEach((item) => result.add(new App.fromJson(item)));

    return result;
  }

  Future<bool> killApp(String name) async {
    final response = await http.delete(this.urlBase + '/apps/' + name + '/dynos', headers: this.headers());
    return response.statusCode == 202;
  }
}