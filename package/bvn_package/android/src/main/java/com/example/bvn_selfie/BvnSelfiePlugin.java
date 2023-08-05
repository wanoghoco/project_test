package com.example.bvn_selfie;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.graphics.SurfaceTexture;
import android.os.Build;
import android.view.Surface;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.view.TextureRegistry;


/** BvnSelfiePlugin */
public class BvnSelfiePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.RequestPermissionsResultListener,BVNCallbacks {
  private MethodChannel channel;
  private Activity flutterActivity;
  private SurfaceTexture surfaceTexture;
  private FlutterPluginBinding flutterBinding;
  VerificationService verificationService;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "bvn_selfie");
    flutterBinding=flutterPluginBinding;
    channel.setMethodCallHandler(this);
  }

  public  boolean checkPermissionStatus(){
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      if(flutterActivity.checkSelfPermission(Manifest.permission.CAMERA)== PackageManager.PERMISSION_DENIED||flutterActivity.checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE)== PackageManager.PERMISSION_DENIED){
        flutterActivity.requestPermissions(new String[]{Manifest.permission.CAMERA,Manifest.permission.READ_EXTERNAL_STORAGE,Manifest.permission.WRITE_EXTERNAL_STORAGE},1114);
        return false;
      }
      else{
       return true;
      }
    }
    return true;
  }

  @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("start_camera")) {
         result.success("good");
      if(checkPermissionStatus()){
        initializeService();
        return;
      }
      channel.invokeMethod("permission_not_accepted",new HashMap[]{});
      Toast.makeText(flutterActivity.getApplicationContext(),"Permission Not Granted... Please Accept Permission.",Toast.LENGTH_LONG).show();
      return;
    }
    if(call.method.equals(Helps.takePhoto)){
         if(surfaceTexture!=null){
            verificationService.takePhoto(); 
      }
    }
    if(call.method.equals("destroyer")){
      destroy();
      result.success("good");
      return;

    }
    else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
     flutterActivity= binding.getActivity();
    checkPermissionStatus();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
  }

  @Override
  public void onDetachedFromActivity() {
    destroy();
  }

  @Override
  public boolean onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
    if(requestCode==1114&&grantResults.length>0){
      for(int x=0; x<grantResults.length; x++){
        if(grantResults[x]!=PackageManager.PERMISSION_GRANTED){
          Toast.makeText(flutterActivity.getApplicationContext(),"Permission Not Yet Granted.",Toast.LENGTH_LONG).show();
          return false;
        }
      }
      initializeService();
      Toast.makeText(flutterActivity.getApplicationContext(),"Permission Granted.",Toast.LENGTH_LONG).show();
    }
    return false;
  }

 void  initializeService(){
    TextureRegistry.SurfaceTextureEntry entry=flutterBinding.getTextureRegistry().createSurfaceTexture();
    surfaceTexture=entry.surfaceTexture();
   verificationService= new VerificationService(flutterActivity,surfaceTexture,this,entry.id());
  }

  private void destroy(){
    if(surfaceTexture!=null){
      verificationService.dispose();

      surfaceTexture.release();
    }
  }

  @Override
  public void onTextTureCreated(String val,long textureId) {
    HashMap<String, Object> hashMap = new HashMap<>();
    hashMap.put("textureId",  textureId);
   channel.invokeMethod("showTextureView",hashMap);
  }

  @Override
  public void gestureCallBack(String methodName, int id) {
    HashMap<String, Object> hashMap = new HashMap<>();
    hashMap.put("type",  id);
    channel.invokeMethod(methodName,hashMap);
  }

  @Override
  public void actionCallBack(int action) {
    HashMap<String, Object> hashMap = new HashMap<>();
    hashMap.put("action_type",  action);
    channel.invokeMethod(Helps.actionGesutre,hashMap);
  }

  @Override
  public void onImageCapture(String imagePath) {
      flutterActivity.runOnUiThread(new Runnable() {
          @Override
          public void run() {
              HashMap<String, Object> hashMap = new HashMap<>();
              hashMap.put("imagePath",  imagePath);
              channel.invokeMethod(Helps.imageCapture,hashMap);
          }
      });

  }

  @Override
  public void onError(String error) {

      flutterActivity.runOnUiThread(new Runnable() {
          @Override
          public void run() {
              HashMap<String, Object> hashMap = new HashMap<>();
              hashMap.put("error",  error);
              channel.invokeMethod(Helps.onError,hashMap);
          }
      });

  }
}
