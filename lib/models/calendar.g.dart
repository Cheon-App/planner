// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Calendar _$CalendarFromJson(Map<String, dynamic> json) {
  return Calendar(
    id: json['id'] as String,
    name: json['name'] as String,
    accountName: json['accountName'] as String,
    accountType: json['accountType'] as String,
  );
}

Map<String, dynamic> _$CalendarToJson(Calendar instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'accountName': instance.accountName,
      'accountType': instance.accountType,
    };
