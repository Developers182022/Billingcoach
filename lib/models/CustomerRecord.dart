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


/** This is an auto generated class representing the CustomerRecord type in your schema. */
@immutable
class CustomerRecord extends Model {
  static const classType = const _CustomerRecordModelType();
  final String id;
  final String? _user_id;
  final String? _client_id;
  final String? _record_id;
  final String? _payment_status;
  final String? _payment_mode;
  final String? _transaction_id;
  final String? _sent_amount;
  final String? _received_amount;
  final String? _party_name;
  final String? _party;
  final String? _Balance;
  final String? _description;
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
  
  String? get record_id {
    return _record_id;
  }
  
  String? get payment_status {
    return _payment_status;
  }
  
  String? get payment_mode {
    return _payment_mode;
  }
  
  String? get transaction_id {
    return _transaction_id;
  }
  
  String? get sent_amount {
    return _sent_amount;
  }
  
  String? get received_amount {
    return _received_amount;
  }
  
  String? get party_name {
    return _party_name;
  }
  
  String? get party {
    return _party;
  }
  
  String? get Balance {
    return _Balance;
  }
  
  String? get description {
    return _description;
  }
  
  String? get date {
    return _date;
  }
  
  String? get time {
    return _time;
  }
  
  const CustomerRecord._internal({required this.id, user_id, client_id, record_id, payment_status, payment_mode, transaction_id, sent_amount, received_amount, party_name, party, Balance, description, date, time}): _user_id = user_id, _client_id = client_id, _record_id = record_id, _payment_status = payment_status, _payment_mode = payment_mode, _transaction_id = transaction_id, _sent_amount = sent_amount, _received_amount = received_amount, _party_name = party_name, _party = party, _Balance = Balance, _description = description, _date = date, _time = time;
  
  factory CustomerRecord({String? id, String? user_id, String? client_id, String? record_id, String? payment_status, String? payment_mode, String? transaction_id, String? sent_amount, String? received_amount, String? party_name, String? party, String? Balance, String? description, String? date, String? time}) {
    return CustomerRecord._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      client_id: client_id,
      record_id: record_id,
      payment_status: payment_status,
      payment_mode: payment_mode,
      transaction_id: transaction_id,
      sent_amount: sent_amount,
      received_amount: received_amount,
      party_name: party_name,
      party: party,
      Balance: Balance,
      description: description,
      date: date,
      time: time);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerRecord &&
      id == other.id &&
      _user_id == other._user_id &&
      _client_id == other._client_id &&
      _record_id == other._record_id &&
      _payment_status == other._payment_status &&
      _payment_mode == other._payment_mode &&
      _transaction_id == other._transaction_id &&
      _sent_amount == other._sent_amount &&
      _received_amount == other._received_amount &&
      _party_name == other._party_name &&
      _party == other._party &&
      _Balance == other._Balance &&
      _description == other._description &&
      _date == other._date &&
      _time == other._time;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("CustomerRecord {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("client_id=" + "$_client_id" + ", ");
    buffer.write("record_id=" + "$_record_id" + ", ");
    buffer.write("payment_status=" + "$_payment_status" + ", ");
    buffer.write("payment_mode=" + "$_payment_mode" + ", ");
    buffer.write("transaction_id=" + "$_transaction_id" + ", ");
    buffer.write("sent_amount=" + "$_sent_amount" + ", ");
    buffer.write("received_amount=" + "$_received_amount" + ", ");
    buffer.write("party_name=" + "$_party_name" + ", ");
    buffer.write("party=" + "$_party" + ", ");
    buffer.write("Balance=" + "$_Balance" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("date=" + "$_date" + ", ");
    buffer.write("time=" + "$_time");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  CustomerRecord copyWith({String? id, String? user_id, String? client_id, String? record_id, String? payment_status, String? payment_mode, String? transaction_id, String? sent_amount, String? received_amount, String? party_name, String? party, String? Balance, String? description, String? date, String? time}) {
    return CustomerRecord(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      client_id: client_id ?? this.client_id,
      record_id: record_id ?? this.record_id,
      payment_status: payment_status ?? this.payment_status,
      payment_mode: payment_mode ?? this.payment_mode,
      transaction_id: transaction_id ?? this.transaction_id,
      sent_amount: sent_amount ?? this.sent_amount,
      received_amount: received_amount ?? this.received_amount,
      party_name: party_name ?? this.party_name,
      party: party ?? this.party,
      Balance: Balance ?? this.Balance,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time);
  }
  
  CustomerRecord.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _client_id = json['client_id'],
      _record_id = json['record_id'],
      _payment_status = json['payment_status'],
      _payment_mode = json['payment_mode'],
      _transaction_id = json['transaction_id'],
      _sent_amount = json['sent_amount'],
      _received_amount = json['received_amount'],
      _party_name = json['party_name'],
      _party = json['party'],
      _Balance = json['Balance'],
      _description = json['description'],
      _date = json['date'],
      _time = json['time'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'client_id': _client_id, 'record_id': _record_id, 'payment_status': _payment_status, 'payment_mode': _payment_mode, 'transaction_id': _transaction_id, 'sent_amount': _sent_amount, 'received_amount': _received_amount, 'party_name': _party_name, 'party': _party, 'Balance': _Balance, 'description': _description, 'date': _date, 'time': _time
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField CLIENT_ID = QueryField(fieldName: "client_id");
  static final QueryField RECORD_ID = QueryField(fieldName: "record_id");
  static final QueryField PAYMENT_STATUS = QueryField(fieldName: "payment_status");
  static final QueryField PAYMENT_MODE = QueryField(fieldName: "payment_mode");
  static final QueryField TRANSACTION_ID = QueryField(fieldName: "transaction_id");
  static final QueryField SENT_AMOUNT = QueryField(fieldName: "sent_amount");
  static final QueryField RECEIVED_AMOUNT = QueryField(fieldName: "received_amount");
  static final QueryField PARTY_NAME = QueryField(fieldName: "party_name");
  static final QueryField PARTY = QueryField(fieldName: "party");
  static final QueryField BALANCE = QueryField(fieldName: "Balance");
  static final QueryField DESCRIPTION = QueryField(fieldName: "description");
  static final QueryField DATE = QueryField(fieldName: "date");
  static final QueryField TIME = QueryField(fieldName: "time");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "CustomerRecord";
    modelSchemaDefinition.pluralName = "CustomerRecords";
    
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
      key: CustomerRecord.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerRecord.CLIENT_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerRecord.RECORD_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerRecord.PAYMENT_STATUS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerRecord.PAYMENT_MODE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerRecord.TRANSACTION_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerRecord.SENT_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerRecord.RECEIVED_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerRecord.PARTY_NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerRecord.PARTY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerRecord.BALANCE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerRecord.DESCRIPTION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerRecord.DATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CustomerRecord.TIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _CustomerRecordModelType extends ModelType<CustomerRecord> {
  const _CustomerRecordModelType();
  
  @override
  CustomerRecord fromJson(Map<String, dynamic> jsonData) {
    return CustomerRecord.fromJson(jsonData);
  }
}