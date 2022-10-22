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


/** This is an auto generated class representing the DeletedOrder type in your schema. */
@immutable
class DeletedOrder extends Model {
  static const classType = const _DeletedOrderModelType();
  final String id;
  final String? _user_id;
  final String? _order_id;
  final String? _token_no;
  final String? _total;
  final String? _status;
  final String? _date;
  final String? _time;
  final String? _Advance_amount;
  final String? _pending_amount;

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
  
  String? get total {
    return _total;
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
  
  String? get Advance_amount {
    return _Advance_amount;
  }
  
  String? get pending_amount {
    return _pending_amount;
  }
  
  const DeletedOrder._internal({required this.id, user_id, order_id, token_no, total, status, date, time, Advance_amount, pending_amount}): _user_id = user_id, _order_id = order_id, _token_no = token_no, _total = total, _status = status, _date = date, _time = time, _Advance_amount = Advance_amount, _pending_amount = pending_amount;
  
  factory DeletedOrder({String? id, String? user_id, String? order_id, String? token_no, String? total, String? status, String? date, String? time, String? Advance_amount, String? pending_amount}) {
    return DeletedOrder._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      order_id: order_id,
      token_no: token_no,
      total: total,
      status: status,
      date: date,
      time: time,
      Advance_amount: Advance_amount,
      pending_amount: pending_amount);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeletedOrder &&
      id == other.id &&
      _user_id == other._user_id &&
      _order_id == other._order_id &&
      _token_no == other._token_no &&
      _total == other._total &&
      _status == other._status &&
      _date == other._date &&
      _time == other._time &&
      _Advance_amount == other._Advance_amount &&
      _pending_amount == other._pending_amount;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("DeletedOrder {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("order_id=" + "$_order_id" + ", ");
    buffer.write("token_no=" + "$_token_no" + ", ");
    buffer.write("total=" + "$_total" + ", ");
    buffer.write("status=" + "$_status" + ", ");
    buffer.write("date=" + "$_date" + ", ");
    buffer.write("time=" + "$_time" + ", ");
    buffer.write("Advance_amount=" + "$_Advance_amount" + ", ");
    buffer.write("pending_amount=" + "$_pending_amount");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  DeletedOrder copyWith({String? id, String? user_id, String? order_id, String? token_no, String? total, String? status, String? date, String? time, String? Advance_amount, String? pending_amount}) {
    return DeletedOrder(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      order_id: order_id ?? this.order_id,
      token_no: token_no ?? this.token_no,
      total: total ?? this.total,
      status: status ?? this.status,
      date: date ?? this.date,
      time: time ?? this.time,
      Advance_amount: Advance_amount ?? this.Advance_amount,
      pending_amount: pending_amount ?? this.pending_amount);
  }
  
  DeletedOrder.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _order_id = json['order_id'],
      _token_no = json['token_no'],
      _total = json['total'],
      _status = json['status'],
      _date = json['date'],
      _time = json['time'],
      _Advance_amount = json['Advance_amount'],
      _pending_amount = json['pending_amount'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'order_id': _order_id, 'token_no': _token_no, 'total': _total, 'status': _status, 'date': _date, 'time': _time, 'Advance_amount': _Advance_amount, 'pending_amount': _pending_amount
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField ORDER_ID = QueryField(fieldName: "order_id");
  static final QueryField TOKEN_NO = QueryField(fieldName: "token_no");
  static final QueryField TOTAL = QueryField(fieldName: "total");
  static final QueryField STATUS = QueryField(fieldName: "status");
  static final QueryField DATE = QueryField(fieldName: "date");
  static final QueryField TIME = QueryField(fieldName: "time");
  static final QueryField ADVANCE_AMOUNT = QueryField(fieldName: "Advance_amount");
  static final QueryField PENDING_AMOUNT = QueryField(fieldName: "pending_amount");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "DeletedOrder";
    modelSchemaDefinition.pluralName = "DeletedOrders";
    
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
      key: DeletedOrder.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: DeletedOrder.ORDER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: DeletedOrder.TOKEN_NO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: DeletedOrder.TOTAL,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: DeletedOrder.STATUS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: DeletedOrder.DATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: DeletedOrder.TIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: DeletedOrder.ADVANCE_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: DeletedOrder.PENDING_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _DeletedOrderModelType extends ModelType<DeletedOrder> {
  const _DeletedOrderModelType();
  
  @override
  DeletedOrder fromJson(Map<String, dynamic> jsonData) {
    return DeletedOrder.fromJson(jsonData);
  }
}