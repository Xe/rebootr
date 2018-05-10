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
  Owner owner;

  factory App.fromJson(Map<String, dynamic> json) => _$AppFromJson(json);
}

@JsonSerializable()
/// Team is a group of users and apps aligned towards a shared goal. See https://devcenter.heroku.com/articles/platform-api-reference#team
/// https://www.youtube.com/watch?v=EoMW8VYb_GE
class Team extends Object with _$TeamSerializerMixin {
  Team(this.id, this.name);

  String id;
  String name;

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
}

@JsonSerializable()
/// Owner is the higher level owner of a resource. See App documentation.
class Owner extends Object with _$OwnerSerializerMixin {
  Owner(this.id, this.email);

  String id;
  String email;

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
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
    final response =
        await http.get(this.urlBase + "/apps", headers: this.headers());

    print(response.headers["ratelimit-remaining"]);
    if (response.statusCode != 200) {
      throw new Exception(response.body);
    }

    final responseJson = json.decode(response.body) as List<dynamic>;

    List<App> result = [];
    responseJson.forEach((item) =>
      result.add(new App.fromJson(item)));

    return result;
  }

  Future<bool> killApp(String name) async {
    final response = await http.delete(
        this.urlBase + '/apps/' + name + '/dynos',
        headers: this.headers());
    print(response.headers["ratelimit-remaining"]);
    return response.statusCode == 202;
  }
}
