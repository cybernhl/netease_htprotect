package com.netease.htp;

import android.content.Context;
import android.content.res.Configuration;
import android.os.Looper;
import android.os.Handler;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import com.netease.htprotect.*;
import com.netease.htprotect.result.AntiCheatResult;

import java.util.HashMap;
import java.util.Map;

/**
 * HtprotectPlugin
 */
public class HtprotectPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context context;

    private static final String CODE_KEY = "code";
    private static final String MSG_KEY = "msg";
    private static final String TOKEN_KEY = "token";


    public static HtprotectPlugin sInstance;

    public HtprotectPlugin() {
        sInstance = this;
    }

    public void callFlutterMethod(String method, Map<String, String> arguments) {
        if (TextUtils.isEmpty(method)) {
            return;
        }
        Handler handler = new Handler(Looper.getMainLooper());
        handler.post(() -> channel.invokeMethod(method, arguments));
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "htprotect");
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("init")) {
            init(call, result);
        } else if (call.method.equals("setRoleInfo")) {
            setRoleInfo(call, result);
        } else if (call.method.equals("logOut")) {
            logOut();
        } else if (call.method.equals("getToken")) {
            getToken(call, result);
        } else if (call.method.equals("ioctl")) {
            ioctl(call, result);
        } else if (call.method.equals("getDataSign")) {
            getDataSign(call, result);
        } else if (call.method.equals("safeCommToServer")) {
            safeCommToServer(call, result);
        } else if (call.method.equals("safeCommFromServer")) {
            safeCommFromServer(call, result);
        } else if (call.method.equals("registerTouchEvent")) {
            registerTouchEvent(call);
        } else if (call.method.equals("unregisterTouchEvent")) {
            unregisterTouchEvent();
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private void init(MethodCall call, Result result) {
        String productId = call.argument("productId");
        com.netease.htprotect.callback.HTPCallback callback = new com.netease.htprotect.callback.HTPCallback() {
            @Override
            public void onReceive(int paramInt, String paramString) {
                HashMap<String, String> map = new HashMap<>();
                map.put(CODE_KEY, String.valueOf(paramInt));
                map.put(MSG_KEY, paramString);
                try {
                    result.success(map);
                } catch (Exception e) {

                }
            }
        };
        HTProtectConfig htProtectConfig = new HTProtectConfig();
        HashMap config = call.argument("params");
        if (!config.isEmpty()) {
            if (config.containsKey("serverType")) {
                Integer intObject = (Integer) config.get("serverType");
                int serverType = intObject.intValue();
                htProtectConfig.setServerType(serverType);
            }
            if (config.containsKey("channel")) {
                String strChannel = (String) config.get("channel");
                htProtectConfig.setChannel(strChannel);
            }
            if (config.containsKey("gameKey")) {
                String strGameKey = (String) config.get("gameKey");
                htProtectConfig.setGameKey(strGameKey);
            }
            if (config.containsKey("extData")) {
                HashMap<String, String> strExtData = (HashMap<String, String>) config.get("extData");
                for (Map.Entry<String, String> entry : strExtData.entrySet()) {
                    htProtectConfig.setExtraData(entry.getKey(), entry.getValue());
                }
            }
        }
        HTProtect.init(context, productId, callback, htProtectConfig);
    }

    private void setRoleInfo(MethodCall call, Result result) {
        String businessId = call.argument("businessId");
        String roleId = call.argument("roleId");
        String roleName = call.argument("roleName");
        String roleAccount = call.argument("roleAccount");
        String roleServer = call.argument("roleServer");
        int serverId = call.argument("serverId");
        String gameJson = call.argument("gameJson");
        int ret = HTProtect.setRoleInfo(businessId, roleId, roleName, roleAccount, roleServer, serverId, gameJson);
        try {
            result.success(ret);
        } catch (Exception e) {

        }
    }

    private void logOut() {
        HTProtect.logOut();
    }

    private void getToken(MethodCall call, Result result) {
        int timeout = call.argument("timeout");
        String businessId = call.argument("businessId");
        com.netease.htprotect.callback.GetTokenCallback callback = new com.netease.htprotect.callback.GetTokenCallback() {
            @Override
            public void onResult(AntiCheatResult acResult) {
                HashMap<String, String> map = new HashMap<>();
                map.put(CODE_KEY, String.valueOf(acResult.code));
                map.put(TOKEN_KEY, acResult.token);
                try {
                    result.success(map);
                } catch (Exception e) {

                }
            }
        };
        HTProtect.getTokenAsync(timeout, businessId, callback);
    }

    private void ioctl(MethodCall call, Result result) {
        int request = call.argument("request");
        String data = call.argument("data");
        String ret = HTProtect.ioctl(request, data);
        try {
            result.success(ret);
        } catch (Exception e) {

        }
    }

    private void getDataSign(MethodCall call, Result result) {
        int algIndex = call.argument("algIndex");
        String inputData = call.argument("inputData");
        String ret = HTProtect.getDataSign(inputData, algIndex);
        try {
            result.success(ret);
        } catch (Exception e) {

        }
    }

    private void safeCommToServer(MethodCall call, Result result) {
        int version = call.argument("version");
        int alg = call.argument("alg");
        String input = call.argument("input");
        boolean isCrucial = call.argument("isCrucial");
        com.netease.htprotect.result.SafeCommResult safeCommResult = HTProtect.safeCommToServerV30(version, alg, input.getBytes(), isCrucial);
        try {
            HashMap<String, String> map = new HashMap<>();
            map.put(CODE_KEY, String.valueOf(safeCommResult.ret));
            map.put(MSG_KEY, safeCommResult.encResult);
            result.success(map);
        } catch (Exception e) {

        }
    }

    private void safeCommFromServer(MethodCall call, Result result) {
        int alg = call.argument("alg");
        int timeout = call.argument("timeout");
        String input = call.argument("input");

        com.netease.htprotect.result.SafeCommResult safeCommResult = HTProtect.safeCommFromServer(alg, timeout, input);
        try {
            HashMap<String, String> map = new HashMap<>();
            map.put(CODE_KEY, String.valueOf(safeCommResult.ret));
            String msg = new String(safeCommResult.decResult, "UTF-8");
            map.put(MSG_KEY, msg);
            result.success(map);
        } catch (Exception e) {

        }
    }

    private void registerTouchEvent(MethodCall call) {
        int gameplayId = call.argument("gameplayId");
        int sceneId = call.argument("sceneId");
        HTProtect.registerTouchEvent(gameplayId, sceneId);
    }

    private void unregisterTouchEvent() {
        HTProtect.unregisterTouchEvent();
    }
}
