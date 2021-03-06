import 'dart:convert';
import 'dart:typed_data';

import 'package:bbfluttermodule/common/common.dart';
import 'package:bbfluttermodule/util/device_utils.dart';
import 'package:bbfluttermodule/util/log_utils.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sp_util/sp_util.dart';
import 'package:sprintf/sprintf.dart';
import 'package:package_info/package_info.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:common_utils/common_utils.dart';

import 'dio_utils.dart';
import 'error_handle.dart';

class TokenInterceptor extends Interceptor {
  final String KEY = "com.psss@2018";
  final String ERP_KEY = "com.psss@ysbaob2019";
  final String PHP_KEY = "com.psss@yserp2019";

  MethodChannel channel = MethodChannel(Constant.CHANNEL_NAME);

  Future<String> getToken() async {
    Map<String, String> params = <String, String>{};
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      params['cv'] = packageInfo.appName;
      params['system'] = "2";
      params["_time"] = DateTime.now().millisecond.toString();
    });
    DeviceInfoPlugin().androidInfo.then((AndroidDeviceInfo value) {
      params['os'] = value.version.release;
      params['model'] = value.version.baseOS;
    });

    return null;
  }

  String getSingleParams(Map<String, String> params, String baseUrl) {
    var arrays = [];
    params.forEach((key, value) {
      var tempStr = value.trimLeft().trimRight();
      arrays.add("$key=$tempStr");
      arrays.sort();
    });
    if (baseUrl.startsWith("https://pssapi")) {
      arrays.add("key=$KEY");
    } else if (baseUrl.startsWith("https://erpapi")) {
      arrays.add("key=$ERP_KEY");
    } else if (baseUrl.startsWith("https://d0k0")) {
      arrays.add("key=$PHP_KEY");
    } else {
      arrays.add("key=$KEY");
    }

      var singTempStr = arrays.join("&");
//      var utf8Str = Utf8Encoder().convert(singTempStr);
//      var digest = md5.convert(utf8Str);
      // 这里其实就是 digest.toString()
//    return hex.encode(digest.bytes).toUpperCase();
    return EncryptUtil.encodeMd5(singTempStr);
  }

  Future<dynamic> getParams(String baseUrl, Map<String, String> data) async {
    Map<String, String> params = <String, String>{};
    await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      params['cv'] = packageInfo.appName;
      params['system'] = "2";
      params['token'] = SpUtil.getString("token");
      params['shopId'] = SpUtil.getString(Constant.SP_SHOP_ID);
      params["_time"] = DateTime.now().millisecondsSinceEpoch.toString();
    });
    await DeviceInfoPlugin().androidInfo.then((AndroidDeviceInfo value) {
      params['os'] = value.version.release;
      params['model'] = value.version.baseOS;
    });
    if (data != null) {
      params.addAll(data);
    }
    //添加签名
//    params["sign"] = getSingleParams(params, baseUrl);
    if (baseUrl.startsWith("https://pssapi")) {
      return await channel.invokeMethod(Constant.CHANNEL_SIGN_BAO_BAN, params);
    } else if (baseUrl.startsWith("https://erpapi")) {
      return await channel.invokeMethod(Constant.CHANNEL_SIGN_PHP, params);
    } else if (baseUrl.startsWith("https://d0k0")) {
      return await channel.invokeMethod(Constant.CHANNEL_SIGN_ERP, params);
    } else {
      return await channel.invokeMethod(Constant.CHANNEL_SIGN, params);
    }
  }

  Dio _tokenDio = Dio();

  @override
  Future onRequest(RequestOptions options) async {
    await getParams(options.baseUrl, options.data).then((value) {
      var params = Map<String, String>.from(value);
      options.queryParameters.addAll(params);
      return super.onRequest(options);
    });
  }

  @override
  Future<Object> onResponse(Response response) async {
    //401代表token过期
    if (response != null &&
        response.statusCode == ExceptionHandle.unauthorized) {
      Log.d('-----------自动刷新Token------------');
      final Dio dio = DioUtils.instance.dio;
      dio.interceptors.requestLock.lock();
      final String accessToken = await getToken(); // 获取新的accessToken
      Log.e('-----------NewToken: $accessToken ------------');
      SpUtil.putString(Constant.accessToken, accessToken);
      dio.interceptors.requestLock.unlock();

      if (accessToken != null) {
        // 重新请求失败接口
        final RequestOptions request = response.request;
        request.headers['Authorization'] = 'Bearer $accessToken';
        try {
          Log.e('----------- 重新请求接口 ------------');

          /// 避免重复执行拦截器，使用tokenDio
          final Response response = await _tokenDio.request(request.path,
              data: request.data,
              queryParameters: request.queryParameters,
              cancelToken: request.cancelToken,
              options: request,
              onReceiveProgress: request.onReceiveProgress);
          return response;
        } on DioError catch (e) {
          return e;
        }
      }
    }
    return super.onResponse(response);
  }
}

class LoggingInterceptor extends Interceptor {
  DateTime _startTime;
  DateTime _endTime;

  @override
  Future onRequest(RequestOptions options) async {
    _startTime = DateTime.now();
    Log.d('----------Start----------');
    if (options.queryParameters.isEmpty) {
      Log.d('RequestUrl: ' + options.baseUrl + options.path);
    } else {
      Log.d('RequestUrl: ' +
          options.baseUrl +
          options.path +
          '?' +
          Transformer.urlEncodeMap(options.queryParameters));
    }
    Log.d('RequestMethod: ' + options.method);
    Log.d('RequestHeaders:' + options.headers.toString());
    Log.d('RequestContentType: ${options.contentType}');
    Log.d('RequestData: ${options.data.toString()}');

    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    _endTime = DateTime.now();
    int duration = _endTime.difference(_startTime).inMilliseconds;
    if (response.statusCode == ExceptionHandle.success) {
      Log.d('ResponseCode: ${response.statusCode}');
    } else {
      Log.e('ResponseCode: ${response.statusCode}');
    }
    // 输出结果
    Log.json(response.data.toString());
    Log.d('----------End: $duration 毫秒----------');
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    Log.d('----------Error-----------');
    return super.onError(err);
  }
}

class AdapterInterceptor extends Interceptor {
  @override
  Future onResponse(Response response) {
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    return super.onError(err);
  }
}
