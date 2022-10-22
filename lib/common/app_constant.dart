import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConstant {
  static final kSpaceHorizontalVerySmall = 2.0.w;
  static final kSpaceHorizontalSmall = 4.0.w;
  static final kSpaceHorizontalSmallExtra = 8.0.w;
  static final kSpaceHorizontalSmallExtraExtra = 12.0.w;
  static final kSpaceHorizontalSmallExtraExtraExtra = 16.0.w;
  static final kSpaceHorizontalMedium = 20.0;
  static final kSpaceHorizontalMediumExtra = 24.0;
  static final kSpaceHorizontalLarge = 24.0.w;

  static final kSpaceVerticalVerySmall = 2.0.h;
  static final kSpaceVerticalSmall = 4.0.h;
  static final kSpaceVerticalSmallExtra = 8.0.h;
  static final kSpaceVerticalSmallExtraExtra = 12.0.h;
  static final kSpaceVerticalSmallExtraExtraExtra = 16.0.h;
  static final kSpaceVerticalMedium = 20.0.h;
  static final kSpaceVerticalMediumExtra = 24.0.h;
  static final kSpaceVerticalLarge = 120.0.h;

  /// Horizontal
  static final spaceHorizontalVerySmall =
      SizedBox(width: kSpaceHorizontalVerySmall);
  static final spaceHorizontalSmall = SizedBox(width: kSpaceHorizontalSmall);
  static final spaceHorizontalSmallExtra =
      SizedBox(width: kSpaceHorizontalSmallExtra);
  static final spaceHorizontalSmallExtraExtra =
      SizedBox(width: kSpaceHorizontalSmallExtraExtra);
  static final spaceHorizontalSmallLarge = SizedBox(
    width: kSpaceHorizontalSmallExtraExtraExtra,
  );
  static final spaceHorizontalMedium = SizedBox(
    width: kSpaceHorizontalMedium,
  );
  static final spaceHorizontalMediumExtra = SizedBox(
    width: kSpaceHorizontalMediumExtra,
  );
  static final spaceHorizontalSmallExtraExtraExtra = SizedBox(
    width: kSpaceHorizontalSmallExtraExtraExtra,
  );

  /// Vertical
  static final spaceVerticalVerySmall = SizedBox(
    height: kSpaceVerticalVerySmall,
  );
  static final spaceVerticalSmall = SizedBox(
    height: kSpaceVerticalSmall,
  );
  static final spaceVerticalSmallMedium = SizedBox(
    height: kSpaceVerticalSmallExtraExtra,
  );
  static final spaceVerticalSmallExtra = SizedBox(
    height: kSpaceVerticalSmallExtra,
  );

  static final spaceVerticalMedium = SizedBox(
    height: kSpaceVerticalMedium,
  );

  static final spaceVerticalMediumExtra = SizedBox(
    height: kSpaceVerticalMediumExtra,
  );
  static final spaceVerticalSmallExtraExtraExtra = SizedBox(
    height: kSpaceVerticalSmallExtraExtraExtra,
  );
  static final spaceVerticalSafeArea = SizedBox(
    height: AppBar().preferredSize.height + kSpaceVerticalSmallExtraExtra,
  );

  static const videoType = "video";
  static const documentType = "document";
  static const imageType = "image";
  static const websiteType = "website";

  static const loginAdmin = "ADMIN";
  static const loginSale = "SALE";
  static const loginCs = "CS";
  static const loginWareHouse = "WAREHOUSE";

  static const customerTypeAll = "all";
  static const customerTypePhatSinhDoanhThu = "1";
  static const customerTypePhatSinhDoanhThuTrong3T = "2";
  static const customerTypePhatSinhDoanhThuQua3T = "3";

  static const otHoaDonBanHang = "1";
  static const otPhieuDatHang = "2";
  static const otNoQuaHan = "3";
  static const otHoaDonXuatHang = "4";

  static const statusDaXuat = 2;

  static const success = "success";
  static const error = "error";
  static const kiem_kho = "-1";
}
