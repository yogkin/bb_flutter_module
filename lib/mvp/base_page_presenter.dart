import 'dart:io';
import 'package:bbfluttermodule/net/dio_utils.dart';
import 'package:bbfluttermodule/net/error_handle.dart';
import 'package:bbfluttermodule/net/host_type.dart';
import 'package:bbfluttermodule/net/http_api.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import 'base_presenter.dart';
import 'mvps.dart';

class BasePagePresenter<V extends IMvpView> extends BasePresenter<V> {
  CancelToken _cancelToken;

  BasePagePresenter() {
    _cancelToken = CancelToken();
  }

  @override
  void dispose() {
    /// 销毁时，将请求取消
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }
  }

  /// 统一处理(onSuccess返回T对象，onSuccessList返回 List<T>)
  void asyncBaoBanRequestNetwork<T>(
    Method method, {
    String url,
    NetSuccessCallback<T> onSuccess,
    NetErrorCallback onError,
    dynamic params,
    bool isShow = true,
    bool isClose = true,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
  }) {
    asyncRequestNetwork<T>(method,
        url: url,
        hostType: HOST_TYPE.baoban,
        onSuccess: onSuccess,
        onError: onError,
        params: params,
        isShow: isShow,
        isClose: isClose,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options);
  }

  /// 统一处理(onSuccess返回T对象，onSuccessList返回 List<T>)
  void asyncPhpRequestNetwork<T>(
    Method method, {
    String url,
    NetSuccessCallback<T> onSuccess,
    NetErrorCallback onError,
    dynamic params,
    bool isShow = true,
    bool isClose = true,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
  }) {
    asyncRequestNetwork<T>(method,
        url: url,
        hostType: HOST_TYPE.php,
        onSuccess: onSuccess,
        isShow: isShow,
        isClose: isClose,
        onError: onError,
        params: params,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options);
  }

  /// 统一处理(onSuccess返回T对象，onSuccessList返回 List<T>)
  void asyncErpRequestNetwork<T>(
    Method method, {
    String url,
    NetSuccessCallback<T> onSuccess,
    NetErrorCallback onError,
    dynamic params,
    bool isShow = true,
    bool isClose = true,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
  }) {
    asyncRequestNetwork<T>(method,
        url: url,
        hostType: HOST_TYPE.erp,
        onSuccess: onSuccess,
        onError: onError,
        params: params,
        isShow: isShow,
        isClose: isClose,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options);
  }

  void asyncRequestNetwork<T>(
    Method method, {
    @required String url,
    HOST_TYPE hostType,
    bool isShow = true,
    bool isClose = true,
    NetSuccessCallback<T> onSuccess,
    NetErrorCallback onError,
    dynamic params,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
  }) {
    if (isShow) view.showProgress();
    DioUtils.instance.asyncRequestNetwork<T>(
      method,
      url,
      hostType,
      params: params,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken ?? _cancelToken,
      onSuccess: (data) {
        if (isClose) view.closeProgress();
        if (onSuccess != null) {
          onSuccess(data);
        }
      },
      onError: (code, msg) {
        _onError(code, msg, onError);
      },
    );
  }

  void _onError(int code, String msg, NetErrorCallback onError) {
    /// 异常时直接关闭加载圈，不受isClose影响
    view.closeProgress();
    if (code != ExceptionHandle.cancel_error) {
      view.showToast(msg);
    }

    /// 页面如果dispose，则不回调onError
    if (onError != null && view.getContext() != null) {
      onError(code, msg);
    }
  }
}
