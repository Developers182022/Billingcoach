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


/** This is an auto generated class representing the PaymentRecords type in your schema. */
@immutable
class PaymentRecords extends Model {
  static const classType = const _PaymentRecordsModelType();
  final String id;
  final String? _user_id;
  final String? _record_id;
  final String? _token_no;
  final String? _order_id;
  final String? _client_id;
  final String? _description;
  final String? _received_amount;
  final String? _sent_amount;
  final String? _payment_mod;
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
  
  String? get record_id {
    return _record_id;
  }
  
  String? get token_no {
    return _token_no;
  }
  
  String? get order_id {
    return _order_id;
  }
  
  String? get client_id {
    return _client_id;
  }
  
  String? get description {
    return _description;
  }
  
  String? get received_amount {
    return _received_amount;
  }
  
  String? get sent_amount {
    return _sent_amount;
  }
  
  String? get payment_mod {
    return _payment_mod;
  }
  
  String? get date {
    return _date;
  }
  
  String? get time {
    return _time;
  }
  
  const PaymentRecords._internal({required this.id, user_id, record_id, token_no, order_id, client_id, description, received_amount, sent_amount, payment_mod, date, time}): _user_id = user_id, _record_id = record_id, _token_no = token_no, _order_id = order_id, _client_id = client_id, _description = description, _received_amount = received_amount, _sent_amount = sent_amount, _payment_mod = payment_mod, _date = date, _time = time;
  
  factory PaymentRecords({String? id, String? user_id, String? record_id, String? token_no, String? order_id, String? client_id, String? description, String? received_amount, String? sent_amount, String? payment_mod, String? date, String? time}) {
    return PaymentRecords._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      record_id: record_id,
      token_no: token_no,
      order_id: order_id,
      client_id: client_id,
      description: description,
      received_amount: received_amount,
      sent_amount: sent_amount,
      payment_mod: payment_mod,
      date: date,
      time: time);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentRecords &&
      id == other.id &&
      _user_id == other._user_id &&
      _record_id == other._record_id &&
      _token_no == other._token_no &&
      _order_id == other._order_id &&
      _client_id == other._client_id &&
      _description == other._description &&
      _received_amount == other._received_amount &&
      _sent_amount == other._sent_amount &&
      _payment_mod == other._payment_mod &&
      _date == other._date &&
      _time == other._time;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("PaymentRecords {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("record_id=" + "$_record_id" + ", ");
    buffer.write("token_no=" + "$_token_no" + ", ");
    buffer.write("order_id=" + "$_order_id" + ", ");
    buffer.write("client_id=" + "$_client_id" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("received_amount=" + "$_received_amount" + ", ");
    buffer.write("sent_amount=" + "$_sent_amount" + ", ");
    buffer.write("payment_mod=" + "$_payment_mod" + ", ");
    buffer.write("date=" + "$_date" + ", ");
    buffer.write("time=" + "$_time");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  PaymentRecords copyWith({String? id, String? user_id, String? record_id, String? token_no, String? order_id, String? client_id, String? description, String? received_amount, String? sent_amount, String? payment_mod, String? date, String? time}) {
    return PaymentRecords(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      record_id: record_id ?? this.record_id,
      token_no: token_no ?? this.token_no,
      order_id: order_id ?? this.order_id,
      client_id: client_id ?? this.client_id,
      description: description ?? this.description,
      received_amount: received_amount ?? this.received_amount,
      sent_amount: sent_amount ?? this.sent_amount,
      payment_mod: payment_mod ?? this.payment_mod,
      date: date ?? this.date,
      time: time ?? this.time);
  }
  
  PaymentRecords.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _record_id = json['record_id'],
      _token_no = json['token_no'],
      _order_id = json['order_id'],
      _client_id = json['client_id'],
      _description = json['description'],
      _received_amount = json['received_amount'],
      _sent_amount = json['sent_amount'],
      _payment_mod = json['payment_mod'],
      _date = json['date'],
      _time = json['time'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'record_id': _record_id, 'token_no': _token_no, 'order_id': _order_id, 'client_id': _client_id, 'description': _description, 'received_amount': _received_amount, 'sent_amount': _sent_amount, 'payment_mod': _payment_mod, 'date': _date, 'time': _time
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField RECORD_ID = QueryField(fieldName: "record_id");
  static final QueryField TOKEN_NO = QueryField(fieldName: "token_no");
  static final QueryField ORDER_ID = QueryField(fieldName: "order_id");
  static final QueryField CLIENT_ID = QueryField(fieldName: "client_id");
  static final QueryField DESCRIPTION = QueryField(fieldName: "description");
  static final QueryField RECEIVED_AMOUNT = QueryField(fieldName: "received_amount");
  static final QueryField SENT_AMOUNT = QueryField(fieldName: "sent_amount");
  static final QueryField PAYMENT_MOD = QueryField(fieldName: "payment_mod");
  static final QueryField DATE = QueryField(fieldName: "date");
  static final QueryField TIME = QueryField(fieldName: "time");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "PaymentRecords";
    modelSchemaDefinition.pluralName = "PaymentRecords";
    
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
      key: PaymentRecords.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PaymentRecords.RECORD_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PaymentRecords.TOKEN_NO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PaymentRecords.ORDER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PaymentRecords.CLIENT_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PaymentRecords.DESCRIPTION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PaymentRecords.RECEIVED_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PaymentRecords.SENT_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PaymentRecords.PAYMENT_MOD,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PaymentRecords.DATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PaymentRecords.TIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _PaymentRecordsModelType extends ModelType<PaymentRecords> {
  const _PaymentRecordsModelType();
  
  @override
  PaymentRecords fromJson(Map<String, dynamic> jsonData) {
    return PaymentRecords.fromJson(jsonData);
  }
}