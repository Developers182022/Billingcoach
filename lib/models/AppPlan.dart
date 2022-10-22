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


/** This is an auto generated class representing the AppPlan type in your schema. */
@immutable
class AppPlan extends Model {
  static const classType = const _AppPlanModelType();
  final String id;
  final String? _plan_id;
  final String? _plan;
  final String? _plan_charges;
  final String? _plan_offer_charges;
  final String? _plan_validity;
  final String? _plan_validfor;
  final String? _plan_offer;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get plan_id {
    return _plan_id;
  }
  
  String? get plan {
    return _plan;
  }
  
  String? get plan_charges {
    return _plan_charges;
  }
  
  String? get plan_offer_charges {
    return _plan_offer_charges;
  }
  
  String? get plan_validity {
    return _plan_validity;
  }
  
  String? get plan_validfor {
    return _plan_validfor;
  }
  
  String? get plan_offer {
    return _plan_offer;
  }
  
  const AppPlan._internal({required this.id, plan_id, plan, plan_charges, plan_offer_charges, plan_validity, plan_validfor, plan_offer}): _plan_id = plan_id, _plan = plan, _plan_charges = plan_charges, _plan_offer_charges = plan_offer_charges, _plan_validity = plan_validity, _plan_validfor = plan_validfor, _plan_offer = plan_offer;
  
  factory AppPlan({String? id, String? plan_id, String? plan, String? plan_charges, String? plan_offer_charges, String? plan_validity, String? plan_validfor, String? plan_offer}) {
    return AppPlan._internal(
      id: id == null ? UUID.getUUID() : id,
      plan_id: plan_id,
      plan: plan,
      plan_charges: plan_charges,
      plan_offer_charges: plan_offer_charges,
      plan_validity: plan_validity,
      plan_validfor: plan_validfor,
      plan_offer: plan_offer);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppPlan &&
      id == other.id &&
      _plan_id == other._plan_id &&
      _plan == other._plan &&
      _plan_charges == other._plan_charges &&
      _plan_offer_charges == other._plan_offer_charges &&
      _plan_validity == other._plan_validity &&
      _plan_validfor == other._plan_validfor &&
      _plan_offer == other._plan_offer;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("AppPlan {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("plan_id=" + "$_plan_id" + ", ");
    buffer.write("plan=" + "$_plan" + ", ");
    buffer.write("plan_charges=" + "$_plan_charges" + ", ");
    buffer.write("plan_offer_charges=" + "$_plan_offer_charges" + ", ");
    buffer.write("plan_validity=" + "$_plan_validity" + ", ");
    buffer.write("plan_validfor=" + "$_plan_validfor" + ", ");
    buffer.write("plan_offer=" + "$_plan_offer");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  AppPlan copyWith({String? id, String? plan_id, String? plan, String? plan_charges, String? plan_offer_charges, String? plan_validity, String? plan_validfor, String? plan_offer}) {
    return AppPlan(
      id: id ?? this.id,
      plan_id: plan_id ?? this.plan_id,
      plan: plan ?? this.plan,
      plan_charges: plan_charges ?? this.plan_charges,
      plan_offer_charges: plan_offer_charges ?? this.plan_offer_charges,
      plan_validity: plan_validity ?? this.plan_validity,
      plan_validfor: plan_validfor ?? this.plan_validfor,
      plan_offer: plan_offer ?? this.plan_offer);
  }
  
  AppPlan.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _plan_id = json['plan_id'],
      _plan = json['plan'],
      _plan_charges = json['plan_charges'],
      _plan_offer_charges = json['plan_offer_charges'],
      _plan_validity = json['plan_validity'],
      _plan_validfor = json['plan_validfor'],
      _plan_offer = json['plan_offer'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'plan_id': _plan_id, 'plan': _plan, 'plan_charges': _plan_charges, 'plan_offer_charges': _plan_offer_charges, 'plan_validity': _plan_validity, 'plan_validfor': _plan_validfor, 'plan_offer': _plan_offer
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField PLAN_ID = QueryField(fieldName: "plan_id");
  static final QueryField PLAN = QueryField(fieldName: "plan");
  static final QueryField PLAN_CHARGES = QueryField(fieldName: "plan_charges");
  static final QueryField PLAN_OFFER_CHARGES = QueryField(fieldName: "plan_offer_charges");
  static final QueryField PLAN_VALIDITY = QueryField(fieldName: "plan_validity");
  static final QueryField PLAN_VALIDFOR = QueryField(fieldName: "plan_validfor");
  static final QueryField PLAN_OFFER = QueryField(fieldName: "plan_offer");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "AppPlan";
    modelSchemaDefinition.pluralName = "AppPlans";
    
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
      key: AppPlan.PLAN_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppPlan.PLAN,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppPlan.PLAN_CHARGES,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppPlan.PLAN_OFFER_CHARGES,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppPlan.PLAN_VALIDITY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppPlan.PLAN_VALIDFOR,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppPlan.PLAN_OFFER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _AppPlanModelType extends ModelType<AppPlan> {
  const _AppPlanModelType();
  
  @override
  AppPlan fromJson(Map<String, dynamic> jsonData) {
    return AppPlan.fromJson(jsonData);
  }
}