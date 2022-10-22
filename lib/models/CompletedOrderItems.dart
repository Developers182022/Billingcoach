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


/** This is an auto generated class representing the CompletedOrderItems type in your schema. */
@immutable
class CompletedOrderItems extends Model {
  static const classType = const _CompletedOrderItemsModelType();
  final String id;
  final String? _user_id;
  final String? _order_id;
  final String? _token_no;
  final String? _item_id;
  final String? _item_unit;
  final String? _item_name;
  final String? _item_price;
  final String? _item_total;
  final String? _item_quantity;
  final String? _check_in_time;
  final String? _Check_out_time;
  final String? _item_status;
  final String? _rented_duration;

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
  
  String? get item_id {
    return _item_id;
  }
  
  String? get item_unit {
    return _item_unit;
  }
  
  String? get item_name {
    return _item_name;
  }
  
  String? get item_price {
    return _item_price;
  }
  
  String? get item_total {
    return _item_total;
  }
  
  String? get item_quantity {
    return _item_quantity;
  }
  
  String? get check_in_time {
    return _check_in_time;
  }
  
  String? get Check_out_time {
    return _Check_out_time;
  }
  
  String? get item_status {
    return _item_status;
  }
  
  String? get rented_duration {
    return _rented_duration;
  }
  
  const CompletedOrderItems._internal({required this.id, user_id, order_id, token_no, item_id, item_unit, item_name, item_price, item_total, item_quantity, check_in_time, Check_out_time, item_status, rented_duration}): _user_id = user_id, _order_id = order_id, _token_no = token_no, _item_id = item_id, _item_unit = item_unit, _item_name = item_name, _item_price = item_price, _item_total = item_total, _item_quantity = item_quantity, _check_in_time = check_in_time, _Check_out_time = Check_out_time, _item_status = item_status, _rented_duration = rented_duration;
  
  factory CompletedOrderItems({String? id, String? user_id, String? order_id, String? token_no, String? item_id, String? item_unit, String? item_name, String? item_price, String? item_total, String? item_quantity, String? check_in_time, String? Check_out_time, String? item_status, String? rented_duration}) {
    return CompletedOrderItems._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      order_id: order_id,
      token_no: token_no,
      item_id: item_id,
      item_unit: item_unit,
      item_name: item_name,
      item_price: item_price,
      item_total: item_total,
      item_quantity: item_quantity,
      check_in_time: check_in_time,
      Check_out_time: Check_out_time,
      item_status: item_status,
      rented_duration: rented_duration);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompletedOrderItems &&
      id == other.id &&
      _user_id == other._user_id &&
      _order_id == other._order_id &&
      _token_no == other._token_no &&
      _item_id == other._item_id &&
      _item_unit == other._item_unit &&
      _item_name == other._item_name &&
      _item_price == other._item_price &&
      _item_total == other._item_total &&
      _item_quantity == other._item_quantity &&
      _check_in_time == other._check_in_time &&
      _Check_out_time == other._Check_out_time &&
      _item_status == other._item_status &&
      _rented_duration == other._rented_duration;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("CompletedOrderItems {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("order_id=" + "$_order_id" + ", ");
    buffer.write("token_no=" + "$_token_no" + ", ");
    buffer.write("item_id=" + "$_item_id" + ", ");
    buffer.write("item_unit=" + "$_item_unit" + ", ");
    buffer.write("item_name=" + "$_item_name" + ", ");
    buffer.write("item_price=" + "$_item_price" + ", ");
    buffer.write("item_total=" + "$_item_total" + ", ");
    buffer.write("item_quantity=" + "$_item_quantity" + ", ");
    buffer.write("check_in_time=" + "$_check_in_time" + ", ");
    buffer.write("Check_out_time=" + "$_Check_out_time" + ", ");
    buffer.write("item_status=" + "$_item_status" + ", ");
    buffer.write("rented_duration=" + "$_rented_duration");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  CompletedOrderItems copyWith({String? id, String? user_id, String? order_id, String? token_no, String? item_id, String? item_unit, String? item_name, String? item_price, String? item_total, String? item_quantity, String? check_in_time, String? Check_out_time, String? item_status, String? rented_duration}) {
    return CompletedOrderItems(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      order_id: order_id ?? this.order_id,
      token_no: token_no ?? this.token_no,
      item_id: item_id ?? this.item_id,
      item_unit: item_unit ?? this.item_unit,
      item_name: item_name ?? this.item_name,
      item_price: item_price ?? this.item_price,
      item_total: item_total ?? this.item_total,
      item_quantity: item_quantity ?? this.item_quantity,
      check_in_time: check_in_time ?? this.check_in_time,
      Check_out_time: Check_out_time ?? this.Check_out_time,
      item_status: item_status ?? this.item_status,
      rented_duration: rented_duration ?? this.rented_duration);
  }
  
  CompletedOrderItems.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _order_id = json['order_id'],
      _token_no = json['token_no'],
      _item_id = json['item_id'],
      _item_unit = json['item_unit'],
      _item_name = json['item_name'],
      _item_price = json['item_price'],
      _item_total = json['item_total'],
      _item_quantity = json['item_quantity'],
      _check_in_time = json['check_in_time'],
      _Check_out_time = json['Check_out_time'],
      _item_status = json['item_status'],
      _rented_duration = json['rented_duration'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'order_id': _order_id, 'token_no': _token_no, 'item_id': _item_id, 'item_unit': _item_unit, 'item_name': _item_name, 'item_price': _item_price, 'item_total': _item_total, 'item_quantity': _item_quantity, 'check_in_time': _check_in_time, 'Check_out_time': _Check_out_time, 'item_status': _item_status, 'rented_duration': _rented_duration
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField ORDER_ID = QueryField(fieldName: "order_id");
  static final QueryField TOKEN_NO = QueryField(fieldName: "token_no");
  static final QueryField ITEM_ID = QueryField(fieldName: "item_id");
  static final QueryField ITEM_UNIT = QueryField(fieldName: "item_unit");
  static final QueryField ITEM_NAME = QueryField(fieldName: "item_name");
  static final QueryField ITEM_PRICE = QueryField(fieldName: "item_price");
  static final QueryField ITEM_TOTAL = QueryField(fieldName: "item_total");
  static final QueryField ITEM_QUANTITY = QueryField(fieldName: "item_quantity");
  static final QueryField CHECK_IN_TIME = QueryField(fieldName: "check_in_time");
  static final QueryField CHECK_OUT_TIME = QueryField(fieldName: "Check_out_time");
  static final QueryField ITEM_STATUS = QueryField(fieldName: "item_status");
  static final QueryField RENTED_DURATION = QueryField(fieldName: "rented_duration");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "CompletedOrderItems";
    modelSchemaDefinition.pluralName = "CompletedOrderItems";
    
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
      key: CompletedOrderItems.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrderItems.ORDER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrderItems.TOKEN_NO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrderItems.ITEM_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrderItems.ITEM_UNIT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrderItems.ITEM_NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrderItems.ITEM_PRICE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrderItems.ITEM_TOTAL,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrderItems.ITEM_QUANTITY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrderItems.CHECK_IN_TIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrderItems.CHECK_OUT_TIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrderItems.ITEM_STATUS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: CompletedOrderItems.RENTED_DURATION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _CompletedOrderItemsModelType extends ModelType<CompletedOrderItems> {
  const _CompletedOrderItemsModelType();
  
  @override
  CompletedOrderItems fromJson(Map<String, dynamic> jsonData) {
    return CompletedOrderItems.fromJson(jsonData);
  }
}