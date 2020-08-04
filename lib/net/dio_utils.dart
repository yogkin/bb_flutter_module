import 'dart:convert';
import 'dart:io';

import 'package:bbfluttermodule/common/common.dart';
import 'package:bbfluttermodule/net/host_type.dart';
import 'package:bbfluttermodule/util/log_utils.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_util/sp_util.dart';
import 'base_entity.dart';
import 'error_handle.dart';

/// 默认dio配置
int _connectTimeout = 15000;
int _receiveTimeout = 15000;
int _sendTimeout = 10000;
List<Interceptor> _interceptors = [];

/// 初始化Dio配置
void setInitDio({
  int connectTimeout,
  int receiveTimeout,
  int sendTimeout,
  String baseUrl,
  List<Interceptor> interceptors,
}) {
  _connectTimeout = connectTimeout ?? _connectTimeout;
  _receiveTimeout = receiveTimeout ?? _receiveTimeout;
  _sendTimeout = sendTimeout ?? _sendTimeout;
  _interceptors = interceptors ?? _interceptors;
}

typedef NetSuccessCallback<T> = Function(T data);
typedef NetSuccessListCallback<T> = Function(List<T> data);
typedef NetErrorCallback = Function(int code, String msg);

/// @weilu https://github.com/simplezhli
class DioUtils {
  static final DioUtils _singleton = DioUtils._();

  static DioUtils get instance => DioUtils();

  factory DioUtils() => _singleton;

  static Dio _bbDio;
  static Dio _erpDio;
  static Dio _phpDio;

  Dio get dio => _bbDio;

  DioUtils._() {
    BaseOptions _bbOptions = BaseOptions(
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,

      /// dio默认json解析，这里指定返回UTF8字符串，自己处理解析。（可也以自定义Transformer实现）
      responseType: ResponseType.plain,
      validateStatus: (_) {
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
      baseUrl: SpUtil.getString(Constant.SP_BB_BASE_URL),
//      contentType: Headers.formUrlEncodedContentType, // 适用于post form表单提交
    );
    BaseOptions _erpOptions = BaseOptions(
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,

      /// dio默认json解析，这里指定返回UTF8字符串，自己处理解析。（可也以自定义Transformer实现）
      responseType: ResponseType.plain,
      validateStatus: (_) {
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
      baseUrl: SpUtil.getString(Constant.SP_ERP_BASE_URL),
//      contentType: Headers.formUrlEncodedContentType, // 适用于post form表单提交
    );
    BaseOptions _phpOptions = BaseOptions(
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,

      /// dio默认json解析，这里指定返回UTF8字符串，自己处理解析。（可也以自定义Transformer实现）
      responseType: ResponseType.plain,
      validateStatus: (_) {
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
      baseUrl: SpUtil.getString(Constant.SP_PHP_BASE_URL),
//      contentType: Headers.formUrlEncodedContentType, // 适用于post form表单提交
    );
    _bbDio = Dio(_bbOptions);
    _erpDio = Dio(_erpOptions);
    _phpDio = Dio(_phpOptions);

    /// Fiddler抓包代理配置 https://www.jianshu.com/p/d831b1f7c45b
    (_bbDio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.findProxy = (uri) {
        //proxy all request to localhost:8888
//        return 'PROXY localhost:8888';
        return 'PROXY 192.168.10.86:8888';
      };
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
    (_erpDio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.findProxy = (uri) {
        //proxy all request to localhost:8888
        return 'PROXY localhost:8888';
      };
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
    (_phpDio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.findProxy = (uri) {
        //proxy all request to localhost:8888
        return 'PROXY localhost:8888';
      };
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };

    /// 添加拦截器
    _interceptors.forEach((interceptor) {
      _bbDio.interceptors.add(interceptor);
      _erpDio.interceptors.add(interceptor);
      _phpDio.interceptors.add(interceptor);
    });
  }

  // 数据返回格式统一，统一处理异常
  Future<BaseEntity<T>> _request<T>(String method,
      String url,
      HOST_TYPE hostsType, {
        dynamic data,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options,
      }) async {
    Dio _dio;
    switch (hostsType) {
      case HOST_TYPE.baoban:
        _dio = _bbDio;
        break;
      case HOST_TYPE.erp:
        _dio = _erpDio;
        break;
      case HOST_TYPE.php:
        _dio = _phpDio;
        break;
    }
    final Response<String> response = await _dio.request<String>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: _checkOptions(method, options),
      cancelToken: cancelToken,
    );
    try {
      final String data = response.data.toString();

      /// 集成测试无法使用 isolate https://github.com/flutter/flutter/issues/24703
      /// 使用compute条件：数据大于10KB（粗略使用10 * 1024）且当前不是集成测试（后面可能会根据Web环境进行调整）
      /// 主要目的减少不必要的性能开销
      final bool isCompute = !Constant.isDriverTest && data.length > 10 * 1024;
      debugPrint('isCompute:$isCompute');
      final Map<String, dynamic> _map =
      isCompute ? await compute(parseData, data) : parseData(data);
      return BaseEntity<T>.fromJson(_map);
    } catch (e) {
      debugPrint(e.toString());
      return BaseEntity<T>(ExceptionHandle.parse_error, '数据解析错误！', null);
    }
  }

  Options _checkOptions(String method, Options options) {
    options ??= Options();
    options.method = method;
    return options;
  }

//  Future requestNetwork<T>(
//    Method method,
//    String url, {
//    NetSuccessCallback<T> onSuccess,
//    NetErrorCallback onError,
//    dynamic params,
//    Map<String, dynamic> queryParameters,
//    CancelToken cancelToken,
//    Options options,
//  }) {
//    return _request<T>(
//      method.value,
//      url,
//      data: params,
//      queryParameters: queryParameters,
//      options: options,
//      cancelToken: cancelToken,
//    ).then((BaseEntity<T> result) {
//      if (result.code == 0) {
//        if (onSuccess != null) {
//          onSuccess(result.data);
//        }
//      } else {
//        _onError(result.code, result.msg, onError);
//      }
//    }, onError: (dynamic e) {
//      _cancelLogPrint(e, url);
//      final NetError error = ExceptionHandle.handleException(e);
//      _onError(error.code, error.msg, onError);
//    });
//  }


  /// 统一处理(onSuccess返回T对象，onSuccessList返回 List<T>)
  void asyncBaoBanRequestNetwork<T>(Method method,
      String url, {
        NetSuccessCallback<T> onSuccess,
        NetErrorCallback onError,
        dynamic params,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options,
      }) {
    asyncRequestNetwork(method, url, HOST_TYPE.baoban, onSuccess: onSuccess,
        onError: onError, params: params, queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options);
  }

  /// 统一处理(onSuccess返回T对象，onSuccessList返回 List<T>)
  void asyncPhpRequestNetwork<T>(Method method,
      String url, {
        NetSuccessCallback<T> onSuccess,
        NetErrorCallback onError,
        dynamic params,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options,
      }) {
    asyncRequestNetwork(method, url, HOST_TYPE.php, onSuccess: onSuccess,
        onError: onError, params: params, queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options);
  }

  /// 统一处理(onSuccess返回T对象，onSuccessList返回 List<T>)
  void asyncErpRequestNetwork<T>(Method method,
      String url, {
        NetSuccessCallback<T> onSuccess,
        NetErrorCallback onError,
        dynamic params,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options,
      }) {
    asyncRequestNetwork(method, url, HOST_TYPE.erp, onSuccess: onSuccess,
        onError: onError, params: params, queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options);
  }


  /// 统一处理(onSuccess返回T对象，onSuccessList返回 List<T>)
  void asyncRequestNetwork<T>(Method method,
      String url, HOST_TYPE hostType, {
        NetSuccessCallback<T> onSuccess,
        NetErrorCallback onError,
        dynamic params,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options,
      }) {
    Stream.fromFuture(_request<T>(
      method.value,
      url,
      hostType,
      data: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    )).asBroadcastStream().listen((result) {
      if (result.code == 0) {
        if (onSuccess != null) {
          onSuccess(result.data);
        }
      } else {
        _onError(result.code, result.msg, onError);
      }
    }, onError: (dynamic e) {
      _cancelLogPrint(e, url);
      final NetError error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  void _cancelLogPrint(dynamic e, String url) {
    if (e is DioError && CancelToken.isCancel(e)) {
      Log.e('取消请求接口： $url');
    }
  }

  void _onError(int code, String msg, NetErrorCallback onError) {
    if (code == null) {
      code = ExceptionHandle.unknown_error;
      msg = '未知异常';
    }
    Log.e('接口请求异常： code: $code, mag: $msg');
    if (onError != null) {
      onError(code, msg);
    }
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data) as Map<String, dynamic>;
}

enum Method { get, post, put, patch, delete, head }

/// 使用拓展枚举替代 switch判断取值
/// https://zhuanlan.zhihu.com/p/98545689
extension MethodExtension on Method {
  String get value => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'][index];
}
