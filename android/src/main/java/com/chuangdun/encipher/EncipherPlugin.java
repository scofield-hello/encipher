package com.chuangdun.encipher;

import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * EncipherPlugin.
 * @author Nickey
 */
public class EncipherPlugin implements MethodCallHandler {

  private static final String TAG = "EncipherPlugin";

  final static String METHOD_NAME = "encrypt";
  final static int TYPE_STANDARD = 0;
  final static int TYPE_CHUANGDUN = 1;
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "encipher");
    channel.setMethodCallHandler(new EncipherPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals(METHOD_NAME)) {
      String raw = call.argument("raw");
      int type = call.argument("type");
      int repeat = call.argument("repeat");
      String salt = call.argument("salt");
      Log.d(TAG, "onMethodCall: raw: " + raw);
      Log.d(TAG, "onMethodCall: type: " + type);
      Log.d(TAG, "onMethodCall: repeat: " + repeat);
      Log.d(TAG, "onMethodCall: salt: " + salt);
      if (type == TYPE_STANDARD){
        String cipher = StandardEncoder.encrypt(raw, salt, repeat);
        result.success(cipher);
      }else if (type == TYPE_CHUANGDUN){
        String cipher = ChuangDunEncoder.encrypt(raw, repeat);
        result.success(cipher);
      }else{
        result.notImplemented();
        Log.e(TAG, "onMethodCall: 加密类型参数不支持");
      }
    } else {
      result.notImplemented();
      Log.e(TAG, "onMethodCall: 方法未实现:"+call.method);
    }
  }
}
