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


/** This is an auto generated class representing the SentRequest type in your schema. */
@immutable
class SentRequest extends Model {
  static const classType = const _SentRequestModelType();
  final String id;
  final String? _user_id;
  final String? _client_id;
  final String? _client_shop_name;
  final String? _client_name;
  final String? _client_phone_no;
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
  
  String? get client_id {
    return _client_id;
  }
  
  String? get client_shop_name {
    return _client_shop_name;
  }
  
  String? get client_name {
    return _client_name;
  }
  
  String? get client_phone_no {
    return _client_phone_no;
  }
  
  String? get date {
    return _date;
  }
  
  String? get time {
    return _time;
  }
  
  const SentRequest._internal({required this.id, user_id, client_id, client_shop_name, client_name, client_phone_no, date, time}): _user_id = user_id, _client_id = client_id, _client_shop_name = client_shop_name, _client_name = client_name, _client_phone_no = client_phone_no, _date = date, _time = time;
  
  factory SentRequest({String? id, String? user_id, String? client_id, String? client_shop_name, String? client_name, String? client_phone_no, String? date, String? time}) {
    return SentRequest._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      client_id: client_id,
      client_shop_name: client_shop_name,
      client_name: client_name,
      client_phone_no: client_phone_no,
      date: date,
      time: time);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SentRequest &&
      id == other.id &&
      _user_id == other._user_id &&
      _client_id == other._client_id &&
      _client_shop_name == other._client_shop_name &&
      _client_name == other._client_name &&
      _client_phone_no == other._client_phone_no &&
      _date == other._date &&
      _time == other._time;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("SentRequest {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("client_id=" + "$_client_id" + ", ");
    buffer.write("client_shop_name=" + "$_client_shop_name" + ", ");
    buffer.write("client_name=" + "$_client_name" + ", ");
    buffer.write("client_phone_no=" + "$_client_phone_no" + ", ");
    buffer.write("date=" + "$_date" + ", ");
    buffer.write("time=" + "$_time");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  SentRequest copyWith({String? id, String? user_id, String? client_id, String? client_shop_name, String? client_name, String? client_phone_no, String? date, String? time}) {
    return SentRequest(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      client_id: client_id ?? this.client_id,
      client_shop_name: client_shop_name ?? this.client_shop_name,
      client_name: client_name ?? this.client_name,
      client_phone_no: client_phone_no ?? this.client_phone_no,
      date: date ?? this.date,
      time: time ?? this.time);
  }
  
  SentRequest.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _client_id = json['client_id'],
      _client_shop_name = json['client_shop_name'],
      _client_name = json['client_name'],
      _client_phone_no = json['client_phone_no'],
      _date = json['date'],
      _time = json['time'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'client_id': _client_id, 'client_shop_name': _client_shop_name, 'client_name': _client_name, 'client_phone_no': _client_phone_no, 'date': _date, 'time': _time
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField CLIENT_ID = QueryField(fieldName: "client_id");
  static final QueryField CLIENT_SHOP_NAME = QueryField(fieldName: "client_shop_name");
  static final QueryField CLIENT_NAME = QueryField(fieldName: "client_name");
  static final QueryField CLIENT_PHONE_NO = QueryField(fieldName: "client_phone_no");
  static final QueryField DATE = QueryField(fieldName: "date");
  static final QueryField TIME = QueryField(fieldName: "time");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "SentRequest";
    modelSchemaDefinition.pluralName = "SentRequests";
    
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
      key: SentRequest.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: SentRequest.CLIENT_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: SentRequest.CLIENT_SHOP_NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: SentRequest.CLIENT_NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: SentRequest.CLIENT_PHONE_NO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: SentRequest.DATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: SentRequest.TIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _SentRequestModelType extends ModelType<SentRequest> {
  const _SentRequestModelType();
  
  @override
  SentRequest fromJson(Map<String, dynamic> jsonData) {
    return SentRequest.fromJson(jsonData);
  }
}