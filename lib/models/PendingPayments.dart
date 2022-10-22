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


/** This is an auto generated class representing the PendingPayments type in your schema. */
@immutable
class PendingPayments extends Model {
  static const classType = const _PendingPaymentsModelType();
  final String id;
  final String? _user_id;
  final String? _client_id;
  final String? _record_id;
  final String? _party;
  final String? _party_name;
  final String? _Pending_amount;
  final String? _advance_amount;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get user_id {
    return _user_id;
  }
  
  String? get client_id {
    return _client_id;
  }
  
  String? get record_id {
    return _record_id;
  }
  
  String? get party {
    return _party;
  }
  
  String? get party_name {
    return _party_name;
  }
  
  String? get Pending_amount {
    return _Pending_amount;
  }
  
  String? get advance_amount {
    return _advance_amount;
  }
  
  const PendingPayments._internal({required this.id, user_id, client_id, record_id, party, party_name, Pending_amount, advance_amount}): _user_id = user_id, _client_id = client_id, _record_id = record_id, _party = party, _party_name = party_name, _Pending_amount = Pending_amount, _advance_amount = advance_amount;
  
  factory PendingPayments({String? id, String? user_id, String? client_id, String? record_id, String? party, String? party_name, String? Pending_amount, String? advance_amount}) {
    return PendingPayments._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      client_id: client_id,
      record_id: record_id,
      party: party,
      party_name: party_name,
      Pending_amount: Pending_amount,
      advance_amount: advance_amount);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PendingPayments &&
      id == other.id &&
      _user_id == other._user_id &&
      _client_id == other._client_id &&
      _record_id == other._record_id &&
      _party == other._party &&
      _party_name == other._party_name &&
      _Pending_amount == other._Pending_amount &&
      _advance_amount == other._advance_amount;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("PendingPayments {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("client_id=" + "$_client_id" + ", ");
    buffer.write("record_id=" + "$_record_id" + ", ");
    buffer.write("party=" + "$_party" + ", ");
    buffer.write("party_name=" + "$_party_name" + ", ");
    buffer.write("Pending_amount=" + "$_Pending_amount" + ", ");
    buffer.write("advance_amount=" + "$_advance_amount");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  PendingPayments copyWith({String? id, String? user_id, String? client_id, String? record_id, String? party, String? party_name, String? Pending_amount, String? advance_amount}) {
    return PendingPayments(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      client_id: client_id ?? this.client_id,
      record_id: record_id ?? this.record_id,
      party: party ?? this.party,
      party_name: party_name ?? this.party_name,
      Pending_amount: Pending_amount ?? this.Pending_amount,
      advance_amount: advance_amount ?? this.advance_amount);
  }
  
  PendingPayments.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _client_id = json['client_id'],
      _record_id = json['record_id'],
      _party = json['party'],
      _party_name = json['party_name'],
      _Pending_amount = json['Pending_amount'],
      _advance_amount = json['advance_amount'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'client_id': _client_id, 'record_id': _record_id, 'party': _party, 'party_name': _party_name, 'Pending_amount': _Pending_amount, 'advance_amount': _advance_amount
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField CLIENT_ID = QueryField(fieldName: "client_id");
  static final QueryField RECORD_ID = QueryField(fieldName: "record_id");
  static final QueryField PARTY = QueryField(fieldName: "party");
  static final QueryField PARTY_NAME = QueryField(fieldName: "party_name");
  static final QueryField PENDING_AMOUNT = QueryField(fieldName: "Pending_amount");
  static final QueryField ADVANCE_AMOUNT = QueryField(fieldName: "advance_amount");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "PendingPayments";
    modelSchemaDefinition.pluralName = "PendingPayments";
    
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
      key: PendingPayments.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PendingPayments.CLIENT_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PendingPayments.RECORD_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PendingPayments.PARTY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PendingPayments.PARTY_NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PendingPayments.PENDING_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: PendingPayments.ADVANCE_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _PendingPaymentsModelType extends ModelType<PendingPayments> {
  const _PendingPaymentsModelType();
  
  @override
  PendingPayments fromJson(Map<String, dynamic> jsonData) {
    return PendingPayments.fromJson(jsonData);
  }
}