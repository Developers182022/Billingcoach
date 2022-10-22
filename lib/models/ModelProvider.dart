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
import 'AcceptedSuppliers.dart';
import 'AppFeature.dart';
import 'AppOffer.dart';
import 'AppPlan.dart';
import 'AppSubscription.dart';
import 'Appfaqs.dart';
import 'ChatItems.dart';
import 'ChatMessage.dart';
import 'CompletedOrderItems.dart';
import 'CompletedOrders.dart';
import 'CustomerLis.dart';
import 'CustomerRecord.dart';
import 'DeletedOrder.dart';
import 'DeletedOrdersItems.dart';
import 'DeletedStockReport.dart';
import 'Expanse.dart';
import 'ExpanseRecord.dart';
import 'MenuItems.dart';
import 'Notifications.dart';
import 'PaymentRecords.dart';
import 'PendingOrderItems.dart';
import 'PendingOrders.dart';
import 'PendingPayments.dart';
import 'Privacypolicy.dart';
import 'Profit.dart';
import 'ProfitMonthlyRecord.dart';
import 'Queries.dart';
import 'ReceivedRequests.dart';
import 'RentedItems.dart';
import 'Rzorkey.dart';
import 'SentRequest.dart';
import 'StockList.dart';
import 'StockRecord.dart';
import 'Su.dart';
import 'Suppliers.dart';
import 'TempIte.dart';
import 'UserToken.dart';

export 'AcceptedSuppliers.dart';
export 'AppFeature.dart';
export 'AppOffer.dart';
export 'AppPlan.dart';
export 'AppSubscription.dart';
export 'Appfaqs.dart';
export 'ChatItems.dart';
export 'ChatMessage.dart';
export 'CompletedOrderItems.dart';
export 'CompletedOrders.dart';
export 'CustomerLis.dart';
export 'CustomerRecord.dart';
export 'DeletedOrder.dart';
export 'DeletedOrdersItems.dart';
export 'DeletedStockReport.dart';
export 'Expanse.dart';
export 'ExpanseRecord.dart';
export 'MenuItems.dart';
export 'Notifications.dart';
export 'PaymentRecords.dart';
export 'PendingOrderItems.dart';
export 'PendingOrders.dart';
export 'PendingPayments.dart';
export 'Privacypolicy.dart';
export 'Profit.dart';
export 'ProfitMonthlyRecord.dart';
export 'Queries.dart';
export 'ReceivedRequests.dart';
export 'RentedItems.dart';
export 'Rzorkey.dart';
export 'SentRequest.dart';
export 'StockList.dart';
export 'StockRecord.dart';
export 'Su.dart';
export 'Suppliers.dart';
export 'TempIte.dart';
export 'UserToken.dart';

class ModelProvider implements ModelProviderInterface {
  @override
  String version = "e8e90d064d68d5043c27dbe906b2e8bf";
  @override
  List<ModelSchema> modelSchemas = [AcceptedSuppliers.schema, AppFeature.schema, AppOffer.schema, AppPlan.schema, AppSubscription.schema, Appfaqs.schema, ChatItems.schema, ChatMessage.schema, CompletedOrderItems.schema, CompletedOrders.schema, CustomerLis.schema, CustomerRecord.schema, DeletedOrder.schema, DeletedOrdersItems.schema, DeletedStockReport.schema, Expanse.schema, ExpanseRecord.schema, MenuItems.schema, Notifications.schema, PaymentRecords.schema, PendingOrderItems.schema, PendingOrders.schema, PendingPayments.schema, Privacypolicy.schema, Profit.schema, ProfitMonthlyRecord.schema, Queries.schema, ReceivedRequests.schema, RentedItems.schema, Rzorkey.schema, SentRequest.schema, StockList.schema, StockRecord.schema, Su.schema, Suppliers.schema, TempIte.schema, UserToken.schema];
  static final ModelProvider _instance = ModelProvider();
  @override
  List<ModelSchema> customTypeSchemas = [];
  static ModelProvider get instance => _instance;
  
  ModelType getModelTypeByModelName(String modelName) {
    switch(modelName) {
      case "AcceptedSuppliers":
        return AcceptedSuppliers.classType;
      case "AppFeature":
        return AppFeature.classType;
      case "AppOffer":
        return AppOffer.classType;
      case "AppPlan":
        return AppPlan.classType;
      case "AppSubscription":
        return AppSubscription.classType;
      case "Appfaqs":
        return Appfaqs.classType;
      case "ChatItems":
        return ChatItems.classType;
      case "ChatMessage":
        return ChatMessage.classType;
      case "CompletedOrderItems":
        return CompletedOrderItems.classType;
      case "CompletedOrders":
        return CompletedOrders.classType;
      case "CustomerLis":
        return CustomerLis.classType;
      case "CustomerRecord":
        return CustomerRecord.classType;
      case "DeletedOrder":
        return DeletedOrder.classType;
      case "DeletedOrdersItems":
        return DeletedOrdersItems.classType;
      case "DeletedStockReport":
        return DeletedStockReport.classType;
      case "Expanse":
        return Expanse.classType;
      case "ExpanseRecord":
        return ExpanseRecord.classType;
      case "MenuItems":
        return MenuItems.classType;
      case "Notifications":
        return Notifications.classType;
      case "PaymentRecords":
        return PaymentRecords.classType;
      case "PendingOrderItems":
        return PendingOrderItems.classType;
      case "PendingOrders":
        return PendingOrders.classType;
      case "PendingPayments":
        return PendingPayments.classType;
      case "Privacypolicy":
        return Privacypolicy.classType;
      case "Profit":
        return Profit.classType;
      case "ProfitMonthlyRecord":
        return ProfitMonthlyRecord.classType;
      case "Queries":
        return Queries.classType;
      case "ReceivedRequests":
        return ReceivedRequests.classType;
      case "RentedItems":
        return RentedItems.classType;
      case "Rzorkey":
        return Rzorkey.classType;
      case "SentRequest":
        return SentRequest.classType;
      case "StockList":
        return StockList.classType;
      case "StockRecord":
        return StockRecord.classType;
      case "Su":
        return Su.classType;
      case "Suppliers":
        return Suppliers.classType;
      case "TempIte":
        return TempIte.classType;
      case "UserToken":
        return UserToken.classType;
      default:
        throw Exception("Failed to find model in model provider for model name: " + modelName);
    }
  }


}