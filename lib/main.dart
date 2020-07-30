import 'dart:convert';
import 'dart:ui';

import 'package:bbfluttermodule/page/ensure_money/page/ensure_money.dart';
import 'package:bbfluttermodule/page/threePage.dart';
import 'package:bbfluttermodule/router/not_found_page.dart';
import 'package:bbfluttermodule/router/routers.dart';
import 'package:bbfluttermodule/util/log_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

import 'common/common.dart';
import 'package:bbfluttermodule/secondPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'bean/rouPathBean.dart';
import 'net/dio_utils.dart';
import 'net/intercept.dart';
import 'page/score_page.dart';
import 'theme/theme_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  /// sp初始化
  await SpUtil.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Widget home;
  final ThemeData theme;

  MyApp({this.home, this.theme}) {
    Log.init();
    initDio();
    Routes.initRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
          child: Consumer<ThemeProvider>(
            builder: (_, provider, __) {
              return MaterialApp(
                title: 'Flutter Deer',
//              showPerformanceOverlay: true, //显示性能标签
//              debugShowCheckedModeBanner: false, // 去除右上角debug的标签
//              checkerboardRasterCacheImages: true,
//              showSemanticsDebugger: true, // 显示语义视图
//              checkerboardOffscreenLayers: true, // 检查离屏渲染
                theme: theme ?? provider.getTheme(),
//                darkTheme: provider.getTheme(isDarkMode: true),
//                themeMode: provider.getThemeMode(),
                home: EnsureMoney(),
                onGenerateRoute: Routes.router.generator,
                builder: (context, child) {
                  /// 保证文字大小不受手机系统设置影响 https://www.kikt.top/posts/flutter/layout/dynamic-text/
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    // 或者 MediaQueryData.fromWindow(WidgetsBinding.instance.window).copyWith(textScaleFactor: 1.0),
                    child: child,
                  );
                },

                /// 因为使用了fluro，这里设置主要针对Web
                onUnknownRoute: (_) {
                  return MaterialPageRoute(
                    builder: (BuildContext context) => NotFoundPage(),
                  );
                },
              );
            },
          ),
        ),

        /// Toast 配置
        backgroundColor: Colors.black54,
        textPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        radius: 20.0,
        position: ToastPosition.bottom);
  }

  void initDio() {
    final List<Interceptor> interceptors = [];

//    /// 统一添加身份验证请求头
//    interceptors.add(AuthInterceptor());
//


    /// 刷新Token
    interceptors.add(TokenInterceptor());

    /// 打印Log(生产模式去除)
    if (!Constant.inProduction) {
      interceptors.add(LoggingInterceptor());
    }

    /// 适配数据(根据自己的数据结构，可自行选择添加)
    interceptors.add(AdapterInterceptor());
    setInitDio(
      baseUrl: 'http://192.168.1.245:8081/',
      interceptors: interceptors,
    );
  }
}

_widgetRouter(String json) {
  print("==== main === json = $json");
  String path = "test_sample";
  String param = "";
  if (json != null && json.isNotEmpty && json != "/") {
    var jsonResponse = RoutePathBean.fromJson(jsonDecode(json));
    path = jsonResponse.path;
    param = jsonResponse.param.toString();
    path = path != null && path.isNotEmpty ? path : "test_sample";
    param = param != null && param.isNotEmpty ? param : "";
    switch (path) {
      case "1":
        return ScorePage();
      case "2":
        return SecondPage();
      case "3":
        return ThreePage();
    }
  } else {
    return ScorePage();
  }
}
