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


/** This is an auto generated class representing the AcceptedSuppliers type in your schema. */
@immutable
class AcceptedSuppliers extends Model {
  static const classType = const _AcceptedSuppliersModelType();
  final String id;
  final String? _user_id;
  final String? _supplier_id;
  final String? _supplier_name;
  final String? _shop_name;
  final String? _supplier_phone_no;
  final String? _supplier_address;
  final String? _Advance_amount;
  final String? _Pending_amount;
  final String? _username;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get user_id {
    return _user_id;
  }
  
  String? get supplier_id {
    return _supplier_id;
  }
  
  String? get supplier_name {
    return _supplier_name;
  }
  
  String? get shop_name {
    return _shop_name;
  }
  
  String? get supplier_phone_no {
    return _supplier_phone_no;
  }
  
  String? get supplier_address {
    return _supplier_address;
  }
  
  String? get Advance_amount {
    return _Advance_amount;
  }
  
  String? get Pending_amount {
    return _Pending_amount;
  }
  
  String? get username {
    return _username;
  }
  
  const AcceptedSuppliers._internal({required this.id, user_id, supplier_id, supplier_name, shop_name, supplier_phone_no, supplier_address, Advance_amount, Pending_amount, username}): _user_id = user_id, _supplier_id = supplier_id, _supplier_name = supplier_name, _shop_name = shop_name, _supplier_phone_no = supplier_phone_no, _supplier_address = supplier_address, _Advance_amount = Advance_amount, _Pending_amount = Pending_amount, _username = username;
  
  factory AcceptedSuppliers({String? id, String? user_id, String? supplier_id, String? supplier_name, String? shop_name, String? supplier_phone_no, String? supplier_address, String? Advance_amount, String? Pending_amount, String? username}) {
    return AcceptedSuppliers._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      supplier_id: supplier_id,
      supplier_name: supplier_name,
      shop_name: shop_name,
      supplier_phone_no: supplier_phone_no,
      supplier_address: supplier_address,
      Advance_amount: Advance_amount,
      Pending_amount: Pending_amount,
      username: username);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AcceptedSuppliers &&
      id == other.id &&
      _user_id == other._user_id &&
      _supplier_id == other._supplier_id &&
      _supplier_name == other._supplier_name &&
      _shop_name == other._shop_name &&
      _supplier_phone_no == other._supplier_phone_no &&
      _supplier_address == other._supplier_address &&
      _Advance_amount == other._Advance_amount &&
      _Pending_amount == other._Pending_amount &&
      _username == other._username;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("AcceptedSuppliers {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("supplier_id=" + "$_supplier_id" + ", ");
    buffer.write("supplier_name=" + "$_supplier_name" + ", ");
    buffer.write("shop_name=" + "$_shop_name" + ", ");
    buffer.write("supplier_phone_no=" + "$_supplier_phone_no" + ", ");
    buffer.write("supplier_address=" + "$_supplier_address" + ", ");
    buffer.write("Advance_amount=" + "$_Advance_amount" + ", ");
    buffer.write("Pending_amount=" + "$_Pending_amount" + ", ");
    buffer.write("username=" + "$_username");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  AcceptedSuppliers copyWith({String? id, String? user_id, String? supplier_id, String? supplier_name, String? shop_name, String? supplier_phone_no, String? supplier_address, String? Advance_amount, String? Pending_amount, String? username}) {
    return AcceptedSuppliers(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      supplier_id: supplier_id ?? this.supplier_id,
      supplier_name: supplier_name ?? this.supplier_name,
      shop_name: shop_name ?? this.shop_name,
      supplier_phone_no: supplier_phone_no ?? this.supplier_phone_no,
      supplier_address: supplier_address ?? this.supplier_address,
      Advance_amount: Advance_amount ?? this.Advance_amount,
      Pending_amount: Pending_amount ?? this.Pending_amount,
      username: username ?? this.username);
  }
  
  AcceptedSuppliers.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _supplier_id = json['supplier_id'],
      _supplier_name = json['supplier_name'],
      _shop_name = json['shop_name'],
      _supplier_phone_no = json['supplier_phone_no'],
      _supplier_address = json['supplier_address'],
      _Advance_amount = json['Advance_amount'],
      _Pending_amount = json['Pending_amount'],
      _username = json['username'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'supplier_id': _supplier_id, 'supplier_name': _supplier_name, 'shop_name': _shop_name, 'supplier_phone_no': _supplier_phone_no, 'supplier_address': _supplier_address, 'Advance_amount': _Advance_amount, 'Pending_amount': _Pending_amount, 'username': _username
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField SUPPLIER_ID = QueryField(fieldName: "supplier_id");
  static final QueryField SUPPLIER_NAME = QueryField(fieldName: "supplier_name");
  static final QueryField SHOP_NAME = QueryField(fieldName: "shop_name");
  static final QueryField SUPPLIER_PHONE_NO = QueryField(fieldName: "supplier_phone_no");
  static final QueryField SUPPLIER_ADDRESS = QueryField(fieldName: "supplier_address");
  static final QueryField ADVANCE_AMOUNT = QueryField(fieldName: "Advance_amount");
  static final QueryField PENDING_AMOUNT = QueryField(fieldName: "Pending_amount");
  static final QueryField USERNAME = QueryField(fieldName: "username");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "AcceptedSuppliers";
    modelSchemaDefinition.pluralName = "AcceptedSuppliers";
    
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
      key: AcceptedSuppliers.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AcceptedSuppliers.SUPPLIER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AcceptedSuppliers.SUPPLIER_NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AcceptedSuppliers.SHOP_NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AcceptedSuppliers.SUPPLIER_PHONE_NO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AcceptedSuppliers.SUPPLIER_ADDRESS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AcceptedSuppliers.ADVANCE_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AcceptedSuppliers.PENDING_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AcceptedSuppliers.USERNAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _AcceptedSuppliersModelType extends ModelType<AcceptedSuppliers> {
  const _AcceptedSuppliersModelType();
  
  @override
  AcceptedSuppliers fromJson(Map<String, dynamic> jsonData) {
    return AcceptedSuppliers.fromJson(jsonData);
  }
}