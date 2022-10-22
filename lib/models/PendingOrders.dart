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


/** This is an auto generated class representing the PendingOrders type in your schema. */
@immutable
class PendingOrders extends Model {
  static const classType = const _PendingOrdersModelType();
  final String id;
  final String? _user_id;
  final String? _order_id;
  final String? _token_no;
  final String? _total;
  final String? _additional_amount;
  final String? _discount_percent;
  final String? _discount_amount;
  final String? _Advance_amount;
  final String? _pending_amount;
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
  
  String? get order_id {
    return _order_id;
  }
  
  String? get token_no {
    return _token_no;
  }
  
  String? get total {
    return _total;
  }
  
  String? get additional_amount {
    return _additional_amount;
  }
  
  String? get discount_percent {
    return _discount_percent;
  }
  
  String? get discount_amount {
    return _discount_amount;
  }
  
  String? get Advance_amount {
    return _Advance_amount;
  }
  
  String? get pending_amount {
    return _pending_amount;
  }
  
  String? get date {
    return _date;
  }
  
  String? get time {
    return _time;
  }
  
  const PendingOrders._internal({required this.id, user_id, order_id, token_no, total, additional_amount, discount_percent, discount_amount, Advance_amount, pending_amount, date, time}): _user_id = user_id, _order_id = order_id, _token_no = token_no, _total = total, _additional_amount = additional_amount, _discount_percent = discount_percent, _discount_amount = discount_amount, _Advance_amount = Advance_amount, _pending_amount = pending_amount, _date = date, _time = time;
  
  factory PendingOrders({String? id, String? user_id, String? order_id, String? token_no, String? total, String? additional_amount, String? discount_percent, String? discount_amount, String? Advance_amount, String? pending_amount, String? date, String? time}) {
    return PendingOrders._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      order_id: order_id,
      token_no: token_no,
      total: total,
      additional_amount: additional_amount,
      discount_percent: discount_percent,
      discount_amount: discount_amount,
      Advance_amount: Advance_amount,
      pending_amount: pending_amount,
      date: date,
      time: time);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PendingOrders &&
      id == other.id &&
      _user_id == other._user_id &&
      _order_id == other._order_id &&
      _token_no == other._token_no &&
      _total == other._total &&
      _additional_amount == other._additional_amount &&
      _discount_percent == other._discount_percent &&
      _discount_amount == other._discount_amount &&
      _Advance_amount == other._Advance_amount &&
      _pending_amount == other._pending_amount &&
      _date == other._date &&
      _time == other._time;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("PendingOrders {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("order_id=" + "$_order_id" + ", ");
    buffer.write("token_no=" + "$_token_no" + ", ");
    buffer.write("total=" + "$_total" + ", ");
    buffer.write("additional_amount=" + "$_additional_amount" + ", ");
    buffer.write("discount_percent=" + "$_discount_percent" + ", ");
    buffer.write("discount_amount=" + "$_discount_amount" + ", ");
    buffer.write("Advance_amount=" + "$_Advance_amount" + ", ");
    buffer.write("pending_amount=" + "$_pending_amount" + ", ");
    buffer.write("date=" + "$_date" + ", ");
    buffer.write("time=" + "$_time");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  PendingOrders copyWith({String? id, String? user_id, String? order_id, String? token_no, String? total, String? additional_amount, String? discount_percent, String? discount_amount, String? Advance_amount, String? pending_amount, String? date, String? time}) {
    return PendingOrders(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      order_id: order_id ?? this.order_id,
      token_no: token_no ?? this.token_no,
      total: total ?? this.total,
      additional_amount: additional_amount ?? this.additional_amount,
      discount_percent: discount_percent ?? this.discount_percent,
      discount_amount: discount_amount ?? this.discount_amount,
      Advance_amount: Advance_amount ?? this.Advance_amount,
      pending_amount: pending_amount ?? this.pending_amount,
      date: date ?? this.date,
      time: time ?? this.time);
  }
  
  PendingOrders.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _order_id = json['order_id'],
      _token_no = json['token_no'],
      _total = json['total'],
      _additional_amount = json['additional_amount'],
      _discount_percent = json['discount_percent'],
      _discount_amount = json['discount_amount'],
      _Advance_amount = json['Advance_amount'],
      _pending_amount = json['pending_amount'],
      _date = json['date'],
      _time = json['time'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'order_id': _order_id, 'token_no': _token_no, 'total': _total, 'additional_amount': _additional_amount, 'discount_percent': _discount_percent, 'discount_amount': _discount_amount, 'Advance_amount': _Advance_amount, 'pending_amount': _pending_amount, 'date': _date, 'time': _time
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField ORDER_ID = QueryField(fieldName: "order_id");
  static final QueryField TOKEN_NO = QueryField(fieldName: "token_no");
  static final QueryField TOTAL = QueryField(fieldName: "total");
  static final QueryField ADDITIONAL_AMOUNT = QueryField(fieldName: "additional_amount");
  static final QueryField DISCOUNT_PERCENT = QueryField(fieldName: "discount_percent");
  static final QueryField DISCOUNT_AMOUNT = QueryField(fieldName: "discount_amount");
  static final QueryField ADVANCE_AMOUNT = QueryField(fieldName: "Advance_amount");
  static final QueryField PENDING_AMOUNT = QueryField(fieldName: "pending_amount");
  static final QueryField DATE = QueryField(fieldName: "date");
  static final QueryField TIME = QueryField(fieldName: "time");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "PendingOrders";
    modelSchemaDefinition.pluralName = "PendingOrders";
    
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
      key: PendingOrders.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PendingOrders.ORDER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PendingOrders.TOKEN_NO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PendingOrders.TOTAL,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PendingOrders.ADDITIONAL_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PendingOrders.DISCOUNT_PERCENT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PendingOrders.DISCOUNT_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PendingOrders.ADVANCE_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PendingOrders.PENDING_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PendingOrders.DATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PendingOrders.TIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _PendingOrdersModelType extends ModelType<PendingOrders> {
  const _PendingOrdersModelType();
  
  @override
  PendingOrders fromJson(Map<String, dynamic> jsonData) {
    return PendingOrders.fromJson(jsonData);
  }
}