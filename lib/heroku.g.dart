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
    json['updated_at'] as String);

abstract class _$AppSerializerMixin {
  String get created_at;
  String get id;
  String get name;
  String get released_at;
  String get updated_at;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'created_at': created_at,
        'id': id,
        'name': name,
        'released_at': released_at,
        'updated_at': updated_at
      };
}
