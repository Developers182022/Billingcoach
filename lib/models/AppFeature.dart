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


/** This is an auto generated class representing the AppFeature type in your schema. */
@immutable
class AppFeature extends Model {
  static const classType = const _AppFeatureModelType();
  final String id;
  final String? _feature_id;
  final String? _feature_name;
  final String? _feature_description;
  final String? _feature_icon;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get feature_id {
    return _feature_id;
  }
  
  String? get feature_name {
    return _feature_name;
  }
  
  String? get feature_description {
    return _feature_description;
  }
  
  String? get feature_icon {
    return _feature_icon;
  }
  
  const AppFeature._internal({required this.id, feature_id, feature_name, feature_description, feature_icon}): _feature_id = feature_id, _feature_name = feature_name, _feature_description = feature_description, _feature_icon = feature_icon;
  
  factory AppFeature({String? id, String? feature_id, String? feature_name, String? feature_description, String? feature_icon}) {
    return AppFeature._internal(
      id: id == null ? UUID.getUUID() : id,
      feature_id: feature_id,
      feature_name: feature_name,
      feature_description: feature_description,
      feature_icon: feature_icon);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppFeature &&
      id == other.id &&
      _feature_id == other._feature_id &&
      _feature_name == other._feature_name &&
      _feature_description == other._feature_description &&
      _feature_icon == other._feature_icon;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("AppFeature {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("feature_id=" + "$_feature_id" + ", ");
    buffer.write("feature_name=" + "$_feature_name" + ", ");
    buffer.write("feature_description=" + "$_feature_description" + ", ");
    buffer.write("feature_icon=" + "$_feature_icon");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  AppFeature copyWith({String? id, String? feature_id, String? feature_name, String? feature_description, String? feature_icon}) {
    return AppFeature(
      id: id ?? this.id,
      feature_id: feature_id ?? this.feature_id,
      feature_name: feature_name ?? this.feature_name,
      feature_description: feature_description ?? this.feature_description,
      feature_icon: feature_icon ?? this.feature_icon);
  }
  
  AppFeature.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _feature_id = json['feature_id'],
      _feature_name = json['feature_name'],
      _feature_description = json['feature_description'],
      _feature_icon = json['feature_icon'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'feature_id': _feature_id, 'feature_name': _feature_name, 'feature_description': _feature_description, 'feature_icon': _feature_icon
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField FEATURE_ID = QueryField(fieldName: "feature_id");
  static final QueryField FEATURE_NAME = QueryField(fieldName: "feature_name");
  static final QueryField FEATURE_DESCRIPTION = QueryField(fieldName: "feature_description");
  static final QueryField FEATURE_ICON = QueryField(fieldName: "feature_icon");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "AppFeature";
    modelSchemaDefinition.pluralName = "AppFeatures";
    
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
      key: AppFeature.FEATURE_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppFeature.FEATURE_NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppFeature.FEATURE_DESCRIPTION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: AppFeature.FEATURE_ICON,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _AppFeatureModelType extends ModelType<AppFeature> {
  const _AppFeatureModelType();
  
  @override
  AppFeature fromJson(Map<String, dynamic> jsonData) {
    return AppFeature.fromJson(jsonData);
  }
}