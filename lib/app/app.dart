import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_check_product.dart';
import 'package:wms/controllers/controller_connectivity.dart';
import 'package:wms/controllers/controller_couting_scock_scrren.dart';
import 'package:wms/controllers/controller_get_po_screen.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/controllers/controller_offline_screen.dart';
import 'package:wms/controllers/controller_product_get_to_shop_screen.dart';
import 'package:wms/controllers/controller_product_position_screen.dart';
import 'package:wms/controllers/controller_product_to_shop_screen.dart';
import 'package:wms/controllers/controller_tran_out_product.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/routes/routes.dart';
import 'package:wms/screens/branch_screen/branch_screen.dart';
import 'package:wms/screens/check_product_screen/check_product_screen.dart';
import 'package:wms/screens/connection_lost/connectionLost.dart';
import 'package:wms/screens/count_stock_offline_screen/count_stock_offline_screen.dart';
import 'package:wms/screens/couting_stock_screen/couting_stock_screen.dart';
import 'package:wms/screens/login_screen/login_screen.dart';
import 'package:wms/screens/main_screen/main_screen.dart';
// import 'package:wms/screens/pick_up_screen/pick_up_screen.dart';
import 'package:wms/screens/print_post_product_screen/print_post_product_screen.dart';
import 'package:wms/screens/product_management_screen/product_management_screen.dart';
import 'package:wms/screens/product_position_screen/add_product_to_location_page/add_product_to_location.dart';
import 'package:wms/screens/product_position_screen/detail_location_page/detail_location_page.dart';
import 'package:wms/screens/product_position_screen/product_position_screen.dart';
import 'package:wms/screens/product_position_screen/show_order_page/show_order_page.dart';
import 'package:wms/screens/product_strore_screen/product_store_screen.dart';
import 'package:wms/screens/tran_in_product_screen/tran_product_screen.dart';
import 'package:wms/screens/product_to_shop_screen/product_to_shop_screen.dart';
import 'package:wms/screens/report_screen/report_screen.dart';
// import 'package:wms/screens/splash_screen/SplashScreen.dart';
import 'package:wms/screens/tran_out_product_screen/tran_out_product_screen.dart';
import 'package:wms/screens/upload_offline_mode_screen/upload_offline_mode_screen.dart';
import 'package:wms/themes/colors.dart';

import '../controllers/controller_cancelListPrinter.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ControllerLoginScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => ControllerUser(),
        ),
        ChangeNotifierProvider(
          create: (context) => ControllerProductGetToShopScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => ControllerProductToShopScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => ControllerCheckProduct(),
        ),
        ChangeNotifierProvider(
          create: (context) => ControllerConnectivity(),
        ),
        ChangeNotifierProvider(
          create: (context) => ControllerProductPositionScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => ControllerCountingStockScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => ControllerOfflineScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => ControllerGetPoScreen(),
        ),
        ChangeNotifierProvider<ControllerTranOutProduct>(
          create: (context) => ControllerTranOutProduct(),
        ),
        ChangeNotifierProvider<ControllerCancelListPrinter>(
          create: (context) => ControllerCancelListPrinter(),
        ),
      ],
      child: MaterialApp(
        title: 'Warehouse Management System',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale('th', 'TH'),
        supportedLocales: [
          const Locale('en', 'US'), // English
          const Locale('th', 'TH'), // Thai
        ],
        theme: ThemeData(
          primaryColor: kmainPrimaryColor,
          fontFamily: 'Mitr',
          appBarTheme: AppBarTheme(
              centerTitle: true,
              backgroundColor: white,
              titleTextStyle: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: black)),
        ),
        initialRoute: RouteName.routeNameLoginScreen,
        routes: {
          RouteName.routeNameLoginScreen: (context) => LoginScreen(),
          RouteName.routeNameBranchScreen: (context) => BranchScreen(),
          RouteName.routeNameMainScreen: (context) => MainScreen(),
          // RouteName.routeNamePickUpScreen: (context) => PickUpScreen(),
          // RouteName.routeNameProductToShopScreen: (context) =>
          //     ProductToShopScreen(),
          // RouteName.routeNameProductGetToShopScreen: (context) =>
          //     ProductGetToShopScreen(),
          RouteName.routeNameCheckProductScreen: (context) =>
              CheckProductScreen(),
          RouteName.routeNameConnectionLost: (context) => ConnectionLost(),
          // RouteName.routeNameSplashScreen: (context) => SplashScreen(),
          RouteName.routeNameProductPositionScreen: (context) =>
              ProductPositionScreen(),
          RouteName.routeNameAddProductToLocation: (context) =>
              AddProductToLocation(),
          RouteName.routeNameShowOrderPage: (context) => ShowOrderPage(),
          RouteName.routeNameDetailLocationPage: (context) =>
              DetailLocationPage(),
          RouteName.routeNameReportStatusScreen: (context) =>
              ReportStatusScreen(),
          RouteName.routeNameProductStoreScreen: (context) =>
              ProductStoreScreen(),
          RouteName.routeNameTranProductScreen: (context) =>
              TranProductScreen(),
          RouteName.routeNamePrintPostProductScreen: (context) =>
              PrintPostProductScreen(),
          RouteName.routeNameProductManagementScreen: (context) =>
              ProductManagementScreen(),
          RouteName.routeNameTranOutProductScreen: (context) =>
              TranOutProductScreen(),
          RouteName.routeNameCountingStokScreen: (context) =>
              CountingStokScreen(),
          RouteName.routeNameCountStockOfflineScreen: (context) =>
              CountStockOfflineScreen(),
          RouteName.routeNameUploadOfflineModeScreen: (context) =>
              UploadOfflineModeScreen(),
        },
      ),
    );
  }
}
