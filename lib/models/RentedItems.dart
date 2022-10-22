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


/** This is an auto generated class representing the RentedItems type in your schema. */
@immutable
class RentedItems extends Model {
  static const classType = const _RentedItemsModelType();
  final String id;
  final String? _user_id;
  final String? _product_id;
  final String? _rented_duration;
  final String? _charger_per_duration;
  final String? _rented_item_name;
  final String? _product_engagement;
  final String? _rentout_to_client_id;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get user_id {
    return _user_id;
  }
  
  String? get product_id {
    return _product_id;
  }
  
  String? get rented_duration {
    return _rented_duration;
  }
  
  String? get charger_per_duration {
    return _charger_per_duration;
  }
  
  String? get rented_item_name {
    return _rented_item_name;
  }
  
  String? get product_engagement {
    return _product_engagement;
  }
  
  String? get rentout_to_client_id {
    return _rentout_to_client_id;
  }
  
  const RentedItems._internal({required this.id, user_id, product_id, rented_duration, charger_per_duration, rented_item_name, product_engagement, rentout_to_client_id}): _user_id = user_id, _product_id = product_id, _rented_duration = rented_duration, _charger_per_duration = charger_per_duration, _rented_item_name = rented_item_name, _product_engagement = product_engagement, _rentout_to_client_id = rentout_to_client_id;
  
  factory RentedItems({String? id, String? user_id, String? product_id, String? rented_duration, String? charger_per_duration, String? rented_item_name, String? product_engagement, String? rentout_to_client_id}) {
    return RentedItems._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      product_id: product_id,
      rented_duration: rented_duration,
      charger_per_duration: charger_per_duration,
      rented_item_name: rented_item_name,
      product_engagement: product_engagement,
      rentout_to_client_id: rentout_to_client_id);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RentedItems &&
      id == other.id &&
      _user_id == other._user_id &&
      _product_id == other._product_id &&
      _rented_duration == other._rented_duration &&
      _charger_per_duration == other._charger_per_duration &&
      _rented_item_name == other._rented_item_name &&
      _product_engagement == other._product_engagement &&
      _rentout_to_client_id == other._rentout_to_client_id;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("RentedItems {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("product_id=" + "$_product_id" + ", ");
    buffer.write("rented_duration=" + "$_rented_duration" + ", ");
    buffer.write("charger_per_duration=" + "$_charger_per_duration" + ", ");
    buffer.write("rented_item_name=" + "$_rented_item_name" + ", ");
    buffer.write("product_engagement=" + "$_product_engagement" + ", ");
    buffer.write("rentout_to_client_id=" + "$_rentout_to_client_id");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  RentedItems copyWith({String? id, String? user_id, String? product_id, String? rented_duration, String? charger_per_duration, String? rented_item_name, String? product_engagement, String? rentout_to_client_id}) {
    return RentedItems(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      product_id: product_id ?? this.product_id,
      rented_duration: rented_duration ?? this.rented_duration,
      charger_per_duration: charger_per_duration ?? this.charger_per_duration,
      rented_item_name: rented_item_name ?? this.rented_item_name,
      product_engagement: product_engagement ?? this.product_engagement,
      rentout_to_client_id: rentout_to_client_id ?? this.rentout_to_client_id);
  }
  
  RentedItems.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _product_id = json['product_id'],
      _rented_duration = json['rented_duration'],
      _charger_per_duration = json['charger_per_duration'],
      _rented_item_name = json['rented_item_name'],
      _product_engagement = json['product_engagement'],
      _rentout_to_client_id = json['rentout_to_client_id'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'product_id': _product_id, 'rented_duration': _rented_duration, 'charger_per_duration': _charger_per_duration, 'rented_item_name': _rented_item_name, 'product_engagement': _product_engagement, 'rentout_to_client_id': _rentout_to_client_id
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField PRODUCT_ID = QueryField(fieldName: "product_id");
  static final QueryField RENTED_DURATION = QueryField(fieldName: "rented_duration");
  static final QueryField CHARGER_PER_DURATION = QueryField(fieldName: "charger_per_duration");
  static final QueryField RENTED_ITEM_NAME = QueryField(fieldName: "rented_item_name");
  static final QueryField PRODUCT_ENGAGEMENT = QueryField(fieldName: "product_engagement");
  static final QueryField RENTOUT_TO_CLIENT_ID = QueryField(fieldName: "rentout_to_client_id");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "RentedItems";
    modelSchemaDefinition.pluralName = "RentedItems";
    
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
      key: RentedItems.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: RentedItems.PRODUCT_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: RentedItems.RENTED_DURATION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: RentedItems.CHARGER_PER_DURATION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: RentedItems.RENTED_ITEM_NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: RentedItems.PRODUCT_ENGAGEMENT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: RentedItems.RENTOUT_TO_CLIENT_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _RentedItemsModelType extends ModelType<RentedItems> {
  const _RentedItemsModelType();
  
  @override
  RentedItems fromJson(Map<String, dynamic> jsonData) {
    return RentedItems.fromJson(jsonData);
  }
}