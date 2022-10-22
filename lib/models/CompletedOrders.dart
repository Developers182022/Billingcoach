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


/** This is an auto generated class representing the CompletedOrders type in your schema. */
@immutable
class CompletedOrders extends Model {
  static const classType = const _CompletedOrdersModelType();
  final String id;
  final String? _user_id;
  final String? _order_id;
  final String? _token_no;
  final String? _Advance_amount;
  final String? _pending_amount;
  final String? _total;
  final String? _payment_mode;
  final String? _payment_status;
  final String? _transaction_id;
  final String? _status;
  final String? _date;
  final String? _time;
  final String? _additional_amount;
  final String? _discount_amout;
  final String? _discount_percent;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get user_id {
    return _user_id;
  }
  
  String? get order_id {
    return _order_id;
  }
  
  String? get token_no {
    return _token_no;
  }
  
  String? get Advance_amount {
    return _Advance_amount;
  }
  
  String? get pending_amount {
    return _pending_amount;
  }
  
  String? get total {
    return _total;
  }
  
  String? get payment_mode {
    return _payment_mode;
  }
  
  String? get payment_status {
    return _payment_status;
  }
  
  String? get transaction_id {
    return _transaction_id;
  }
  
  String? get status {
    return _status;
  }
  
  String? get date {
    return _date;
  }
  
  String? get time {
    return _time;
  }
  
  String? get additional_amount {
    return _additional_amount;
  }
  
  String? get discount_amout {
    return _discount_amout;
  }
  
  String? get discount_percent {
    return _discount_percent;
  }
  
  const CompletedOrders._internal({required this.id, user_id, order_id, token_no, Advance_amount, pending_amount, total, payment_mode, payment_status, transaction_id, status, date, time, additional_amount, discount_amout, discount_percent}): _user_id = user_id, _order_id = order_id, _token_no = token_no, _Advance_amount = Advance_amount, _pending_amount = pending_amount, _total = total, _payment_mode = payment_mode, _payment_status = payment_status, _transaction_id = transaction_id, _status = status, _date = date, _time = time, _additional_amount = additional_amount, _discount_amout = discount_amout, _discount_percent = discount_percent;
  
  factory CompletedOrders({String? id, String? user_id, String? order_id, String? token_no, String? Advance_amount, String? pending_amount, String? total, String? payment_mode, String? payment_status, String? transaction_id, String? status, String? date, String? time, String? additional_amount, String? discount_amout, String? discount_percent}) {
    return CompletedOrders._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      order_id: order_id,
      token_no: token_no,
      Advance_amount: Advance_amount,
      pending_amount: pending_amount,
      total: total,
      payment_mode: payment_mode,
      payment_status: payment_status,
      transaction_id: transaction_id,
      status: status,
      date: date,
      time: time,
      additional_amount: additional_amount,
      discount_amout: discount_amout,
      discount_percent: discount_percent);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompletedOrders &&
      id == other.id &&
      _user_id == other._user_id &&
      _order_id == other._order_id &&
      _token_no == other._token_no &&
      _Advance_amount == other._Advance_amount &&
      _pending_amount == other._pending_amount &&
      _total == other._total &&
      _payment_mode == other._payment_mode &&
      _payment_status == other._payment_status &&
      _transaction_id == other._transaction_id &&
      _status == other._status &&
      _date == other._date &&
      _time == other._time &&
      _additional_amount == other._additional_amount &&
      _discount_amout == other._discount_amout &&
      _discount_percent == other._discount_percent;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("CompletedOrders {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("order_id=" + "$_order_id" + ", ");
    buffer.write("token_no=" + "$_token_no" + ", ");
    buffer.write("Advance_amount=" + "$_Advance_amount" + ", ");
    buffer.write("pending_amount=" + "$_pending_amount" + ", ");
    buffer.write("total=" + "$_total" + ", ");
    buffer.write("payment_mode=" + "$_payment_mode" + ", ");
    buffer.write("payment_status=" + "$_payment_status" + ", ");
    buffer.write("transaction_id=" + "$_transaction_id" + ", ");
    buffer.write("status=" + "$_status" + ", ");
    buffer.write("date=" + "$_date" + ", ");
    buffer.write("time=" + "$_time" + ", ");
    buffer.write("additional_amount=" + "$_additional_amount" + ", ");
    buffer.write("discount_amout=" + "$_discount_amout" + ", ");
    buffer.write("discount_percent=" + "$_discount_percent");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  CompletedOrders copyWith({String? id, String? user_id, String? order_id, String? token_no, String? Advance_amount, String? pending_amount, String? total, String? payment_mode, String? payment_status, String? transaction_id, String? status, String? date, String? time, String? additional_amount, String? discount_amout, String? discount_percent}) {
    return CompletedOrders(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      order_id: order_id ?? this.order_id,
      token_no: token_no ?? this.token_no,
      Advance_amount: Advance_amount ?? this.Advance_amount,
      pending_amount: pending_amount ?? this.pending_amount,
      total: total ?? this.total,
      payment_mode: payment_mode ?? this.payment_mode,
      payment_status: payment_status ?? this.payment_status,
      transaction_id: transaction_id ?? this.transaction_id,
      status: status ?? this.status,
      date: date ?? this.date,
      time: time ?? this.time,
      additional_amount: additional_amount ?? this.additional_amount,
      discount_amout: discount_amout ?? this.discount_amout,
      discount_percent: discount_percent ?? this.discount_percent);
  }
  
  CompletedOrders.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _order_id = json['order_id'],
      _token_no = json['token_no'],
      _Advance_amount = json['Advance_amount'],
      _pending_amount = json['pending_amount'],
      _total = json['total'],
      _payment_mode = json['payment_mode'],
      _payment_status = json['payment_status'],
      _transaction_id = json['transaction_id'],
      _status = json['status'],
      _date = json['date'],
      _time = json['time'],
      _additional_amount = json['additional_amount'],
      _discount_amout = json['discount_amout'],
      _discount_percent = json['discount_percent'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'order_id': _order_id, 'token_no': _token_no, 'Advance_amount': _Advance_amount, 'pending_amount': _pending_amount, 'total': _total, 'payment_mode': _payment_mode, 'payment_status': _payment_status, 'transaction_id': _transaction_id, 'status': _status, 'date': _date, 'time': _time, 'additional_amount': _additional_amount, 'discount_amout': _discount_amout, 'discount_percent': _discount_percent
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField ORDER_ID = QueryField(fieldName: "order_id");
  static final QueryField TOKEN_NO = QueryField(fieldName: "token_no");
  static final QueryField ADVANCE_AMOUNT = QueryField(fieldName: "Advance_amount");
  static final QueryField PENDING_AMOUNT = QueryField(fieldName: "pending_amount");
  static final QueryField TOTAL = QueryField(fieldName: "total");
  static final QueryField PAYMENT_MODE = QueryField(fieldName: "payment_mode");
  static final QueryField PAYMENT_STATUS = QueryField(fieldName: "payment_status");
  static final QueryField TRANSACTION_ID = QueryField(fieldName: "transaction_id");
  static final QueryField STATUS = QueryField(fieldName: "status");
  static final QueryField DATE = QueryField(fieldName: "date");
  static final QueryField TIME = QueryField(fieldName: "time");
  static final QueryField ADDITIONAL_AMOUNT = QueryField(fieldName: "additional_amount");
  static final QueryField DISCOUNT_AMOUT = QueryField(fieldName: "discount_amout");
  static final QueryField DISCOUNT_PERCENT = QueryField(fieldName: "discount_percent");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "CompletedOrders";
    modelSchemaDefinition.pluralName = "CompletedOrders";
    
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
      key: CompletedOrders.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrders.ORDER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrders.TOKEN_NO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrders.ADVANCE_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrders.PENDING_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrders.TOTAL,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrders.PAYMENT_MODE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrders.PAYMENT_STATUS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrders.TRANSACTION_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrders.STATUS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrders.DATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrders.TIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrders.ADDITIONAL_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrders.DISCOUNT_AMOUT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrders.DISCOUNT_PERCENT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _CompletedOrdersModelType extends ModelType<CompletedOrders> {
  const _CompletedOrdersModelType();
  
  @override
  CompletedOrders fromJson(Map<String, dynamic> jsonData) {
    return CompletedOrders.fromJson(jsonData);
  }
}