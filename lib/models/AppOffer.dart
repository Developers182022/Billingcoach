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


/** This is an auto generated class representing the AppOffer type in your schema. */
@immutable
class AppOffer extends Model {
  static const classType = const _AppOfferModelType();
  final String id;
  final String? _offer_id;
  final String? _offer_description;
  final String? _offer_discount;
  final String? _offer_plan;
  final String? _offer_price;
  final String? _offer;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get offer_id {
    return _offer_id;
  }
  
  String? get offer_description {
    return _offer_description;
  }
  
  String? get offer_discount {
    return _offer_discount;
  }
  
  String? get offer_plan {
    return _offer_plan;
  }
  
  String? get offer_price {
    return _offer_price;
  }
  
  String? get offer {
    return _offer;
  }
  
  const AppOffer._internal({required this.id, offer_id, offer_description, offer_discount, offer_plan, offer_price, offer}): _offer_id = offer_id, _offer_description = offer_description, _offer_discount = offer_discount, _offer_plan = offer_plan, _offer_price = offer_price, _offer = offer;
  
  factory AppOffer({String? id, String? offer_id, String? offer_description, String? offer_discount, String? offer_plan, String? offer_price, String? offer}) {
    return AppOffer._internal(
      id: id == null ? UUID.getUUID() : id,
      offer_id: offer_id,
      offer_description: offer_description,
      offer_discount: offer_discount,
      offer_plan: offer_plan,
      offer_price: offer_price,
      offer: offer);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppOffer &&
      id == other.id &&
      _offer_id == other._offer_id &&
      _offer_description == other._offer_description &&
      _offer_discount == other._offer_discount &&
      _offer_plan == other._offer_plan &&
      _offer_price == other._offer_price &&
      _offer == other._offer;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("AppOffer {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("offer_id=" + "$_offer_id" + ", ");
    buffer.write("offer_description=" + "$_offer_description" + ", ");
    buffer.write("offer_discount=" + "$_offer_discount" + ", ");
    buffer.write("offer_plan=" + "$_offer_plan" + ", ");
    buffer.write("offer_price=" + "$_offer_price" + ", ");
    buffer.write("offer=" + "$_offer");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  AppOffer copyWith({String? id, String? offer_id, String? offer_description, String? offer_discount, String? offer_plan, String? offer_price, String? offer}) {
    return AppOffer(
      id: id ?? this.id,
      offer_id: offer_id ?? this.offer_id,
      offer_description: offer_description ?? this.offer_description,
      offer_discount: offer_discount ?? this.offer_discount,
      offer_plan: offer_plan ?? this.offer_plan,
      offer_price: offer_price ?? this.offer_price,
      offer: offer ?? this.offer);
  }
  
  AppOffer.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _offer_id = json['offer_id'],
      _offer_description = json['offer_description'],
      _offer_discount = json['offer_discount'],
      _offer_plan = json['offer_plan'],
      _offer_price = json['offer_price'],
      _offer = json['offer'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'offer_id': _offer_id, 'offer_description': _offer_description, 'offer_discount': _offer_discount, 'offer_plan': _offer_plan, 'offer_price': _offer_price, 'offer': _offer
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField OFFER_ID = QueryField(fieldName: "offer_id");
  static final QueryField OFFER_DESCRIPTION = QueryField(fieldName: "offer_description");
  static final QueryField OFFER_DISCOUNT = QueryField(fieldName: "offer_discount");
  static final QueryField OFFER_PLAN = QueryField(fieldName: "offer_plan");
  static final QueryField OFFER_PRICE = QueryField(fieldName: "offer_price");
  static final QueryField OFFER = QueryField(fieldName: "offer");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "AppOffer";
    modelSchemaDefinition.pluralName = "AppOffers";
    
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
      key: AppOffer.OFFER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppOffer.OFFER_DESCRIPTION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppOffer.OFFER_DISCOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppOffer.OFFER_PLAN,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppOffer.OFFER_PRICE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppOffer.OFFER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _AppOfferModelType extends ModelType<AppOffer> {
  const _AppOfferModelType();
  
  @override
  AppOffer fromJson(Map<String, dynamic> jsonData) {
    return AppOffer.fromJson(jsonData);
  }
}