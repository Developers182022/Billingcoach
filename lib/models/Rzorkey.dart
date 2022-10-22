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


/** This is an auto generated class representing the Rzorkey type in your schema. */
@immutable
class Rzorkey extends Model {
  static const classType = const _RzorkeyModelType();
  final String id;
  final String? _key;
  final String? _link;
  final String? _contact_no;
  final String? _contact_mail;
  final String? _billing_demo;
  final String? _stock_demo;
  final String? _service_demo;
  final String? _expanse_demo;
  final String? _pending_payment_demo;
  final String? _chat_demo;
  final String? _addsupplier_demo;
  final String? _customer_demo;
  final String? _sales_Demo;
  final String? _subscription;
  final String? _supplier_details_demo;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get key {
    return _key;
  }
  
  String? get link {
    return _link;
  }
  
  String? get contact_no {
    return _contact_no;
  }
  
  String? get contact_mail {
    return _contact_mail;
  }
  
  String? get billing_demo {
    return _billing_demo;
  }
  
  String? get stock_demo {
    return _stock_demo;
  }
  
  String? get service_demo {
    return _service_demo;
  }
  
  String? get expanse_demo {
    return _expanse_demo;
  }
  
  String? get pending_payment_demo {
    return _pending_payment_demo;
  }
  
  String? get chat_demo {
    return _chat_demo;
  }
  
  String? get addsupplier_demo {
    return _addsupplier_demo;
  }
  
  String? get customer_demo {
    return _customer_demo;
  }
  
  String? get sales_Demo {
    return _sales_Demo;
  }
  
  String? get subscription {
    return _subscription;
  }
  
  String? get supplier_details_demo {
    return _supplier_details_demo;
  }
  
  const Rzorkey._internal({required this.id, key, link, contact_no, contact_mail, billing_demo, stock_demo, service_demo, expanse_demo, pending_payment_demo, chat_demo, addsupplier_demo, customer_demo, sales_Demo, subscription, supplier_details_demo}): _key = key, _link = link, _contact_no = contact_no, _contact_mail = contact_mail, _billing_demo = billing_demo, _stock_demo = stock_demo, _service_demo = service_demo, _expanse_demo = expanse_demo, _pending_payment_demo = pending_payment_demo, _chat_demo = chat_demo, _addsupplier_demo = addsupplier_demo, _customer_demo = customer_demo, _sales_Demo = sales_Demo, _subscription = subscription, _supplier_details_demo = supplier_details_demo;
  
  factory Rzorkey({String? id, String? key, String? link, String? contact_no, String? contact_mail, String? billing_demo, String? stock_demo, String? service_demo, String? expanse_demo, String? pending_payment_demo, String? chat_demo, String? addsupplier_demo, String? customer_demo, String? sales_Demo, String? subscription, String? supplier_details_demo}) {
    return Rzorkey._internal(
      id: id == null ? UUID.getUUID() : id,
      key: key,
      link: link,
      contact_no: contact_no,
      contact_mail: contact_mail,
      billing_demo: billing_demo,
      stock_demo: stock_demo,
      service_demo: service_demo,
      expanse_demo: expanse_demo,
      pending_payment_demo: pending_payment_demo,
      chat_demo: chat_demo,
      addsupplier_demo: addsupplier_demo,
      customer_demo: customer_demo,
      sales_Demo: sales_Demo,
      subscription: subscription,
      supplier_details_demo: supplier_details_demo);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Rzorkey &&
      id == other.id &&
      _key == other._key &&
      _link == other._link &&
      _contact_no == other._contact_no &&
      _contact_mail == other._contact_mail &&
      _billing_demo == other._billing_demo &&
      _stock_demo == other._stock_demo &&
      _service_demo == other._service_demo &&
      _expanse_demo == other._expanse_demo &&
      _pending_payment_demo == other._pending_payment_demo &&
      _chat_demo == other._chat_demo &&
      _addsupplier_demo == other._addsupplier_demo &&
      _customer_demo == other._customer_demo &&
      _sales_Demo == other._sales_Demo &&
      _subscription == other._subscription &&
      _supplier_details_demo == other._supplier_details_demo;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Rzorkey {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("key=" + "$_key" + ", ");
    buffer.write("link=" + "$_link" + ", ");
    buffer.write("contact_no=" + "$_contact_no" + ", ");
    buffer.write("contact_mail=" + "$_contact_mail" + ", ");
    buffer.write("billing_demo=" + "$_billing_demo" + ", ");
    buffer.write("stock_demo=" + "$_stock_demo" + ", ");
    buffer.write("service_demo=" + "$_service_demo" + ", ");
    buffer.write("expanse_demo=" + "$_expanse_demo" + ", ");
    buffer.write("pending_payment_demo=" + "$_pending_payment_demo" + ", ");
    buffer.write("chat_demo=" + "$_chat_demo" + ", ");
    buffer.write("addsupplier_demo=" + "$_addsupplier_demo" + ", ");
    buffer.write("customer_demo=" + "$_customer_demo" + ", ");
    buffer.write("sales_Demo=" + "$_sales_Demo" + ", ");
    buffer.write("subscription=" + "$_subscription" + ", ");
    buffer.write("supplier_details_demo=" + "$_supplier_details_demo");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Rzorkey copyWith({String? id, String? key, String? link, String? contact_no, String? contact_mail, String? billing_demo, String? stock_demo, String? service_demo, String? expanse_demo, String? pending_payment_demo, String? chat_demo, String? addsupplier_demo, String? customer_demo, String? sales_Demo, String? subscription, String? supplier_details_demo}) {
    return Rzorkey(
      id: id ?? this.id,
      key: key ?? this.key,
      link: link ?? this.link,
      contact_no: contact_no ?? this.contact_no,
      contact_mail: contact_mail ?? this.contact_mail,
      billing_demo: billing_demo ?? this.billing_demo,
      stock_demo: stock_demo ?? this.stock_demo,
      service_demo: service_demo ?? this.service_demo,
      expanse_demo: expanse_demo ?? this.expanse_demo,
      pending_payment_demo: pending_payment_demo ?? this.pending_payment_demo,
      chat_demo: chat_demo ?? this.chat_demo,
      addsupplier_demo: addsupplier_demo ?? this.addsupplier_demo,
      customer_demo: customer_demo ?? this.customer_demo,
      sales_Demo: sales_Demo ?? this.sales_Demo,
      subscription: subscription ?? this.subscription,
      supplier_details_demo: supplier_details_demo ?? this.supplier_details_demo);
  }
  
  Rzorkey.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _key = json['key'],
      _link = json['link'],
      _contact_no = json['contact_no'],
      _contact_mail = json['contact_mail'],
      _billing_demo = json['billing_demo'],
      _stock_demo = json['stock_demo'],
      _service_demo = json['service_demo'],
      _expanse_demo = json['expanse_demo'],
      _pending_payment_demo = json['pending_payment_demo'],
      _chat_demo = json['chat_demo'],
      _addsupplier_demo = json['addsupplier_demo'],
      _customer_demo = json['customer_demo'],
      _sales_Demo = json['sales_Demo'],
      _subscription = json['subscription'],
      _supplier_details_demo = json['supplier_details_demo'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'key': _key, 'link': _link, 'contact_no': _contact_no, 'contact_mail': _contact_mail, 'billing_demo': _billing_demo, 'stock_demo': _stock_demo, 'service_demo': _service_demo, 'expanse_demo': _expanse_demo, 'pending_payment_demo': _pending_payment_demo, 'chat_demo': _chat_demo, 'addsupplier_demo': _addsupplier_demo, 'customer_demo': _customer_demo, 'sales_Demo': _sales_Demo, 'subscription': _subscription, 'supplier_details_demo': _supplier_details_demo
  };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField KEY = QueryField(fieldName: "key");
  static final QueryField LINK = QueryField(fieldName: "link");
  static final QueryField CONTACT_NO = QueryField(fieldName: "contact_no");
  static final QueryField CONTACT_MAIL = QueryField(fieldName: "contact_mail");
  static final QueryField BILLING_DEMO = QueryField(fieldName: "billing_demo");
  static final QueryField STOCK_DEMO = QueryField(fieldName: "stock_demo");
  static final QueryField SERVICE_DEMO = QueryField(fieldName: "service_demo");
  static final QueryField EXPANSE_DEMO = QueryField(fieldName: "expanse_demo");
  static final QueryField PENDING_PAYMENT_DEMO = QueryField(fieldName: "pending_payment_demo");
  static final QueryField CHAT_DEMO = QueryField(fieldName: "chat_demo");
  static final QueryField ADDSUPPLIER_DEMO = QueryField(fieldName: "addsupplier_demo");
  static final QueryField CUSTOMER_DEMO = QueryField(fieldName: "customer_demo");
  static final QueryField SALES_DEMO = QueryField(fieldName: "sales_Demo");
  static final QueryField SUBSCRIPTION = QueryField(fieldName: "subscription");
  static final QueryField SUPPLIER_DETAILS_DEMO = QueryField(fieldName: "supplier_details_demo");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Rzorkey";
    modelSchemaDefinition.pluralName = "Rzorkeys";
    
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
      key: Rzorkey.KEY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Rzorkey.LINK,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Rzorkey.CONTACT_NO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Rzorkey.CONTACT_MAIL,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Rzorkey.BILLING_DEMO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Rzorkey.STOCK_DEMO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Rzorkey.SERVICE_DEMO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Rzorkey.EXPANSE_DEMO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Rzorkey.PENDING_PAYMENT_DEMO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Rzorkey.CHAT_DEMO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Rzorkey.ADDSUPPLIER_DEMO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Rzorkey.CUSTOMER_DEMO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Rzorkey.SALES_DEMO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Rzorkey.SUBSCRIPTION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Rzorkey.SUPPLIER_DETAILS_DEMO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _RzorkeyModelType extends ModelType<Rzorkey> {
  const _RzorkeyModelType();
  
  @override
  Rzorkey fromJson(Map<String, dynamic> jsonData) {
    return Rzorkey.fromJson(jsonData);
  }
}