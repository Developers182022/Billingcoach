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


/** This is an auto generated class representing the AppSubscription type in your schema. */
@immutable
class AppSubscription extends Model {
  static const classType = const _AppSubscriptionModelType();
  final String id;
  final String? _user_id;
  final String? _plan_id;
  final String? _transaction_id;
  final String? _issue_date;
  final String? _expiry_date;
  final String? _plan_charges;
  final String? _status;
  final String? _plan;
  final String? _valid_till;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get user_id {
    return _user_id;
  }
  
  String? get plan_id {
    return _plan_id;
  }
  
  String? get transaction_id {
    return _transaction_id;
  }
  
  String? get issue_date {
    return _issue_date;
  }
  
  String? get expiry_date {
    return _expiry_date;
  }
  
  String? get plan_charges {
    return _plan_charges;
  }
  
  String? get status {
    return _status;
  }
  
  String? get plan {
    return _plan;
  }
  
  String? get valid_till {
    return _valid_till;
  }
  
  const AppSubscription._internal({required this.id, user_id, plan_id, transaction_id, issue_date, expiry_date, plan_charges, status, plan, valid_till}): _user_id = user_id, _plan_id = plan_id, _transaction_id = transaction_id, _issue_date = issue_date, _expiry_date = expiry_date, _plan_charges = plan_charges, _status = status, _plan = plan, _valid_till = valid_till;
  
  factory AppSubscription({String? id, String? user_id, String? plan_id, String? transaction_id, String? issue_date, String? expiry_date, String? plan_charges, String? status, String? plan, String? valid_till}) {
    return AppSubscription._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      plan_id: plan_id,
      transaction_id: transaction_id,
      issue_date: issue_date,
      expiry_date: expiry_date,
      plan_charges: plan_charges,
      status: status,
      plan: plan,
      valid_till: valid_till);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppSubscription &&
      id == other.id &&
      _user_id == other._user_id &&
      _plan_id == other._plan_id &&
      _transaction_id == other._transaction_id &&
      _issue_date == other._issue_date &&
      _expiry_date == other._expiry_date &&
      _plan_charges == other._plan_charges &&
      _status == other._status &&
      _plan == other._plan &&
      _valid_till == other._valid_till;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("AppSubscription {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("plan_id=" + "$_plan_id" + ", ");
    buffer.write("transaction_id=" + "$_transaction_id" + ", ");
    buffer.write("issue_date=" + "$_issue_date" + ", ");
    buffer.write("expiry_date=" + "$_expiry_date" + ", ");
    buffer.write("plan_charges=" + "$_plan_charges" + ", ");
    buffer.write("status=" + "$_status" + ", ");
    buffer.write("plan=" + "$_plan" + ", ");
    buffer.write("valid_till=" + "$_valid_till");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  AppSubscription copyWith({String? id, String? user_id, String? plan_id, String? transaction_id, String? issue_date, String? expiry_date, String? plan_charges, String? status, String? plan, String? valid_till}) {
    return AppSubscription(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      plan_id: plan_id ?? this.plan_id,
      transaction_id: transaction_id ?? this.transaction_id,
      issue_date: issue_date ?? this.issue_date,
      expiry_date: expiry_date ?? this.expiry_date,
      plan_charges: plan_charges ?? this.plan_charges,
      status: status ?? this.status,
      plan: plan ?? this.plan,
      valid_till: valid_till ?? this.valid_till);
  }
  
  AppSubscription.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _plan_id = json['plan_id'],
      _transaction_id = json['transaction_id'],
      _issue_date = json['issue_date'],
      _expiry_date = json['expiry_date'],
      _plan_charges = json['plan_charges'],
      _status = json['status'],
      _plan = json['plan'],
      _valid_till = json['valid_till'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'plan_id': _plan_id, 'transaction_id': _transaction_id, 'issue_date': _issue_date, 'expiry_date': _expiry_date, 'plan_charges': _plan_charges, 'status': _status, 'plan': _plan, 'valid_till': _valid_till
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField PLAN_ID = QueryField(fieldName: "plan_id");
  static final QueryField TRANSACTION_ID = QueryField(fieldName: "transaction_id");
  static final QueryField ISSUE_DATE = QueryField(fieldName: "issue_date");
  static final QueryField EXPIRY_DATE = QueryField(fieldName: "expiry_date");
  static final QueryField PLAN_CHARGES = QueryField(fieldName: "plan_charges");
  static final QueryField STATUS = QueryField(fieldName: "status");
  static final QueryField PLAN = QueryField(fieldName: "plan");
  static final QueryField VALID_TILL = QueryField(fieldName: "valid_till");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "AppSubscription";
    modelSchemaDefinition.pluralName = "AppSubscriptions";
    
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
      key: AppSubscription.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppSubscription.PLAN_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppSubscription.TRANSACTION_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppSubscription.ISSUE_DATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppSubscription.EXPIRY_DATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppSubscription.PLAN_CHARGES,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppSubscription.STATUS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppSubscription.PLAN,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppSubscription.VALID_TILL,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _AppSubscriptionModelType extends ModelType<AppSubscription> {
  const _AppSubscriptionModelType();
  
  @override
  AppSubscription fromJson(Map<String, dynamic> jsonData) {
    return AppSubscription.fromJson(jsonData);
  }
}