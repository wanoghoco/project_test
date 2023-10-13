# KYC_VERIFICATION

A new Flutter package for verifying BVN/NIN.


## IOS Requirements

update your ios/Runner/info.plist

```
<key>NSCameraUsageDescription</key>
<string>Allow Camera Permission</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Alllow photo library to store your captured image</string>


```

 ## Android Requirements
```
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA"/> 
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />

## Add this to make the app download mlkit while installing app on playstore
<application ...>
      ...
      <meta-data
          android:name="com.google.mlkit.vision.DEPENDENCIES"
          android:value="face" >
</application>
```
 


## Using


```dart
import 'package:raven_verification/app_data_helper.dart';
   
            VerificationPlugin.startPlugin(
                                context,
                                VerificationPlugin.getInstance(
          
                                    atlasUrl: "https://atlas.base_url.com",
                                    clientNumber: "client_bvn",
                                    baseColor: const Color(0xFF0B8376),
                                    metaData:
                                        "{meta data}",
                                    bearer: PUBLIC_KEY,
                                    onErrorMessage: (error) {},
                                    failiure: (data) {},
                                    success: (data) {}));
                                    


```


 

 
## Note
```
atlasUrl : atlasURL
clientBVN: client bvn is optional, the plugin also handles collection of BVN when it empty or not passed
baseColor: you can customimze the plugin to suite your app primaryColor
metaData: data sent back to your server
bearerToke: onboard on atlas to option your public key
onErrorMessage: callback for any error, all errors are sent via this callback and the plugin depends on the app toast to show errors via this callback
success: callback for on successful verification
failiure: callback when verificatio fails

```