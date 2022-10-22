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


/** This is an auto generated class representing the Privacypolicy type in your schema. */
@immutable
class Privacypolicy extends Model {
  static const classType = const _PrivacypolicyModelType();
  final String id;
  final String? _about_us;
  final String? _policy;
  final String? _terms_conditions;
  final String? _contact_no;
  final String? _contact_mail;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get about_us {
    return _about_us;
  }
  
  String? get policy {
    return _policy;
  }
  
  String? get terms_conditions {
    return _terms_conditions;
  }
  
  String? get contact_no {
    return _contact_no;
  }
  
  String? get contact_mail {
    return _contact_mail;
  }
  
  const Privacypolicy._internal({required this.id, about_us, policy, terms_conditions, contact_no, contact_mail}): _about_us = about_us, _policy = policy, _terms_conditions = terms_conditions, _contact_no = contact_no, _contact_mail = contact_mail;
  
  factory Privacypolicy({String? id, String? about_us, String? policy, String? terms_conditions, String? contact_no, String? contact_mail}) {
    return Privacypolicy._internal(
      id: id == null ? UUID.getUUID() : id,
      about_us: about_us,
      policy: policy,
      terms_conditions: terms_conditions,
      contact_no: contact_no,
      contact_mail: contact_mail);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Privacypolicy &&
      id == other.id &&
      _about_us == other._about_us &&
      _policy == other._policy &&
      _terms_conditions == other._terms_conditions &&
      _contact_no == other._contact_no &&
      _contact_mail == other._contact_mail;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Privacypolicy {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("about_us=" + "$_about_us" + ", ");
    buffer.write("policy=" + "$_policy" + ", ");
    buffer.write("terms_conditions=" + "$_terms_conditions" + ", ");
    buffer.write("contact_no=" + "$_contact_no" + ", ");
    buffer.write("contact_mail=" + "$_contact_mail");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Privacypolicy copyWith({String? id, String? about_us, String? policy, String? terms_conditions, String? contact_no, String? contact_mail}) {
    return Privacypolicy(
      id: id ?? this.id,
      about_us: about_us ?? this.about_us,
      policy: policy ?? this.policy,
      terms_conditions: terms_conditions ?? this.terms_conditions,
      contact_no: contact_no ?? this.contact_no,
      contact_mail: contact_mail ?? this.contact_mail);
  }
  
  Privacypolicy.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _about_us = json['about_us'],
      _policy = json['policy'],
      _terms_conditions = json['terms_conditions'],
      _contact_no = json['contact_no'],
      _contact_mail = json['contact_mail'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'about_us': _about_us, 'policy': _policy, 'terms_conditions': _terms_conditions, 'contact_no': _contact_no, 'contact_mail': _contact_mail
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField ABOUT_US = QueryField(fieldName: "about_us");
  static final QueryField POLICY = QueryField(fieldName: "policy");
  static final QueryField TERMS_CONDITIONS = QueryField(fieldName: "terms_conditions");
  static final QueryField CONTACT_NO = QueryField(fieldName: "contact_no");
  static final QueryField CONTACT_MAIL = QueryField(fieldName: "contact_mail");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Privacypolicy";
    modelSchemaDefinition.pluralName = "Privacypolicies";
    
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
      key: Privacypolicy.ABOUT_US,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Privacypolicy.POLICY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Privacypolicy.TERMS_CONDITIONS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Privacypolicy.CONTACT_NO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Privacypolicy.CONTACT_MAIL,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _PrivacypolicyModelType extends ModelType<Privacypolicy> {
  const _PrivacypolicyModelType();
  
  @override
  Privacypolicy fromJson(Map<String, dynamic> jsonData) {
    return Privacypolicy.fromJson(jsonData);
  }
}