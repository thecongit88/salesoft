class UrlHelper {
  //static String baseUrl = "http://103.226.249.226";
  static String baseUrl = "http://app.salesoft.vn";
  static String urlGetPort = "https://salesoft.vn/app.xml";
  static String port = "1111";
  //static String urlRequest = "$baseUrl:$port/api/";
  static String urlRequest = "$baseUrl/api/";

  /// News
  static const String LIST_NEWS = "news/get";
  static const String LIST_QUESTION = "news/question";
  static const String NEWS_DETAIL = "news/detail";
  static const String SAME_NEWS = "news/get/same";

  /// Account
  static const String LOGIN = "user/login";
  static const String APP_INFO = "system/get/1";
  static const String COMPANY_INFO = "system/companyinfo";

  /// Report
  static const String REPORT_REVENUE = "report/revenue";
  static const String REPORT_STAFF_REVENUE = "report/StaffRevenue";
  static const String REPORT_STORES = "system/shops";
  static const String REPORT_CASTBOOK = "report/cashbook";
  static const String REPORT_CASTFLOW = "report/cashflow";

  static const String REPORT_CUSTOMERS = "customer/get";
  static const String LIST_DEBT_CUSTOMERS = "customer/listdebt";
  static const String REPORT_CUSTOMER_DETAIL = "customer/detail";
  static const String REPORT_CUSTOMER_INVOICE = "customer/topcare";
  static const String REPORT_CUSTOMER_TOP_SALE = "customer/topsale";
  static const String REPORT_PRODUCTS = "customer/get";
  static const String REPORT_INVENTORY_ITEM = "product/get";
  static const String REPORT_INVENTORY_ITEM_DETAIL = "product/detail";
  static const String REPORT_INVENTORY_ITEM_CATEGORY = "system/categories";
  static const String REPORT_ORDER_CATEGORY = "order/get";
  static const String REPORT_LIST_PLAN_BY_KHO = "warehouse/plan";
  static const String REPORT_LIST_PRODUCT_BY_PLAN = "warehouse/productlist";

  //Notification
  static const String LIST_NOTIFI = "alert";

  // Video
  static const String LIST_VIDEO = "news/video/";

  static const String LIST_CONTACT = "contact/get/1";

  // debt

  //static const String CUSTOMER_DEBT = "report/debt/";
  static const String CUSTOMER_DEBT = "customer/detaildebt/";

  //receipt
  static const String ORDER_DETAIL = "order/detail";

  static const String ITEM_IN_STOCK = "report/Inventories";

// create order code
  static const String CREATE_ORDER_CODE = "order/OrderCode";

  static const String LIST_WAREHOUSE = "/order/warehouse";

  static const String CREATE_ORDER = "/order";

  static const String CREATE_KIEM_KHO = "/warehouse";

  static const String PRODUCT_INFO_KHO = "warehouse/productinfo";

  static const String CONFIRM_ORDER = "order/confirmorder";


  ///API báo giá của eco3d
  static String baseUrlEcod3d = "http://103.226.249.226:2222/api/pricelist/";
  static String LIST_XUNG_DANH = "pricelist/getitem/xungdanh";
  static String LIST_DAI_LY = "pricelist/getitem/daily";
  static String LIST_PHUONG_THUC_VAN_CHUYEN = "pricelist/getitem/phuongthucvanchuyen";
  static String LIST_THOI_GIAN_GIAO_HANG = "pricelist/getitem/thoigiancaphang";
  static String LIST_DIEU_KIEN_THANH_TOAN = "pricelist/getitem/dieukienthanhtoan";

  //2 api này chưa được
  static String GET_MESSAGE_BAO_GIA = "content";
  static String SEND_BAO_GIA = "pricelist";
  static String BAO_GIA_CONTACT_LIST = "pricelist/contactlist";
}
