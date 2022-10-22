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


/** This is an auto generated class representing the Expanse type in your schema. */
@immutable
class Expanse extends Model {
  static const classType = const _ExpanseModelType();
  final String id;
  final String? _user_id;
  final String? _expanse_id;
  final String? _expanse;
  final String? _date;
  final String? _status;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get user_id {
    return _user_id;
  }
  
  String? get expanse_id {
    return _expanse_id;
  }
  
  String? get expanse {
    return _expanse;
  }
  
  String? get date {
    return _date;
  }
  
  String? get status {
    return _status;
  }
  
  const Expanse._internal({required this.id, user_id, expanse_id, expanse, date, status}): _user_id = user_id, _expanse_id = expanse_id, _expanse = expanse, _date = date, _status = status;
  
  factory Expanse({String? id, String? user_id, String? expanse_id, String? expanse, String? date, String? status}) {
    return Expanse._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      expanse_id: expanse_id,
      expanse: expanse,
      date: date,
      status: status);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Expanse &&
      id == other.id &&
      _user_id == other._user_id &&
      _expanse_id == other._expanse_id &&
      _expanse == other._expanse &&
      _date == other._date &&
      _status == other._status;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Expanse {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("expanse_id=" + "$_expanse_id" + ", ");
    buffer.write("expanse=" + "$_expanse" + ", ");
    buffer.write("date=" + "$_date" + ", ");
    buffer.write("status=" + "$_status");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Expanse copyWith({String? id, String? user_id, String? expanse_id, String? expanse, String? date, String? status}) {
    return Expanse(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      expanse_id: expanse_id ?? this.expanse_id,
      expanse: expanse ?? this.expanse,
      date: date ?? this.date,
      status: status ?? this.status);
  }
  
  Expanse.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _expanse_id = json['expanse_id'],
      _expanse = json['expanse'],
      _date = json['date'],
      _status = json['status'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'expanse_id': _expanse_id, 'expanse': _expanse, 'date': _date, 'status': _status
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField EXPANSE_ID = QueryField(fieldName: "expanse_id");
  static final QueryField EXPANSE = QueryField(fieldName: "expanse");
  static final QueryField DATE = QueryField(fieldName: "date");
  static final QueryField STATUS = QueryField(fieldName: "status");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Expanse";
    modelSchemaDefinition.pluralName = "Expanses";
    
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
      key: Expanse.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Expanse.EXPANSE_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Expanse.EXPANSE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Expanse.DATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Expanse.STATUS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _ExpanseModelType extends ModelType<Expanse> {
  const _ExpanseModelType();
  
  @override
  Expanse fromJson(Map<String, dynamic> jsonData) {
    return Expanse.fromJson(jsonData);
  }
}