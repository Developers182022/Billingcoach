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


/** This is an auto generated class representing the ProfitMonthlyRecord type in your schema. */
@immutable
class ProfitMonthlyRecord extends Model {
  static const classType = const _ProfitMonthlyRecordModelType();
  final String id;
  final String? _user_id;
  final String? _monthly_profit_id;
  final String? _monthly_profit;
  final String? _Expanse_amount;
  final String? _Earned_amount;
  final String? _month;
  final String? _year;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get user_id {
    return _user_id;
  }
  
  String? get monthly_profit_id {
    return _monthly_profit_id;
  }
  
  String? get monthly_profit {
    return _monthly_profit;
  }
  
  String? get Expanse_amount {
    return _Expanse_amount;
  }
  
  String? get Earned_amount {
    return _Earned_amount;
  }
  
  String? get month {
    return _month;
  }
  
  String? get year {
    return _year;
  }
  
  const ProfitMonthlyRecord._internal({required this.id, user_id, monthly_profit_id, monthly_profit, Expanse_amount, Earned_amount, month, year}): _user_id = user_id, _monthly_profit_id = monthly_profit_id, _monthly_profit = monthly_profit, _Expanse_amount = Expanse_amount, _Earned_amount = Earned_amount, _month = month, _year = year;
  
  factory ProfitMonthlyRecord({String? id, String? user_id, String? monthly_profit_id, String? monthly_profit, String? Expanse_amount, String? Earned_amount, String? month, String? year}) {
    return ProfitMonthlyRecord._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      monthly_profit_id: monthly_profit_id,
      monthly_profit: monthly_profit,
      Expanse_amount: Expanse_amount,
      Earned_amount: Earned_amount,
      month: month,
      year: year);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfitMonthlyRecord &&
      id == other.id &&
      _user_id == other._user_id &&
      _monthly_profit_id == other._monthly_profit_id &&
      _monthly_profit == other._monthly_profit &&
      _Expanse_amount == other._Expanse_amount &&
      _Earned_amount == other._Earned_amount &&
      _month == other._month &&
      _year == other._year;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ProfitMonthlyRecord {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("monthly_profit_id=" + "$_monthly_profit_id" + ", ");
    buffer.write("monthly_profit=" + "$_monthly_profit" + ", ");
    buffer.write("Expanse_amount=" + "$_Expanse_amount" + ", ");
    buffer.write("Earned_amount=" + "$_Earned_amount" + ", ");
    buffer.write("month=" + "$_month" + ", ");
    buffer.write("year=" + "$_year");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ProfitMonthlyRecord copyWith({String? id, String? user_id, String? monthly_profit_id, String? monthly_profit, String? Expanse_amount, String? Earned_amount, String? month, String? year}) {
    return ProfitMonthlyRecord(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      monthly_profit_id: monthly_profit_id ?? this.monthly_profit_id,
      monthly_profit: monthly_profit ?? this.monthly_profit,
      Expanse_amount: Expanse_amount ?? this.Expanse_amount,
      Earned_amount: Earned_amount ?? this.Earned_amount,
      month: month ?? this.month,
      year: year ?? this.year);
  }
  
  ProfitMonthlyRecord.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _monthly_profit_id = json['monthly_profit_id'],
      _monthly_profit = json['monthly_profit'],
      _Expanse_amount = json['Expanse_amount'],
      _Earned_amount = json['Earned_amount'],
      _month = json['month'],
      _year = json['year'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'monthly_profit_id': _monthly_profit_id, 'monthly_profit': _monthly_profit, 'Expanse_amount': _Expanse_amount, 'Earned_amount': _Earned_amount, 'month': _month, 'year': _year
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField MONTHLY_PROFIT_ID = QueryField(fieldName: "monthly_profit_id");
  static final QueryField MONTHLY_PROFIT = QueryField(fieldName: "monthly_profit");
  static final QueryField EXPANSE_AMOUNT = QueryField(fieldName: "Expanse_amount");
  static final QueryField EARNED_AMOUNT = QueryField(fieldName: "Earned_amount");
  static final QueryField MONTH = QueryField(fieldName: "month");
  static final QueryField YEAR = QueryField(fieldName: "year");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ProfitMonthlyRecord";
    modelSchemaDefinition.pluralName = "ProfitMonthlyRecords";
    
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
      key: ProfitMonthlyRecord.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ProfitMonthlyRecord.MONTHLY_PROFIT_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ProfitMonthlyRecord.MONTHLY_PROFIT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ProfitMonthlyRecord.EXPANSE_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ProfitMonthlyRecord.EARNED_AMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ProfitMonthlyRecord.MONTH,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: ProfitMonthlyRecord.YEAR,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _ProfitMonthlyRecordModelType extends ModelType<ProfitMonthlyRecord> {
  const _ProfitMonthlyRecordModelType();
  
  @override
  ProfitMonthlyRecord fromJson(Map<String, dynamic> jsonData) {
    return ProfitMonthlyRecord.fromJson(jsonData);
  }
}