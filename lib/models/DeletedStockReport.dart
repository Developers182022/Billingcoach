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


/** This is an auto generated class representing the DeletedStockReport type in your schema. */
@immutable
class DeletedStockReport extends Model {
  static const classType = const _DeletedStockReportModelType();
  final String id;
  final String? _user_id;
  final String? _stock_id;
  final String? _stock_record_id;
  final String? _stock_name;
  final String? _stock_quantity;
  final String? _stock_investment;
  final String? _selling_price;
  final String? _date;
  final String? _time;
  final String? _untitledfield;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get user_id {
    return _user_id;
  }
  
  String? get stock_id {
    return _stock_id;
  }
  
  String? get stock_record_id {
    return _stock_record_id;
  }
  
  String? get stock_name {
    return _stock_name;
  }
  
  String? get stock_quantity {
    return _stock_quantity;
  }
  
  String? get stock_investment {
    return _stock_investment;
  }
  
  String? get selling_price {
    return _selling_price;
  }
  
  String? get date {
    return _date;
  }
  
  String? get time {
    return _time;
  }
  
  String? get untitledfield {
    return _untitledfield;
  }
  
  const DeletedStockReport._internal({required this.id, user_id, stock_id, stock_record_id, stock_name, stock_quantity, stock_investment, selling_price, date, time, untitledfield}): _user_id = user_id, _stock_id = stock_id, _stock_record_id = stock_record_id, _stock_name = stock_name, _stock_quantity = stock_quantity, _stock_investment = stock_investment, _selling_price = selling_price, _date = date, _time = time, _untitledfield = untitledfield;
  
  factory DeletedStockReport({String? id, String? user_id, String? stock_id, String? stock_record_id, String? stock_name, String? stock_quantity, String? stock_investment, String? selling_price, String? date, String? time, String? untitledfield}) {
    return DeletedStockReport._internal(
      id: id == null ? UUID.getUUID() : id,
      user_id: user_id,
      stock_id: stock_id,
      stock_record_id: stock_record_id,
      stock_name: stock_name,
      stock_quantity: stock_quantity,
      stock_investment: stock_investment,
      selling_price: selling_price,
      date: date,
      time: time,
      untitledfield: untitledfield);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeletedStockReport &&
      id == other.id &&
      _user_id == other._user_id &&
      _stock_id == other._stock_id &&
      _stock_record_id == other._stock_record_id &&
      _stock_name == other._stock_name &&
      _stock_quantity == other._stock_quantity &&
      _stock_investment == other._stock_investment &&
      _selling_price == other._selling_price &&
      _date == other._date &&
      _time == other._time &&
      _untitledfield == other._untitledfield;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("DeletedStockReport {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user_id=" + "$_user_id" + ", ");
    buffer.write("stock_id=" + "$_stock_id" + ", ");
    buffer.write("stock_record_id=" + "$_stock_record_id" + ", ");
    buffer.write("stock_name=" + "$_stock_name" + ", ");
    buffer.write("stock_quantity=" + "$_stock_quantity" + ", ");
    buffer.write("stock_investment=" + "$_stock_investment" + ", ");
    buffer.write("selling_price=" + "$_selling_price" + ", ");
    buffer.write("date=" + "$_date" + ", ");
    buffer.write("time=" + "$_time" + ", ");
    buffer.write("untitledfield=" + "$_untitledfield");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  DeletedStockReport copyWith({String? id, String? user_id, String? stock_id, String? stock_record_id, String? stock_name, String? stock_quantity, String? stock_investment, String? selling_price, String? date, String? time, String? untitledfield}) {
    return DeletedStockReport(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      stock_id: stock_id ?? this.stock_id,
      stock_record_id: stock_record_id ?? this.stock_record_id,
      stock_name: stock_name ?? this.stock_name,
      stock_quantity: stock_quantity ?? this.stock_quantity,
      stock_investment: stock_investment ?? this.stock_investment,
      selling_price: selling_price ?? this.selling_price,
      date: date ?? this.date,
      time: time ?? this.time,
      untitledfield: untitledfield ?? this.untitledfield);
  }
  
  DeletedStockReport.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user_id = json['user_id'],
      _stock_id = json['stock_id'],
      _stock_record_id = json['stock_record_id'],
      _stock_name = json['stock_name'],
      _stock_quantity = json['stock_quantity'],
      _stock_investment = json['stock_investment'],
      _selling_price = json['selling_price'],
      _date = json['date'],
      _time = json['time'],
      _untitledfield = json['untitledfield'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': _user_id, 'stock_id': _stock_id, 'stock_record_id': _stock_record_id, 'stock_name': _stock_name, 'stock_quantity': _stock_quantity, 'stock_investment': _stock_investment, 'selling_price': _selling_price, 'date': _date, 'time': _time, 'untitledfield': _untitledfield
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField USER_ID = QueryField(fieldName: "user_id");
  static final QueryField STOCK_ID = QueryField(fieldName: "stock_id");
  static final QueryField STOCK_RECORD_ID = QueryField(fieldName: "stock_record_id");
  static final QueryField STOCK_NAME = QueryField(fieldName: "stock_name");
  static final QueryField STOCK_QUANTITY = QueryField(fieldName: "stock_quantity");
  static final QueryField STOCK_INVESTMENT = QueryField(fieldName: "stock_investment");
  static final QueryField SELLING_PRICE = QueryField(fieldName: "selling_price");
  static final QueryField DATE = QueryField(fieldName: "date");
  static final QueryField TIME = QueryField(fieldName: "time");
  static final QueryField UNTITLEDFIELD = QueryField(fieldName: "untitledfield");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "DeletedStockReport";
    modelSchemaDefinition.pluralName = "DeletedStockReports";
    
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
      key: DeletedStockReport.USER_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: DeletedStockReport.STOCK_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: DeletedStockReport.STOCK_RECORD_ID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: DeletedStockReport.STOCK_NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: DeletedStockReport.STOCK_QUANTITY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: DeletedStockReport.STOCK_INVESTMENT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: DeletedStockReport.SELLING_PRICE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: DeletedStockReport.DATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: DeletedStockReport.TIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: DeletedStockReport.UNTITLEDFIELD,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _DeletedStockReportModelType extends ModelType<DeletedStockReport> {
  const _DeletedStockReportModelType();
  
  @override
  DeletedStockReport fromJson(Map<String, dynamic> jsonData) {
    return DeletedStockReport.fromJson(jsonData);
  }
}