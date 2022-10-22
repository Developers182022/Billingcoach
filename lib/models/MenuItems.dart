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


/** This is an auto generated class representing the MenuItems type in your schema. */
@immutable
class MenuItems extends Model {
  static const classType = const _MenuItemsModelType();
  final String id;
  final String? _user_id;
  final String? _item_id;
  final String? _item_name;
  final String? _item_price_per_unit;
  final String? _item_unit;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get user_id {
    return _user_id;
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
  
  const MenuItems._internal({required this.id, user_id, item_id, item_name, item_price_per_unit, item_unit}): _user_id = user_id, _item_id = item_id, _item_name = item_name, _item_price_per_unit = item_price_per_unit, _item_unit = item_unit;
  
  factory MenuItems({String? id, String? user_id, String? item_id, String? item_name, String? item_price_per_unit, String? item_unit}) {
    return MenuItems._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      item_id: item_id,
      item_name: item_name,
      item_price_per_unit: item_price_per_unit,
      item_unit: item_unit);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MenuItems &&
      id == other.id &&
      _user_id == other._user_id &&
      _item_id == other._item_id &&
      _item_name == other._item_name &&
      _item_price_per_unit == other._item_price_per_unit &&
      _item_unit == other._item_unit;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("MenuItems {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("item_id=" + "$_item_id" + ", ");
    buffer.write("item_name=" + "$_item_name" + ", ");
    buffer.write("item_price_per_unit=" + "$_item_price_per_unit" + ", ");
    buffer.write("item_unit=" + "$_item_unit");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  MenuItems copyWith({String? id, String? user_id, String? item_id, String? item_name, String? item_price_per_unit, String? item_unit}) {
    return MenuItems(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      item_id: item_id ?? this.item_id,
      item_name: item_name ?? this.item_name,
      item_price_per_unit: item_price_per_unit ?? this.item_price_per_unit,
      item_unit: item_unit ?? this.item_unit);
  }
  
  MenuItems.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _item_id = json['item_id'],
      _item_name = json['item_name'],
      _item_price_per_unit = json['item_price_per_unit'],
      _item_unit = json['item_unit'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'item_id': _item_id, 'item_name': _item_name, 'item_price_per_unit': _item_price_per_unit, 'item_unit': _item_unit
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField ITEM_ID = QueryField(fieldName: "item_id");
  static final QueryField ITEM_NAME = QueryField(fieldName: "item_name");
  static final QueryField ITEM_PRICE_PER_UNIT = QueryField(fieldName: "item_price_per_unit");
  static final QueryField ITEM_UNIT = QueryField(fieldName: "item_unit");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "MenuItems";
    modelSchemaDefinition.pluralName = "MenuItems";
    
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
      key: MenuItems.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MenuItems.ITEM_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MenuItems.ITEM_NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MenuItems.ITEM_PRICE_PER_UNIT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MenuItems.ITEM_UNIT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _MenuItemsModelType extends ModelType<MenuItems> {
  const _MenuItemsModelType();
  
  @override
  MenuItems fromJson(Map<String, dynamic> jsonData) {
    return MenuItems.fromJson(jsonData);
  }
}