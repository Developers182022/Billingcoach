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


/** This is an auto generated class representing the Appfaqs type in your schema. */
@immutable
class Appfaqs extends Model {
  static const classType = const _AppfaqsModelType();
  final String id;
  final String? _topic_id;
  final String? _faq_id;
  final String? _faq_question;
  final String? _faq_answer;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get topic_id {
    return _topic_id;
  }
  
  String? get faq_id {
    return _faq_id;
  }
  
  String? get faq_question {
    return _faq_question;
  }
  
  String? get faq_answer {
    return _faq_answer;
  }
  
  const Appfaqs._internal({required this.id, topic_id, faq_id, faq_question, faq_answer}): _topic_id = topic_id, _faq_id = faq_id, _faq_question = faq_question, _faq_answer = faq_answer;
  
  factory Appfaqs({String? id, String? topic_id, String? faq_id, String? faq_question, String? faq_answer}) {
    return Appfaqs._internal(
      id: id == null ? UUID.getUUID() : id,
      topic_id: topic_id,
      faq_id: faq_id,
      faq_question: faq_question,
      faq_answer: faq_answer);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Appfaqs &&
      id == other.id &&
      _topic_id == other._topic_id &&
      _faq_id == other._faq_id &&
      _faq_question == other._faq_question &&
      _faq_answer == other._faq_answer;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Appfaqs {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("topic_id=" + "$_topic_id" + ", ");
    buffer.write("faq_id=" + "$_faq_id" + ", ");
    buffer.write("faq_question=" + "$_faq_question" + ", ");
    buffer.write("faq_answer=" + "$_faq_answer");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Appfaqs copyWith({String? id, String? topic_id, String? faq_id, String? faq_question, String? faq_answer}) {
    return Appfaqs(
      id: id ?? this.id,
      topic_id: topic_id ?? this.topic_id,
      faq_id: faq_id ?? this.faq_id,
      faq_question: faq_question ?? this.faq_question,
      faq_answer: faq_answer ?? this.faq_answer);
  }
  
  Appfaqs.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _topic_id = json['topic_id'],
      _faq_id = json['faq_id'],
      _faq_question = json['faq_question'],
      _faq_answer = json['faq_answer'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'topic_id': _topic_id, 'faq_id': _faq_id, 'faq_question': _faq_question, 'faq_answer': _faq_answer
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField TOPIC_ID = QueryField(fieldName: "topic_id");
  static final QueryField FAQ_ID = QueryField(fieldName: "faq_id");
  static final QueryField FAQ_QUESTION = QueryField(fieldName: "faq_question");
  static final QueryField FAQ_ANSWER = QueryField(fieldName: "faq_answer");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Appfaqs";
    modelSchemaDefinition.pluralName = "Appfaqs";
    
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
      key: Appfaqs.TOPIC_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Appfaqs.FAQ_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Appfaqs.FAQ_QUESTION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Appfaqs.FAQ_ANSWER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _AppfaqsModelType extends ModelType<Appfaqs> {
  const _AppfaqsModelType();
  
  @override
  Appfaqs fromJson(Map<String, dynamic> jsonData) {
    return Appfaqs.fromJson(jsonData);
  }
}