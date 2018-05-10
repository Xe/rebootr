// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heroku.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

App _$AppFromJson(Map<String, dynamic> json) => new App(
    json['created_at'] as String,
    json['id'] as String,
    json['name'] as String,
    json['released_at'] as String,
    json['updated_at'] as String)
  ..owner = json['owner'] == null
      ? null
      : new Owner.fromJson(json['owner'] as Map<String, dynamic>);

abstract class _$AppSerializerMixin {
  String get created_at;
  String get id;
  String get name;
  String get released_at;
  String get updated_at;
  Owner get owner;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'created_at': created_at,
        'id': id,
        'name': name,
        'released_at': released_at,
        'updated_at': updated_at,
        'owner': owner
      };
}

Team _$TeamFromJson(Map<String, dynamic> json) =>
    new Team(json['id'] as String, json['name'] as String);

abstract class _$TeamSerializerMixin {
  String get id;
  String get name;
  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'name': name};
}

Owner _$OwnerFromJson(Map<String, dynamic> json) =>
    new Owner(json['id'] as String, json['email'] as String);

abstract class _$OwnerSerializerMixin {
  String get id;
  String get email;
  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'email': email};
}
