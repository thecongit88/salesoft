import 'package:get/get.dart';
import 'package:sale_soft/api/provider/account_provider.dart';
import 'package:sale_soft/api/provider/news_provider.dart';
import 'package:sale_soft/api/repository/account_repository.dart';
import 'package:sale_soft/api/repository/news_repository.dart';
import 'package:sale_soft/main.dart';
import 'package:sale_soft/main_controller.dart';
import 'package:sale_soft/pages/account/admin_chi_tiet_thu_chi/admin_chi_tiet_thu_chi_list_controller.dart';
import 'package:sale_soft/pages/account/admin_chi_tiet_thu_chi/admin_chi_tiet_thu_chi_list_page.dart';
import 'package:sale_soft/pages/account/business_status/business_status_controller.dart';
import 'package:sale_soft/pages/account/business_status/business_status_page.dart';
import 'package:sale_soft/pages/account/customer_detail/customer_detail_controller.dart';
import 'package:sale_soft/pages/account/customer_detail/customer_detail_page.dart';
import 'package:sale_soft/pages/account/customer_list/customer_list_controller.dart';
import 'package:sale_soft/pages/account/customer_list/customer_list_page.dart';
import 'package:sale_soft/pages/account/detail_customer_debt/detail_customer_debt_controller.dart';
import 'package:sale_soft/pages/account/detail_customer_debt/detail_customer_debt_page.dart';
import 'package:sale_soft/pages/account/inventory_item/inventory_item_controller.dart';
import 'package:sale_soft/pages/account/inventory_item/inventory_item_page.dart';
import 'package:sale_soft/pages/account/inventory_item_detail/inventory_item_detail_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_detail/inventory_item_detail_page.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/choose_items/inventory_item_detail_quote_price_page.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/choose_items/inventory_item_quote_price_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/choose_items/inventory_item_quote_price_page.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/customer_info/price_info_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/customer_info/price_list_info_page.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/items_list/price_list_item_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/items_list/price_list_item_page.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/send_price_quote/create_price_list_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/send_price_quote/create_price_list_page.dart';
import 'package:sale_soft/pages/account/kiem_kho_page/kiem_kho_controller.dart';
import 'package:sale_soft/pages/account/kiem_kho_page/kiem_kho_page.dart';
import 'package:sale_soft/pages/account/monthly_report/monthly_report_controller.dart';
import 'package:sale_soft/pages/account/monthly_report/monthly_report_page.dart';
import 'package:sale_soft/pages/account/order_page/order_controller.dart';
import 'package:sale_soft/pages/account/order_page/order_page.dart';
import 'package:sale_soft/pages/account/order_sale_item/order_sale_item_controller.dart';
import 'package:sale_soft/pages/account/order_sale_item/order_sale_item_page.dart';
import 'package:sale_soft/pages/account/searchCustomerDebt/search_customer_debt_page.dart';
import 'package:sale_soft/pages/account/search_customer/customer_controller.dart';
import 'package:sale_soft/pages/account/search_customer/customer_page.dart';
import 'package:sale_soft/pages/account/searchCustomerDebt/search_customer_debt_controller.dart';
import 'package:sale_soft/pages/home/news_detail/news_detail_controller.dart';
import 'package:sale_soft/pages/home/news_detail/news_detail_page.dart';

enum ERouter {
  mainPage,
  newsDetailPage,
  monthlyReportPage,
  businessStatusPage,
  customerPage,
  customerDetailPage,
  customerDebtDetailPage,
  inventoryItemDetailPage,
  inventoryItemDetailQuotePricePage,
  customerList,
  inventoryItem,
  inventoryItemQuotePrice,
  priceInfoPage,
  priceProductItemsPage,
  createPriceListPage,
  debt,
  orderPage,
  kiemKhoPage,
  orderSalePage,
  adChiTietThuChiPage
}

extension ERouterExt on ERouter {
  String get name {
    switch (this) {
      case ERouter.mainPage:
        return "/main_page";
      case ERouter.newsDetailPage:
        return "/news_detail";
      case ERouter.monthlyReportPage:
        return "/monthly_report_page";
      case ERouter.businessStatusPage:
        return "/business_status_page";
      case ERouter.customerPage:
        return "/customer_page";
      case ERouter.orderSalePage:
        return "/order_sale_page";
      case ERouter.adChiTietThuChiPage:
        return "/ad_chi_tiet_thu_chi";
      case ERouter.customerDetailPage:
        return "/customer_detail_page";
      case ERouter.customerDebtDetailPage:
        return "/customer_debt_detail_page";
      case ERouter.inventoryItemDetailPage:
        return "/inventory_item_detail_page";
      case ERouter.inventoryItemDetailQuotePricePage:
        return "/inventory_item_detail_quote_price_page";
      case ERouter.customerList:
        return "/customer_list";
      case ERouter.inventoryItem:
        return "/inventory_item";
      case ERouter.inventoryItemQuotePrice:
        return "/inventory_item_quote_price";
      case ERouter.priceInfoPage:
        return "/price_info_page";
      case ERouter.priceProductItemsPage:
        return "/price_product_item_page";
      case ERouter.createPriceListPage:
        return "/create_price_list_page";
      case ERouter.debt:
        return "/debt";
      case ERouter.orderPage:
        return "/order_page";
      case ERouter.kiemKhoPage:
        return "/kiem_kho_page";

      default:
        return "/";
    }
  }
}

class RouterPage {
  static final routers = [
    GetPage(
        name: ERouter.mainPage.name,
        page: () => MainPage(),
        binding: MainPageBinding()),
    GetPage(
        name: ERouter.newsDetailPage.name,
        page: () => NewsDetailPage(),
        binding: NewsDetailPageBinding()),
    GetPage(
        name: ERouter.monthlyReportPage.name,
        page: () => MonthlyReportPage(),
        binding: MonthlyReportPageBinding()),
    GetPage(
        name: ERouter.businessStatusPage.name,
        page: () => BusinessStatusPage(),
        binding: BusinessStatusPageBinding()),
    GetPage(
        name: ERouter.customerPage.name,
        page: () => CustomersPage(),
        binding: CustomersPageBinding()),
    //fix code
    GetPage(
        name: ERouter.orderSalePage.name,
        page: () => OrderSaleItemPage(),
        binding: OrderSaleItemPageBinding()),
    GetPage(
        name: ERouter.adChiTietThuChiPage.name,
        page: () => AdminChiTietThuChiPage(),
        binding: AdminChiTietThuChiPageBinding()),
    GetPage(
        name: ERouter.customerDetailPage.name,
        page: () => CustomerDetailPage(),
        binding: CustomerDetailPageBinding()),
    GetPage(
        name: ERouter.customerDebtDetailPage.name,
        page: () => DetailCustomerDebtPage(),
        binding: CustomerDebtDetailPageBinding()),
    GetPage(
        name: ERouter.inventoryItemDetailPage.name,
        page: () => InventoryItemDetailPage(),
        binding: InventoryItemDetailPageBinding()),
    GetPage(
        name: ERouter.inventoryItemDetailQuotePricePage.name,
        page: () => InventoryItemDetailQuotePricePage(),
        binding: InventoryItemDetailPageBinding()),
    GetPage(
        name: ERouter.inventoryItemQuotePrice.name,
        page: () => InventroryItemQuotePricePage(),
        binding: InventroryItemQuotePricePageBinding()),
    GetPage(
        name: ERouter.priceInfoPage.name,
        page: () => PriceListInfoPage(),
        binding: PriceListInfoPageBinding()),
    GetPage(
        name: ERouter.priceProductItemsPage.name,
        page: () => PriceListItemPage(),
        binding: PriceListItemPageBinding()),
    GetPage(
        name: ERouter.createPriceListPage.name,
        page: () => CreatePriceListPage(),
        binding: CreatePriceListPageBinding()),
    GetPage(
        name: ERouter.customerList.name,
        page: () => CustomerListPage(),
        binding: CustomerListPageBinding()),
    GetPage(
        name: ERouter.inventoryItem.name,
        page: () => InventroryItemPage(),
        binding: InventoryItemsPageBinding()),
    GetPage(
        name: ERouter.debt.name,
        page: () => SearchCustomerDebtPage(),
        binding: SearchCustomerDebtPageBinding()),
    GetPage(
        name: ERouter.orderPage.name,
        page: () => OrderPage(),
        binding: OrderPageBinding()),
    GetPage(
        name: ERouter.kiemKhoPage.name,
        page: () => KiemKhoPage(),
        binding: KiemKhoPageBinding()),
  ];
}

class AdminChiTietThuChiPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminChiTietThuChiController());
  }
}

class MainPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<INewsProvider>(() => NewsProviderAPI());
    Get.lazyPut<INewsRepository>(() => NewsRepository(provider: Get.find()));
    Get.lazyPut<IAccountProvider>(() => AccountProviderAPI());
    Get.lazyPut<IAccountRepository>(
        () => AccountRepository(provider: Get.find()));
    Get.put(MainController());
  }
}

class NewsDetailPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NewsDetailController());
  }
}

class MonthlyReportPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MonthlyReportController());
  }
}

class BusinessStatusPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BusinessStatusController());
  }
}

class CustomersPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CustomersController());
  }
}

class OrderSaleItemPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OrderSaleItemController());
  }
}

class CustomerDetailPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CustomerDetailController());
  }
}

class CustomerDebtDetailPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailCustomerDebtPageController());
  }
}

class InventoryItemDetailPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InventoryItemDetailController());
  }
}

class SearchCustomerDebtPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SearchCustomerDebtPageController());
  }
}

class CustomerListPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CustomerListController());
  }
}

class InventoryItemsPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InventoryItemController());
  }
}

class OrderPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OrderController());
  }
}

class KiemKhoPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(KiemKhoController());
  }
}

class InventroryItemQuotePricePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InventoryItemQuotePriceController());
  }
}

class PriceListInfoPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PriceInfoController());
  }
}

class PriceListItemPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PriceListItemsController());
  }
}

class CreatePriceListPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CreatePriceListController());
  }
}



