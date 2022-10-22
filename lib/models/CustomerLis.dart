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


/** This is an auto generated class representing the CustomerLis type in your schema. */
@immutable
class CustomerLis extends Model {
  static const classType = const _CustomerLisModelType();
  final String id;
  final String? _user_id;
  final String? _customer_id;
  final String? _customer_name;
  final String? _customer_phone_no;
  final String? _pending_amount;
  final String? _advance_amount;
  final String? _time;
  final String? _date;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get user_id {
    return _user_id;
  }
  
  String? get customer_id {
    return _customer_id;
  }
  
  String? get customer_name {
    return _customer_name;
  }
  
  String? get customer_phone_no {
    return _customer_phone_no;
  }
  
  String? get pending_amount {
    return _pending_amount;
  }
  
  String? get advance_amount {
    return _advance_amount;
  }
  
  String? get time {
    return _time;
  }
  
  String? get date {
    return _date;
  }
  
  const CustomerLis._internal({required this.id, user_id, customer_id, customer_name, customer_phone_no, pending_amount, advance_amount, time, date}): _user_id = user_id, _customer_id = customer_id, _customer_name = customer_name, _customer_phone_no = customer_phone_no, _pending_amount = pending_amount, _advance_amount = advance_amount, _time = time, _date = date;
  
  factory CustomerLis({String? id, String? user_id, String? customer_id, String? customer_name, String? customer_phone_no, String? pending_amount, String? advance_amount, String? time, String? date}) {
    return CustomerLis._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      customer_id: customer_id,
      customer_name: customer_name,
      customer_phone_no: customer_phone_no,
      pending_amount: pending_amount,
      advance_amount: advance_amount,
      time: time,
      date: date);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerLis &&
      id == other.id &&
      _user_id == other._user_id &&
      _customer_id == other._customer_id &&
      _customer_name == other._customer_name &&
      _customer_phone_no == other._customer_phone_no &&
      _pending_amount == other._pending_amount &&
      _advance_amount == other._advance_amount &&
      _time == other._time &&
      _date == other._date;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("CustomerLis {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("customer_id=" + "$_customer_id" + ", ");
    buffer.write("customer_name=" + "$_customer_name" + ", ");
    buffer.write("customer_phone_no=" + "$_customer_phone_no" + ", ");
    buffer.write("pending_amount=" + "$_pending_amount" + ", ");
    buffer.write("advance_amount=" + "$_advance_amount" + ", ");
    buffer.write("time=" + "$_time" + ", ");
    buffer.write("date=" + "$_date");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  CustomerLis copyWith({String? id, String? user_id, String? customer_id, String? customer_name, String? customer_phone_no, String? pending_amount, String? advance_amount, String? time, String? date}) {
    return CustomerLis(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      customer_id: customer_id ?? this.customer_id,
      customer_name: customer_name ?? this.customer_name,
      customer_phone_no: customer_phone_no ?? this.customer_phone_no,
      pending_amount: pending_amount ?? this.pending_amount,
      advance_amount: advance_amount ?? this.advance_amount,
      time: time ?? this.time,
      date: date ?? this.date);
  }
  
  CustomerLis.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _customer_id = json['customer_id'],
      _customer_name = json['customer_name'],
      _customer_phone_no = json['customer_phone_no'],
      _pending_amount = json['pending_amount'],
      _advance_amount = json['advance_amount'],
      _time = json['time'],
      _date = json['date'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'customer_id': _customer_id, 'customer_name': _customer_name, 'customer_phone_no': _customer_phone_no, 'pending_amount': _pending_amount, 'advance_amount': _advance_amount, 'time': _time, 'date': _date
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField CUSTOMER_ID = QueryField(fieldName: "customer_id");
  static final QueryField CUSTOMER_NAME = QueryField(fieldName: "customer_name");
  static final QueryField CUSTOMER_PHONE_NO = QueryField(fieldName: "customer_phone_no");
  static final QueryField PENDING_AMOUNT = QueryField(fieldName: "pending_amount");
  static final QueryField ADVANCE_AMOUNT = QueryField(fieldName: "advance_amount");
  static final QueryField TIME = QueryField(fieldName: "time");
  static final QueryField DATE = QueryField(fieldName: "date");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "CustomerLis";
    modelSchemaDefinition.pluralName = "CustomerLis";
    
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
      key: CustomerLis.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerLis.CUSTOMER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerLis.CUSTOMER_NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerLis.CUSTOMER_PHONE_NO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerLis.PENDING_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerLis.ADVANCE_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerLis.TIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerLis.DATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _CustomerLisModelType extends ModelType<CustomerLis> {
  const _CustomerLisModelType();
  
  @override
  CustomerLis fromJson(Map<String, dynamic> jsonData) {
    return CustomerLis.fromJson(jsonData);
  }
}