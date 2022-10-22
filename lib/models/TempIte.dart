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


/** This is an auto generated class representing the TempIte type in your schema. */
@immutable
class TempIte extends Model {
  static const classType = const _TempIteModelType();
  final String id;
  final String? _user_id;
  final String? _orderid;
  final String? _token_no;
  final String? _item_id;
  final String? _item_name;
  final String? _item_price_per_unit;
  final String? _item_unit;
  final String? _item_quantity;
  final String? _rented_duration;
  final String? _item_total;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get user_id {
    return _user_id;
  }
  
  String? get orderid {
    return _orderid;
  }
  
  String? get token_no {
    return _token_no;
  }
  
  String? get item_id {
    return _item_id;
  }
  
  String? get item_name {
    return _item_name;
  }
  
  String? get item_price_per_unit {
    return _item_price_per_unit;
  }
  
  String? get item_unit {
    return _item_unit;
  }
  
  String? get item_quantity {
    return _item_quantity;
  }
  
  String? get rented_duration {
    return _rented_duration;
  }
  
  String? get item_total {
    return _item_total;
  }
  
  const TempIte._internal({required this.id, user_id, orderid, token_no, item_id, item_name, item_price_per_unit, item_unit, item_quantity, rented_duration, item_total}): _user_id = user_id, _orderid = orderid, _token_no = token_no, _item_id = item_id, _item_name = item_name, _item_price_per_unit = item_price_per_unit, _item_unit = item_unit, _item_quantity = item_quantity, _rented_duration = rented_duration, _item_total = item_total;
  
  factory TempIte({String? id, String? user_id, String? orderid, String? token_no, String? item_id, String? item_name, String? item_price_per_unit, String? item_unit, String? item_quantity, String? rented_duration, String? item_total}) {
    return TempIte._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      orderid: orderid,
      token_no: token_no,
      item_id: item_id,
      item_name: item_name,
      item_price_per_unit: item_price_per_unit,
      item_unit: item_unit,
      item_quantity: item_quantity,
      rented_duration: rented_duration,
      item_total: item_total);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TempIte &&
      id == other.id &&
      _user_id == other._user_id &&
      _orderid == other._orderid &&
      _token_no == other._token_no &&
      _item_id == other._item_id &&
      _item_name == other._item_name &&
      _item_price_per_unit == other._item_price_per_unit &&
      _item_unit == other._item_unit &&
      _item_quantity == other._item_quantity &&
      _rented_duration == other._rented_duration &&
      _item_total == other._item_total;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("TempIte {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("orderid=" + "$_orderid" + ", ");
    buffer.write("token_no=" + "$_token_no" + ", ");
    buffer.write("item_id=" + "$_item_id" + ", ");
    buffer.write("item_name=" + "$_item_name" + ", ");
    buffer.write("item_price_per_unit=" + "$_item_price_per_unit" + ", ");
    buffer.write("item_unit=" + "$_item_unit" + ", ");
    buffer.write("item_quantity=" + "$_item_quantity" + ", ");
    buffer.write("rented_duration=" + "$_rented_duration" + ", ");
    buffer.write("item_total=" + "$_item_total");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  TempIte copyWith({String? id, String? user_id, String? orderid, String? token_no, String? item_id, String? item_name, String? item_price_per_unit, String? item_unit, String? item_quantity, String? rented_duration, String? item_total}) {
    return TempIte(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      orderid: orderid ?? this.orderid,
      token_no: token_no ?? this.token_no,
      item_id: item_id ?? this.item_id,
      item_name: item_name ?? this.item_name,
      item_price_per_unit: item_price_per_unit ?? this.item_price_per_unit,
      item_unit: item_unit ?? this.item_unit,
      item_quantity: item_quantity ?? this.item_quantity,
      rented_duration: rented_duration ?? this.rented_duration,
      item_total: item_total ?? this.item_total);
  }
  
  TempIte.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _orderid = json['orderid'],
      _token_no = json['token_no'],
      _item_id = json['item_id'],
      _item_name = json['item_name'],
      _item_price_per_unit = json['item_price_per_unit'],
      _item_unit = json['item_unit'],
      _item_quantity = json['item_quantity'],
      _rented_duration = json['rented_duration'],
      _item_total = json['item_total'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'orderid': _orderid, 'token_no': _token_no, 'item_id': _item_id, 'item_name': _item_name, 'item_price_per_unit': _item_price_per_unit, 'item_unit': _item_unit, 'item_quantity': _item_quantity, 'rented_duration': _rented_duration, 'item_total': _item_total
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField ORDERID = QueryField(fieldName: "orderid");
  static final QueryField TOKEN_NO = QueryField(fieldName: "token_no");
  static final QueryField ITEM_ID = QueryField(fieldName: "item_id");
  static final QueryField ITEM_NAME = QueryField(fieldName: "item_name");
  static final QueryField ITEM_PRICE_PER_UNIT = QueryField(fieldName: "item_price_per_unit");
  static final QueryField ITEM_UNIT = QueryField(fieldName: "item_unit");
  static final QueryField ITEM_QUANTITY = QueryField(fieldName: "item_quantity");
  static final QueryField RENTED_DURATION = QueryField(fieldName: "rented_duration");
  static final QueryField ITEM_TOTAL = QueryField(fieldName: "item_total");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "TempIte";
    modelSchemaDefinition.pluralName = "TempItes";
    
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
      key: TempIte.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TempIte.ORDERID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TempIte.TOKEN_NO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TempIte.ITEM_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TempIte.ITEM_NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TempIte.ITEM_PRICE_PER_UNIT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TempIte.ITEM_UNIT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TempIte.ITEM_QUANTITY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TempIte.RENTED_DURATION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: TempIte.ITEM_TOTAL,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _TempIteModelType extends ModelType<TempIte> {
  const _TempIteModelType();
  
  @override
  TempIte fromJson(Map<String, dynamic> jsonData) {
    return TempIte.fromJson(jsonData);
  }
}