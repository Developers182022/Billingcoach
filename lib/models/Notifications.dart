/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Notifications type in your schema. */
@immutable
class Notifications extends Model {
  static const classType = const _NotificationsModelType();
  final String id;
  final String? _user_id;
  final String? _title;
  final String? _subtitle;
  final String? _payload;
  final String? _date;
  final String? _time;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get user_id {
    return _user_id;
  }
  
  String? get title {
    return _title;
  }
  
  String? get subtitle {
    return _subtitle;
  }
  
  String? get payload {
    return _payload;
  }
  
  String? get date {
    return _date;
  }
  
  String? get time {
    return _time;
  }
  
  const Notifications._internal({required this.id, user_id, title, subtitle, payload, date, time}): _user_id = user_id, _title = title, _subtitle = subtitle, _payload = payload, _date = date, _time = time;
  
  factory Notifications({String? id, String? user_id, String? title, String? subtitle, String? payload, String? date, String? time}) {
    return Notifications._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      title: title,
      subtitle: subtitle,
      payload: payload,
      date: date,
      time: time);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Notifications &&
      id == other.id &&
      _user_id == other._user_id &&
      _title == other._title &&
      _subtitle == other._subtitle &&
      _payload == other._payload &&
      _date == other._date &&
      _time == other._time;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Notifications {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("subtitle=" + "$_subtitle" + ", ");
    buffer.write("payload=" + "$_payload" + ", ");
    buffer.write("date=" + "$_date" + ", ");
    buffer.write("time=" + "$_time");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Notifications copyWith({String? id, String? user_id, String? title, String? subtitle, String? payload, String? date, String? time}) {
    return Notifications(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      payload: payload ?? this.payload,
      date: date ?? this.date,
      time: time ?? this.time);
  }
  
  Notifications.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _title = json['title'],
      _subtitle = json['subtitle'],
      _payload = json['payload'],
      _date = json['date'],
      _time = json['time'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'title': _title, 'subtitle': _subtitle, 'payload': _payload, 'date': _date, 'time': _time
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField TITLE = QueryField(fieldName: "title");
  static final QueryField SUBTITLE = QueryField(fieldName: "subtitle");
  static final QueryField PAYLOAD = QueryField(fieldName: "payload");
  static final QueryField DATE = QueryField(fieldName: "date");
  static final QueryField TIME = QueryField(fieldName: "time");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Notifications";
    modelSchemaDefinition.pluralName = "Notifications";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Notifications.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Notifications.TITLE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Notifications.SUBTITLE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Notifications.PAYLOAD,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Notifications.DATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Notifications.TIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _NotificationsModelType extends ModelType<Notifications> {
  const _NotificationsModelType();
  
  @override
  Notifications fromJson(Map<String, dynamic> jsonData) {
    return Notifications.fromJson(jsonData);
  }
}