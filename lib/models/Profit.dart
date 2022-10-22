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


/** This is an auto generated class representing the Profit type in your schema. */
@immutable
class Profit extends Model {
  static const classType = const _ProfitModelType();
  final String id;
  final String? _user_i;
  final String? _profit_id;
  final String? _profit;
  final String? _expanse;
  final String? _earned;
  final String? _date;
  final String? _month;
  final String? _year;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get user_i {
    return _user_i;
  }
  
  String? get profit_id {
    return _profit_id;
  }
  
  String? get profit {
    return _profit;
  }
  
  String? get expanse {
    return _expanse;
  }
  
  String? get earned {
    return _earned;
  }
  
  String? get date {
    return _date;
  }
  
  String? get month {
    return _month;
  }
  
  String? get year {
    return _year;
  }
  
  const Profit._internal({required this.id, user_i, profit_id, profit, expanse, earned, date, month, year}): _user_i = user_i, _profit_id = profit_id, _profit = profit, _expanse = expanse, _earned = earned, _date = date, _month = month, _year = year;
  
  factory Profit({String? id, String? user_i, String? profit_id, String? profit, String? expanse, String? earned, String? date, String? month, String? year}) {
    return Profit._internal(
      id: id == null ? UUID.getUUID() : id,
      user_i: user_i,
      profit_id: profit_id,
      profit: profit,
      expanse: expanse,
      earned: earned,
      date: date,
      month: month,
      year: year);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Profit &&
      id == other.id &&
      _user_i == other._user_i &&
      _profit_id == other._profit_id &&
      _profit == other._profit &&
      _expanse == other._expanse &&
      _earned == other._earned &&
      _date == other._date &&
      _month == other._month &&
      _year == other._year;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Profit {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_i=" + "$_user_i" + ", ");
    buffer.write("profit_id=" + "$_profit_id" + ", ");
    buffer.write("profit=" + "$_profit" + ", ");
    buffer.write("expanse=" + "$_expanse" + ", ");
    buffer.write("earned=" + "$_earned" + ", ");
    buffer.write("date=" + "$_date" + ", ");
    buffer.write("month=" + "$_month" + ", ");
    buffer.write("year=" + "$_year");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Profit copyWith({String? id, String? user_i, String? profit_id, String? profit, String? expanse, String? earned, String? date, String? month, String? year}) {
    return Profit(
      id: id ?? this.id,
      user_i: user_i ?? this.user_i,
      profit_id: profit_id ?? this.profit_id,
      profit: profit ?? this.profit,
      expanse: expanse ?? this.expanse,
      earned: earned ?? this.earned,
      date: date ?? this.date,
      month: month ?? this.month,
      year: year ?? this.year);
  }
  
  Profit.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_i = json['user_i'],
      _profit_id = json['profit_id'],
      _profit = json['profit'],
      _expanse = json['expanse'],
      _earned = json['earned'],
      _date = json['date'],
      _month = json['month'],
      _year = json['year'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_i': _user_i, 'profit_id': _profit_id, 'profit': _profit, 'expanse': _expanse, 'earned': _earned, 'date': _date, 'month': _month, 'year': _year
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_I = QueryField(fieldName: "user_i");
  static final QueryField PROFIT_ID = QueryField(fieldName: "profit_id");
  static final QueryField PROFIT = QueryField(fieldName: "profit");
  static final QueryField EXPANSE = QueryField(fieldName: "expanse");
  static final QueryField EARNED = QueryField(fieldName: "earned");
  static final QueryField DATE = QueryField(fieldName: "date");
  static final QueryField MONTH = QueryField(fieldName: "month");
  static final QueryField YEAR = QueryField(fieldName: "year");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Profit";
    modelSchemaDefinition.pluralName = "Profits";
    
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
      key: Profit.USER_I,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Profit.PROFIT_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Profit.PROFIT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Profit.EXPANSE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Profit.EARNED,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Profit.DATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Profit.MONTH,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Profit.YEAR,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _ProfitModelType extends ModelType<Profit> {
  const _ProfitModelType();
  
  @override
  Profit fromJson(Map<String, dynamic> jsonData) {
    return Profit.fromJson(jsonData);
  }
}