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


/** This is an auto generated class representing the Suppliers type in your schema. */
@immutable
class Suppliers extends Model {
  static const classType = const _SuppliersModelType();
  final String id;
  final String? _supplier_id;
  final String? _shop_name;
  final String? _supplier_name;
  final String? _supplier_phone_no;
  final String? _shop_address;
  final String? _pincode;
  final String? _latitude_coordinate;
  final String? _longitude_coordinate;
  final String? _delivery_status;
  final String? _delivery_charges;
  final String? _username;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get supplier_id {
    return _supplier_id;
  }
  
  String? get shop_name {
    return _shop_name;
  }
  
  String? get supplier_name {
    return _supplier_name;
  }
  
  String? get supplier_phone_no {
    return _supplier_phone_no;
  }
  
  String? get shop_address {
    return _shop_address;
  }
  
  String? get pincode {
    return _pincode;
  }
  
  String? get latitude_coordinate {
    return _latitude_coordinate;
  }
  
  String? get longitude_coordinate {
    return _longitude_coordinate;
  }
  
  String? get delivery_status {
    return _delivery_status;
  }
  
  String? get delivery_charges {
    return _delivery_charges;
  }
  
  String? get username {
    return _username;
  }
  
  const Suppliers._internal({required this.id, supplier_id, shop_name, supplier_name, supplier_phone_no, shop_address, pincode, latitude_coordinate, longitude_coordinate, delivery_status, delivery_charges, username}): _supplier_id = supplier_id, _shop_name = shop_name, _supplier_name = supplier_name, _supplier_phone_no = supplier_phone_no, _shop_address = shop_address, _pincode = pincode, _latitude_coordinate = latitude_coordinate, _longitude_coordinate = longitude_coordinate, _delivery_status = delivery_status, _delivery_charges = delivery_charges, _username = username;
  
  factory Suppliers({String? id, String? supplier_id, String? shop_name, String? supplier_name, String? supplier_phone_no, String? shop_address, String? pincode, String? latitude_coordinate, String? longitude_coordinate, String? delivery_status, String? delivery_charges, String? username}) {
    return Suppliers._internal(
      id: id == null ? UUID.getUUID() : id,
      supplier_id: supplier_id,
      shop_name: shop_name,
      supplier_name: supplier_name,
      supplier_phone_no: supplier_phone_no,
      shop_address: shop_address,
      pincode: pincode,
      latitude_coordinate: latitude_coordinate,
      longitude_coordinate: longitude_coordinate,
      delivery_status: delivery_status,
      delivery_charges: delivery_charges,
      username: username);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Suppliers &&
      id == other.id &&
      _supplier_id == other._supplier_id &&
      _shop_name == other._shop_name &&
      _supplier_name == other._supplier_name &&
      _supplier_phone_no == other._supplier_phone_no &&
      _shop_address == other._shop_address &&
      _pincode == other._pincode &&
      _latitude_coordinate == other._latitude_coordinate &&
      _longitude_coordinate == other._longitude_coordinate &&
      _delivery_status == other._delivery_status &&
      _delivery_charges == other._delivery_charges &&
      _username == other._username;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Suppliers {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("supplier_id=" + "$_supplier_id" + ", ");
    buffer.write("shop_name=" + "$_shop_name" + ", ");
    buffer.write("supplier_name=" + "$_supplier_name" + ", ");
    buffer.write("supplier_phone_no=" + "$_supplier_phone_no" + ", ");
    buffer.write("shop_address=" + "$_shop_address" + ", ");
    buffer.write("pincode=" + "$_pincode" + ", ");
    buffer.write("latitude_coordinate=" + "$_latitude_coordinate" + ", ");
    buffer.write("longitude_coordinate=" + "$_longitude_coordinate" + ", ");
    buffer.write("delivery_status=" + "$_delivery_status" + ", ");
    buffer.write("delivery_charges=" + "$_delivery_charges" + ", ");
    buffer.write("username=" + "$_username");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Suppliers copyWith({String? id, String? supplier_id, String? shop_name, String? supplier_name, String? supplier_phone_no, String? shop_address, String? pincode, String? latitude_coordinate, String? longitude_coordinate, String? delivery_status, String? delivery_charges, String? username}) {
    return Suppliers(
      id: id ?? this.id,
      supplier_id: supplier_id ?? this.supplier_id,
      shop_name: shop_name ?? this.shop_name,
      supplier_name: supplier_name ?? this.supplier_name,
      supplier_phone_no: supplier_phone_no ?? this.supplier_phone_no,
      shop_address: shop_address ?? this.shop_address,
      pincode: pincode ?? this.pincode,
      latitude_coordinate: latitude_coordinate ?? this.latitude_coordinate,
      longitude_coordinate: longitude_coordinate ?? this.longitude_coordinate,
      delivery_status: delivery_status ?? this.delivery_status,
      delivery_charges: delivery_charges ?? this.delivery_charges,
      username: username ?? this.username);
  }
  
  Suppliers.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _supplier_id = json['supplier_id'],
      _shop_name = json['shop_name'],
      _supplier_name = json['supplier_name'],
      _supplier_phone_no = json['supplier_phone_no'],
      _shop_address = json['shop_address'],
      _pincode = json['pincode'],
      _latitude_coordinate = json['latitude_coordinate'],
      _longitude_coordinate = json['longitude_coordinate'],
      _delivery_status = json['delivery_status'],
      _delivery_charges = json['delivery_charges'],
      _username = json['username'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'supplier_id': _supplier_id, 'shop_name': _shop_name, 'supplier_name': _supplier_name, 'supplier_phone_no': _supplier_phone_no, 'shop_address': _shop_address, 'pincode': _pincode, 'latitude_coordinate': _latitude_coordinate, 'longitude_coordinate': _longitude_coordinate, 'delivery_status': _delivery_status, 'delivery_charges': _delivery_charges, 'username': _username
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField SUPPLIER_ID = QueryField(fieldName: "supplier_id");
  static final QueryField SHOP_NAME = QueryField(fieldName: "shop_name");
  static final QueryField SUPPLIER_NAME = QueryField(fieldName: "supplier_name");
  static final QueryField SUPPLIER_PHONE_NO = QueryField(fieldName: "supplier_phone_no");
  static final QueryField SHOP_ADDRESS = QueryField(fieldName: "shop_address");
  static final QueryField PINCODE = QueryField(fieldName: "pincode");
  static final QueryField LATITUDE_COORDINATE = QueryField(fieldName: "latitude_coordinate");
  static final QueryField LONGITUDE_COORDINATE = QueryField(fieldName: "longitude_coordinate");
  static final QueryField DELIVERY_STATUS = QueryField(fieldName: "delivery_status");
  static final QueryField DELIVERY_CHARGES = QueryField(fieldName: "delivery_charges");
  static final QueryField USERNAME = QueryField(fieldName: "username");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Suppliers";
    modelSchemaDefinition.pluralName = "Suppliers";
    
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
      key: Suppliers.SUPPLIER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Suppliers.SHOP_NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Suppliers.SUPPLIER_NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Suppliers.SUPPLIER_PHONE_NO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Suppliers.SHOP_ADDRESS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Suppliers.PINCODE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Suppliers.LATITUDE_COORDINATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Suppliers.LONGITUDE_COORDINATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Suppliers.DELIVERY_STATUS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Suppliers.DELIVERY_CHARGES,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Suppliers.USERNAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _SuppliersModelType extends ModelType<Suppliers> {
  const _SuppliersModelType();
  
  @override
  Suppliers fromJson(Map<String, dynamic> jsonData) {
    return Suppliers.fromJson(jsonData);
  }
}