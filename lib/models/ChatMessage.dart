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


/** This is an auto generated class representing the ChatMessage type in your schema. */
@immutable
class ChatMessage extends Model {
  static const classType = const _ChatMessageModelType();
  final String id;
  final String? _user_id;
  final String? _client_id;
  final String? _message_id;
  final String? _Chat_status;
  final String? _Message;
  final String? _file_url;
  final String? _file_key;
  final String? _file_type;
  final String? _payment_status;
  final String? _Advance_amount;
  final String? _pending_amount;
  final String? _status;
  final String? _delivery_mode;
  final String? _additional_charges;
  final String? _delivery_charges;
  final String? _payment_mode;
  final String? _total;
  final String? _transaction_id;
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
  
  String? get client_id {
    return _client_id;
  }
  
  String? get message_id {
    return _message_id;
  }
  
  String? get Chat_status {
    return _Chat_status;
  }
  
  String? get Message {
    return _Message;
  }
  
  String? get file_url {
    return _file_url;
  }
  
  String? get file_key {
    return _file_key;
  }
  
  String? get file_type {
    return _file_type;
  }
  
  String? get payment_status {
    return _payment_status;
  }
  
  String? get Advance_amount {
    return _Advance_amount;
  }
  
  String? get pending_amount {
    return _pending_amount;
  }
  
  String? get status {
    return _status;
  }
  
  String? get delivery_mode {
    return _delivery_mode;
  }
  
  String? get additional_charges {
    return _additional_charges;
  }
  
  String? get delivery_charges {
    return _delivery_charges;
  }
  
  String? get payment_mode {
    return _payment_mode;
  }
  
  String? get total {
    return _total;
  }
  
  String? get transaction_id {
    return _transaction_id;
  }
  
  String? get time {
    return _time;
  }
  
  String? get date {
    return _date;
  }
  
  const ChatMessage._internal({required this.id, user_id, client_id, message_id, Chat_status, Message, file_url, file_key, file_type, payment_status, Advance_amount, pending_amount, status, delivery_mode, additional_charges, delivery_charges, payment_mode, total, transaction_id, time, date}): _user_id = user_id, _client_id = client_id, _message_id = message_id, _Chat_status = Chat_status, _Message = Message, _file_url = file_url, _file_key = file_key, _file_type = file_type, _payment_status = payment_status, _Advance_amount = Advance_amount, _pending_amount = pending_amount, _status = status, _delivery_mode = delivery_mode, _additional_charges = additional_charges, _delivery_charges = delivery_charges, _payment_mode = payment_mode, _total = total, _transaction_id = transaction_id, _time = time, _date = date;
  
  factory ChatMessage({String? id, String? user_id, String? client_id, String? message_id, String? Chat_status, String? Message, String? file_url, String? file_key, String? file_type, String? payment_status, String? Advance_amount, String? pending_amount, String? status, String? delivery_mode, String? additional_charges, String? delivery_charges, String? payment_mode, String? total, String? transaction_id, String? time, String? date}) {
    return ChatMessage._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      client_id: client_id,
      message_id: message_id,
      Chat_status: Chat_status,
      Message: Message,
      file_url: file_url,
      file_key: file_key,
      file_type: file_type,
      payment_status: payment_status,
      Advance_amount: Advance_amount,
      pending_amount: pending_amount,
      status: status,
      delivery_mode: delivery_mode,
      additional_charges: additional_charges,
      delivery_charges: delivery_charges,
      payment_mode: payment_mode,
      total: total,
      transaction_id: transaction_id,
      time: time,
      date: date);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatMessage &&
      id == other.id &&
      _user_id == other._user_id &&
      _client_id == other._client_id &&
      _message_id == other._message_id &&
      _Chat_status == other._Chat_status &&
      _Message == other._Message &&
      _file_url == other._file_url &&
      _file_key == other._file_key &&
      _file_type == other._file_type &&
      _payment_status == other._payment_status &&
      _Advance_amount == other._Advance_amount &&
      _pending_amount == other._pending_amount &&
      _status == other._status &&
      _delivery_mode == other._delivery_mode &&
      _additional_charges == other._additional_charges &&
      _delivery_charges == other._delivery_charges &&
      _payment_mode == other._payment_mode &&
      _total == other._total &&
      _transaction_id == other._transaction_id &&
      _time == other._time &&
      _date == other._date;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ChatMessage {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("client_id=" + "$_client_id" + ", ");
    buffer.write("message_id=" + "$_message_id" + ", ");
    buffer.write("Chat_status=" + "$_Chat_status" + ", ");
    buffer.write("Message=" + "$_Message" + ", ");
    buffer.write("file_url=" + "$_file_url" + ", ");
    buffer.write("file_key=" + "$_file_key" + ", ");
    buffer.write("file_type=" + "$_file_type" + ", ");
    buffer.write("payment_status=" + "$_payment_status" + ", ");
    buffer.write("Advance_amount=" + "$_Advance_amount" + ", ");
    buffer.write("pending_amount=" + "$_pending_amount" + ", ");
    buffer.write("status=" + "$_status" + ", ");
    buffer.write("delivery_mode=" + "$_delivery_mode" + ", ");
    buffer.write("additional_charges=" + "$_additional_charges" + ", ");
    buffer.write("delivery_charges=" + "$_delivery_charges" + ", ");
    buffer.write("payment_mode=" + "$_payment_mode" + ", ");
    buffer.write("total=" + "$_total" + ", ");
    buffer.write("transaction_id=" + "$_transaction_id" + ", ");
    buffer.write("time=" + "$_time" + ", ");
    buffer.write("date=" + "$_date");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ChatMessage copyWith({String? id, String? user_id, String? client_id, String? message_id, String? Chat_status, String? Message, String? file_url, String? file_key, String? file_type, String? payment_status, String? Advance_amount, String? pending_amount, String? status, String? delivery_mode, String? additional_charges, String? delivery_charges, String? payment_mode, String? total, String? transaction_id, String? time, String? date}) {
    return ChatMessage(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      client_id: client_id ?? this.client_id,
      message_id: message_id ?? this.message_id,
      Chat_status: Chat_status ?? this.Chat_status,
      Message: Message ?? this.Message,
      file_url: file_url ?? this.file_url,
      file_key: file_key ?? this.file_key,
      file_type: file_type ?? this.file_type,
      payment_status: payment_status ?? this.payment_status,
      Advance_amount: Advance_amount ?? this.Advance_amount,
      pending_amount: pending_amount ?? this.pending_amount,
      status: status ?? this.status,
      delivery_mode: delivery_mode ?? this.delivery_mode,
      additional_charges: additional_charges ?? this.additional_charges,
      delivery_charges: delivery_charges ?? this.delivery_charges,
      payment_mode: payment_mode ?? this.payment_mode,
      total: total ?? this.total,
      transaction_id: transaction_id ?? this.transaction_id,
      time: time ?? this.time,
      date: date ?? this.date);
  }
  
  ChatMessage.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _client_id = json['client_id'],
      _message_id = json['message_id'],
      _Chat_status = json['Chat_status'],
      _Message = json['Message'],
      _file_url = json['file_url'],
      _file_key = json['file_key'],
      _file_type = json['file_type'],
      _payment_status = json['payment_status'],
      _Advance_amount = json['Advance_amount'],
      _pending_amount = json['pending_amount'],
      _status = json['status'],
      _delivery_mode = json['delivery_mode'],
      _additional_charges = json['additional_charges'],
      _delivery_charges = json['delivery_charges'],
      _payment_mode = json['payment_mode'],
      _total = json['total'],
      _transaction_id = json['transaction_id'],
      _time = json['time'],
      _date = json['date'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'client_id': _client_id, 'message_id': _message_id, 'Chat_status': _Chat_status, 'Message': _Message, 'file_url': _file_url, 'file_key': _file_key, 'file_type': _file_type, 'payment_status': _payment_status, 'Advance_amount': _Advance_amount, 'pending_amount': _pending_amount, 'status': _status, 'delivery_mode': _delivery_mode, 'additional_charges': _additional_charges, 'delivery_charges': _delivery_charges, 'payment_mode': _payment_mode, 'total': _total, 'transaction_id': _transaction_id, 'time': _time, 'date': _date
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField CLIENT_ID = QueryField(fieldName: "client_id");
  static final QueryField MESSAGE_ID = QueryField(fieldName: "message_id");
  static final QueryField CHAT_STATUS = QueryField(fieldName: "Chat_status");
  static final QueryField MESSAGE = QueryField(fieldName: "Message");
  static final QueryField FILE_URL = QueryField(fieldName: "file_url");
  static final QueryField FILE_KEY = QueryField(fieldName: "file_key");
  static final QueryField FILE_TYPE = QueryField(fieldName: "file_type");
  static final QueryField PAYMENT_STATUS = QueryField(fieldName: "payment_status");
  static final QueryField ADVANCE_AMOUNT = QueryField(fieldName: "Advance_amount");
  static final QueryField PENDING_AMOUNT = QueryField(fieldName: "pending_amount");
  static final QueryField STATUS = QueryField(fieldName: "status");
  static final QueryField DELIVERY_MODE = QueryField(fieldName: "delivery_mode");
  static final QueryField ADDITIONAL_CHARGES = QueryField(fieldName: "additional_charges");
  static final QueryField DELIVERY_CHARGES = QueryField(fieldName: "delivery_charges");
  static final QueryField PAYMENT_MODE = QueryField(fieldName: "payment_mode");
  static final QueryField TOTAL = QueryField(fieldName: "total");
  static final QueryField TRANSACTION_ID = QueryField(fieldName: "transaction_id");
  static final QueryField TIME = QueryField(fieldName: "time");
  static final QueryField DATE = QueryField(fieldName: "date");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ChatMessage";
    modelSchemaDefinition.pluralName = "ChatMessages";
    
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
      key: ChatMessage.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.CLIENT_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.MESSAGE_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.CHAT_STATUS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.MESSAGE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.FILE_URL,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.FILE_KEY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.FILE_TYPE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.PAYMENT_STATUS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.ADVANCE_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.PENDING_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.STATUS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.DELIVERY_MODE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.ADDITIONAL_CHARGES,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.DELIVERY_CHARGES,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.PAYMENT_MODE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.TOTAL,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.TRANSACTION_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.TIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ChatMessage.DATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _ChatMessageModelType extends ModelType<ChatMessage> {
  const _ChatMessageModelType();
  
  @override
  ChatMessage fromJson(Map<String, dynamic> jsonData) {
    return ChatMessage.fromJson(jsonData);
  }
}