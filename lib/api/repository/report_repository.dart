import 'dart:convert';

import 'package:sale_soft/api/provider/report_provider.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/model/base_model.dart';
import 'package:sale_soft/model/cashbook_model.dart';
import 'package:sale_soft/model/castflow_model.dart';
import 'package:sale_soft/model/customer_debt_model.dart';
import 'package:sale_soft/model/customer_detail_model.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/model/get_list_customer_param.dart';
import 'package:sale_soft/model/inventory_item_category_model.dart';
import 'package:sale_soft/model/inventory_item_detail_model.dart';
import 'package:sale_soft/model/inventory_item_model.dart';
import 'package:sale_soft/model/inventory_product_model.dart';
import 'package:sale_soft/model/invoice_model.dart';
import 'package:sale_soft/model/order_detail_model.dart';
import 'package:sale_soft/model/order_model.dart';
import 'package:sale_soft/model/params/get_inventory_items_param.dart';
import 'package:sale_soft/model/params/kiem_kho_param.dart';
import 'package:sale_soft/model/params/revenue_param.dart';
import 'package:sale_soft/model/plan.dart';
import 'package:sale_soft/model/price_list_object.dart';
import 'package:sale_soft/model/price_list_option.dart';
import 'package:sale_soft/model/product_info_model.dart';
import 'package:sale_soft/model/represent_model.dart';
import 'package:sale_soft/model/revenue_model.dart';
import 'package:sale_soft/model/staff_revenue_model.dart';
import 'package:sale_soft/model/store.dart';
import 'package:sale_soft/model/topsale_model.dart';
import 'package:sale_soft/model/warehouse.dart';

abstract class IReportRepository {
  /// Báo cáo thu chi
  Future<List<CashBookModel>?> fetchCashbook(RevenueParam param);
  Future<List<CashFlowModel>?> fetchCashflow(RevenueParam param);

  /// Báo cáo doanh thu
  Future<List<RevenueModel>?> revenue(RevenueParam param);

  /// Báo cáo doanh số nhân viên
  Future<StaffRevenueModel?> fetchStaffRevenue();

  /// Ds Store
  Future<List<StoreModel>?> getStores();

  /// Ds KH
  Future<List<CustomerModel>?> getListCustomer(GetListCustomerParam param);

  /// Ds KH CÔNG NỢ TRA CỨU
  Future<List<CustomerDebtModel>?> getListDebtCustomer(GetListCustomerParam param);

  /// Ds ORDERS
  Future<List<OrderModel>?> getListOrders(GetListCustomerParam param);

  /// Detail Customer
  Future<List<CustomerDetailModel>?> getDetailCustomer(String customerCode);

  /// Detail Product
  Future<InventoryItemDetailModel?> getDetailInventoryItem({required String productCode});

  /// Ds chứng từ
  Future<List<InvoiceModel>?> getCustomerInvoice(String customerCode);

  /// Lấy top5 giao dịch
  Future<List<TopsaleModel>?> getTopSale(String customerCode, int type);

  /// Lấy ds hàng hóa
  Future<List<InventroyItemModel>?> getListInventoryItems(
      GetInventoryItemsParam param);

  /// Lấy ds nhóm hàng hóa
  Future<List<InventoryItemCategoryModel>?> getInventoryItemCategory(
      String keyword);

  /// Lấy ds các kế hoạch theo kho
  Future<List<PlanModel>?> getListPlansByKho(
      String maKho);

  /// Lấy ds các sản phẩm theo kế hoạch
  Future<List<InventoryProductModel>?> getListProductsByPlan(String inventoryCode, String planCode);

  /// Lấy ds các kho
  Future<List<WareHouseModel>?> getListWarehouse();

  /// Lấy chi tiết hóa đơn
  Future<List<OrderDetailModel>?> getOrderDetail(String code);

  /// Tạo kiểm kho
  Future<String?> createKiemKho(KiemKhoParam kiemKhoParam);

  /// Lấy chi tiết sản phẩm trong kho
  Future<List<ProductInfoModel>?> getProductDetailInKho(String code);

  ///xác nhận đơn hàng
  Future<String?> confirmOrder(String orderCode);


  ///API eco3d

  ///danh sách xưng danh
  Future<List<PriceListOption>?> getListXungDanh();
  Future<List<PriceListOption>?> getListDaiLy();
  Future<List<PriceListOption>?> getListPhuongThucVanChuyen();
  Future<List<PriceListOption>?> getListThoiGianGiaoHang();
  Future<List<PriceListOption>?> getListDieuKienThanhToan();
  Future<String?> getMessageBaoGia(PriceListObject param);
  Future<String?> sendBaoGia(PriceListObject param);
  Future<List<RepresentModel>?> getNguoiDaiDien(String customerCode, String keyword);
}

class ReportRepository implements IReportRepository {
  final IReportProvider provider;

  ReportRepository({
    required this.provider,
  });

  @override
  Future<List<RevenueModel>?> revenue(RevenueParam param) async {
    final response = provider.revenue(param);

    return response.then<List<RevenueModel>?>((value) {
      if (value != null) {
        return Future<List<RevenueModel>>.value(
            RevenueModel.listFromJson(value));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  @override
  Future<StaffRevenueModel?> fetchStaffRevenue() {
    final response = provider.fetchStaffRevenue();

    return response.then<StaffRevenueModel?>((value) {
      if (value != null) {
        final items = StaffRevenueModel.listFromJson(value);
        return Future<StaffRevenueModel>.value(
            items.isNotEmpty ? items.first : null);
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  @override
  Future<List<StoreModel>?> getStores() async {
    final response = provider.getStores();

    return response.then<List<StoreModel>?>((value) {
      if (value != null) {
        final stores = BaseModel.listFromJson<StoreModel>(
            value, (dataMap) => StoreModel.fromMap(dataMap));

        /// Save to cache
        SharedPreferencesCommon.saveStores(stores);
        return Future<List<StoreModel>>.value();
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  @override
  Future<List<CashBookModel>?> fetchCashbook(RevenueParam param) async {
    final response = provider.fetchCastbook(param);

    return response.then<List<CashBookModel>?>((value) {
      if (value != null) {
        return Future<List<CashBookModel>>.value(
            BaseModel.listFromJson<CashBookModel>(
                value, (dataMap) => CashBookModel.fromMap(dataMap)));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  @override
  Future<List<CashFlowModel>?> fetchCashflow(RevenueParam param) async {
    final response = provider.fetchCashflow(param);

    return response.then<List<CashFlowModel>?>((value) {
      if (value != null) {
        return Future<List<CashFlowModel>>.value(
            CashFlowModel.listFromJson(value));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      print("error");
      print(onError);
      return Future.value(null);
    });
  }

  @override
  Future<List<CustomerModel>?> getListCustomer(GetListCustomerParam param) {
    final response = provider.getListCustomer(param);

    return response.then<List<CustomerModel>?>((value) {
      if (value != null) {
        return Future<List<CustomerModel>>.value(
            BaseModel.listFromJson<CustomerModel>(
                value, (dataMap) => CustomerModel.fromMap(dataMap)));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  @override
  Future<List<CustomerDebtModel>?> getListDebtCustomer(GetListCustomerParam param) {
    final response = provider.getListDebtCustomer(param);

    return response.then<List<CustomerDebtModel>?>((value) {
      if (value != null) {
        return Future<List<CustomerDebtModel>>.value(
            BaseModel.listFromJson<CustomerDebtModel>(
                value, (dataMap) => CustomerDebtModel.fromMap(dataMap)));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  @override
  Future<List<OrderModel>?> getListOrders(GetListCustomerParam param) {
    final response = provider.getListOrders(param);

    return response.then<List<OrderModel>?>((value) {
      if (value != null) {
        return Future<List<OrderModel>>.value(
            BaseModel.listFromJson<OrderModel>(
                value, (dataMap) => OrderModel.fromMap(dataMap)));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  @override
  Future<List<CustomerDetailModel>?> getDetailCustomer(String customerCode) {
    final response = provider.getCustomerInfo(customerCode);

    return response.then<List<CustomerDetailModel>?>((value) {
      if (value != null) {
        return Future<List<CustomerDetailModel>>.value(
            BaseModel.listFromJson<CustomerDetailModel>(
                value, (dataMap) => CustomerDetailModel.fromMap(dataMap)));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  Future<InventoryItemDetailModel?> getDetailInventoryItem({required String productCode}) {
    final response = provider.getDetailInventoryItem(productCode: productCode);

    return response.then<InventoryItemDetailModel?>((value) {
      if (value != null) {
        return Future<InventoryItemDetailModel>.value(InventoryItemDetailModel.fromMap(value));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  @override
  Future<List<InvoiceModel>?> getCustomerInvoice(String customerCode) {
    final response = provider.getCustomerInvoice(customerCode);

    return response.then<List<InvoiceModel>?>((value) {
      if (value != null) {
        return Future<List<InvoiceModel>>.value(
            BaseModel.listFromJson<InvoiceModel>(
                value, (dataMap) => InvoiceModel.fromMap(dataMap)));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  @override
  Future<List<TopsaleModel>?> getTopSale(String customerCode, int type) async {
    final response = provider.getTopSale(customerCode, type);

    return response.then<List<TopsaleModel>?>((value) {
      if (value != null) {
        return Future<List<TopsaleModel>>.value(
            BaseModel.listFromJson<TopsaleModel>(
                value, (dataMap) => TopsaleModel.fromMap(dataMap)));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  @override
  Future<List<InventroyItemModel>?> getListInventoryItems(
      GetInventoryItemsParam param) {
    final response = provider.getInventoryItems(param);

    return response.then<List<InventroyItemModel>?>((value) {
      if (value != null) {
        return Future<List<InventroyItemModel>>.value(
            BaseModel.listFromJson<InventroyItemModel>(
                value, (dataMap) => InventroyItemModel.fromMap(dataMap)));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  @override
  Future<List<InventoryItemCategoryModel>?> getInventoryItemCategory(
      String keyword) {
    final response = provider.getInventoryItemCategory(keyword);

    return response.then<List<InventoryItemCategoryModel>?>((value) {
      if (value != null) {
        return Future<List<InventoryItemCategoryModel>>.value(
            BaseModel.listFromJson<InventoryItemCategoryModel>(value,
                (dataMap) => InventoryItemCategoryModel.fromMap(dataMap)));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  @override
  Future<List<PlanModel>?> getListPlansByKho(
      String maKho) {
    final response = provider.getListPlansByKho(maKho);

    return response.then<List<PlanModel>>((value) {
      if (value != null) {
        return Future<List<PlanModel>>.value(
            PlanModel.listFromJson(value));
      } else {
        return Future<List<PlanModel>>.value(<PlanModel>[]);
      }
    }).catchError((onError) {
      return Future<List<PlanModel>>.value(<PlanModel>[]);
    });
  }

  @override
  Future<List<InventoryProductModel>?> getListProductsByPlan(String inventoryCode, String planCode) {
    final response = provider.getListProductsByPlan(inventoryCode, planCode);

    return response.then<List<InventoryProductModel>?>((value) {
      if (value != null) {
        return Future<List<InventoryProductModel>>.value(
            BaseModel.listFromJson<InventoryProductModel>(value,
                    (dataMap) => InventoryProductModel.fromMap(dataMap)));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  @override
  Future<List<WareHouseModel>?> getListWarehouse() {
    final response = provider.getListWarehouse();

    return response.then<List<WareHouseModel>?>((value) {
      if (value != null) {
        return Future<List<WareHouseModel>>.value(
            BaseModel.listFromJson<WareHouseModel>(value,
                    (dataMap) => WareHouseModel.fromMap(dataMap)));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  /// Lấy chi tiết hóa đơn
  @override
  Future<List<OrderDetailModel>?> getOrderDetail(String code) {
    final response = provider.getOrderDetail(code);
    return response.then<List<OrderDetailModel>?>((value) {
      if (value != null) {
        return Future<List<OrderDetailModel>>.value(
        OrderDetailModel.listFromJson(value));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  /// tạo kiểm kkho
  @override
  Future<String?> createKiemKho(KiemKhoParam kiemKhoParam) {
    final response = provider.createKiemKho(kiemKhoParam);
    return response.then<String?>((value) {
      if (value != null) {
        return Future<String>.value(value);
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  /// Lấy chi tiết hóa đơn
  @override
  Future<List<ProductInfoModel>?> getProductDetailInKho(String code) {
    final response = provider.getProductDetailInKho(code);
    return response.then<List<ProductInfoModel>?>((value) {
      if (value != null) {
        return Future<List<ProductInfoModel>>.value(
            ProductInfoModel.listFromJson(value)
        );
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }

  /// tạo kiểm kkho
  @override
  Future<String?> confirmOrder(String orderCode) {
    final response = provider.confirmOrder(orderCode);
    return response.then<String?>((value) {
      if (value != null) {
        return Future<String>.value(value);
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }



  ///API eco3d
  /// danh sách xưng danh
  @override
  Future<List<PriceListOption>> getListXungDanh() async {
    final response = provider.getListXungDanh();

    return response.then<List<PriceListOption>>((value) {
      if (value != null) {
        return Future<List<PriceListOption>>.value(PriceListOptionResponse.fromJson(value).items);
      } else {
        return Future<List<PriceListOption>>.value(<PriceListOption>[]);
      }
    }).catchError((onError) {
      return Future<List<PriceListOption>>.value(<PriceListOption>[]);
    });
  }

  /// danh sách đại lý
  @override
  Future<List<PriceListOption>> getListDaiLy() async {
    final response = provider.getListDaiLy();

    return response.then<List<PriceListOption>>((value) {
      if (value != null) {
        return Future<List<PriceListOption>>.value(PriceListOptionResponse.fromJson(value).items);
      } else {
        return Future<List<PriceListOption>>.value(<PriceListOption>[]);
      }
    }).catchError((onError) {
      return Future<List<PriceListOption>>.value(<PriceListOption>[]);
    });
  }

  @override
  Future<List<PriceListOption>> getListPhuongThucVanChuyen() async {
    final response = provider.getListPhuongThucVanChuyen();

    return response.then<List<PriceListOption>>((value) {
      if (value != null) {
        return Future<List<PriceListOption>>.value(PriceListOptionResponse.fromJson(value).items);
      } else {
        return Future<List<PriceListOption>>.value(<PriceListOption>[]);
      }
    }).catchError((onError) {
      return Future<List<PriceListOption>>.value(<PriceListOption>[]);
    });
  }

  @override
  Future<List<PriceListOption>> getListThoiGianGiaoHang() async {
    final response = provider.getListThoiGianGiaoHang();

    return response.then<List<PriceListOption>>((value) {
      if (value != null) {
        return Future<List<PriceListOption>>.value(PriceListOptionResponse.fromJson(value).items);
      } else {
        return Future<List<PriceListOption>>.value(<PriceListOption>[]);
      }
    }).catchError((onError) {
      return Future<List<PriceListOption>>.value(<PriceListOption>[]);
    });
  }

  @override
  Future<List<PriceListOption>> getListDieuKienThanhToan() async {
    final response = provider.getListDieuKienThanhToan();

    return response.then<List<PriceListOption>>((value) {
      if (value != null) {
        return Future<List<PriceListOption>>.value(PriceListOptionResponse.fromJson(value).items);
      } else {
        return Future<List<PriceListOption>>.value(<PriceListOption>[]);
      }
    }).catchError((onError) {
      return Future<List<PriceListOption>>.value(<PriceListOption>[]);
    });
  }

  @override
  Future<String?> getMessageBaoGia(PriceListObject param) async {
    final response = provider.getMessageBaoGia(param);

    return response.then<String?>((value) {
      if (value != null) {
        return Future<String?>.value(value);
      } else {
        return Future<String?>.value("");
      }
    }).catchError((onError) {
      return Future<String?>.value("");
    });
  }

  @override
  Future<String?> sendBaoGia(PriceListObject param) async {
    final response = provider.sendBaoGia(param);

    return response.then<String?>((value) {
      if (value != null) {
        return Future<String?>.value(value);
      } else {
        return Future<String?>.value("");
      }
    }).catchError((onError) {
      return Future<String?>.value("");
    });
  }

  @override
  Future<List<RepresentModel>?> getNguoiDaiDien(String customerCode, String keyword) {
    final response = provider.getNguoiDaiDien(customerCode, keyword);

    return response.then<List<RepresentModel>?>((value) {
      if (value != null) {
        return Future<List<RepresentModel>>.value(
            BaseModel.listFromJson<RepresentModel>(
                value, (dataMap) => RepresentModel.fromMap(dataMap)));
      } else {
        return Future.value(null);
      }
    }).catchError((onError) {
      return Future.value(null);
    });
  }
}
