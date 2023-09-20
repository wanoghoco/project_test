//
//  BvnView.swift
//  bvn_selfie
//
//  Created by Confidence Wangoho on 20/06/2023.
//

import Foundation
import Flutter
import AVFoundation
import MLKitFaceDetection
import MLKitVision

class BvnView:NSObject,FlutterPlatformView,AVCaptureVideoDataOutputSampleBufferDelegate
{
    let channel: FlutterMethodChannel
    private var messenger:FlutterBinaryMessenger;
    private var frame:CGRect;
    private var viewId:Int64;
    private var arguments:Any?;
    private let captureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    var backFacingCamera: AVCaptureDevice?
    var frontFacingCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice!
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var counter=0;
    var step=1;
    var sampleBuffer:Any?;
    let uiView=UIView()
    var canSnap=false;
    var unlocked=false;
    var running=false;
    var processStarted=false;
    let context = CIContext()
    var detector: CIDetector
    var takePhototoValue=false;
    
    let noFaceMap: [String: Any] = [
        "type": Helpers.NO_FACE_DETECTED
        // Add other key-value pairs as needed
    ]
    let faceMap: [String: Any] = [
        "type": Helpers.FACE_DETECTED
        // Add other key-value pairs as needed
    ]
    
    init(messenger: FlutterBinaryMessenger, frame: CGRect, viewId: Int64, arguments: Any? = nil) {
        self.messenger = messenger
        self.frame = frame
        self.viewId = viewId
      
        self.arguments = arguments
        self.channel = FlutterMethodChannel(name: "bvn_selfie", binaryMessenger: messenger)
        self.detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])!
        super.init()
        self.channel.setMethodCallHandler ({(call : FlutterMethodCall, result : @escaping FlutterResult)-> Void in
            
            if(call.method==Helpers.takePhoto){
                self.takePhoto()
            }
            if(call.method=="destroyer"){
                self.dispose();
            }
            result(true)
          
            
        })
        detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
    }
    
    
    func loadCamera(){
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.configureCamera()
        }
    }
    
    func view() -> UIView {
        loadCamera();
        return uiView;
    }
    
   private func configureCamera(){
       captureSession.sessionPreset = AVCaptureSession.Preset.photo
              if #available(iOS 11.1, *) {
                  guard let device = AVCaptureDevice.DiscoverySession(
                      deviceTypes: [.builtInDualCamera, .builtInTrueDepthCamera,.builtInWideAngleCamera],
                      mediaType: .video,
                      position: .front).devices.first else {
                      invokeErrorHandler(error: "No back camera device found, please make sure to run SimpleLaneDetection in an iOS device and not a simulator");
                      return;
                      
                  }
                  let cameraInput = try! AVCaptureDeviceInput(device: device)
                
                  self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
                             self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
                  self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
                   captureSession.addInput(cameraInput)
                  captureSession.addOutput(videoDataOutput)
                   cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    uiView.layer.addSublayer(cameraPreviewLayer!)
                   cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                   cameraPreviewLayer?.frame = uiView.layer.frame
                
                  DispatchQueue.global(qos: .userInitiated).async {
                           self.captureSession.startRunning()
                      let map: [String: Any] = [
                          "textureId": 0
                          // Add other key-value pairs as needed
                      ]

                       
                      self.channel.invokeMethod(Helpers.showCameraView, arguments:map)
                       }
              } else {
                  invokeErrorHandler(error: "Device Not Supported....")
                  return;
              }
        
    }
    
   public func dispose(){
        captureSession.stopRunning();
        
    }
    
    //capture delegete sends the output video buffers to MLKIT for processing
     func captureOutput(
            _ output: AVCaptureOutput,
            didOutput sampleBuffer: CMSampleBuffer,
            from connection: AVCaptureConnection) {
            guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                debugPrint("unable to get image from sample buffer")
                return
            }
             self.sampleBuffer=sampleBuffer;
             self.newDetectionFlow()
        }
    
    
    func newDetectionFlow(){
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(self.sampleBuffer as! CMSampleBuffer) else {
                return
                
            }
        let features = self.detector.features(in: CIImage(cvImageBuffer:pixelBuffer))
        if(features.isEmpty){
            
            self.unlocked=true
            if (!self.running && self.unlocked) {
                self.running = true
                let thread = Thread {
                    do {
                        Thread.sleep(forTimeInterval: 2)
                    } catch {
                        print(error)
                    }
                    
                    if self.unlocked {
                        DispatchQueue.main.async {
                            self.running = false
                            self.channel.invokeMethod(Helpers.facialGesture,arguments:self.noFaceMap);
                        }
                       
                    }else{
                        self.running = false
                    }
                }
                thread.start()
            }
        }
        else{
            self.unlocked=false;
            self.channel.invokeMethod(Helpers.facialGesture,arguments:self.faceMap);
        }
        for feature in features as! [CIFaceFeature] {
            //print(feature.mouthPosition)
            let value=isFaceCentered(faceFeature: feature, inFrame: self.frame);
            if(value>800&&value<1300){
                print("_________is center")
                checkLiveness(feature: feature)
            }
            else{
                print("leaving center")
            }
            
            
        }
    }
    
    func isFaceCentered(faceFeature: CIFaceFeature, inFrame frame: CGRect) -> CGFloat {
        // Calculate the center of the frame
        let frameCenter = CGPoint(x: frame.midX, y: frame.midY)
        
        // Calculate the center of the detected face
        let faceCenter = CGPoint(x: faceFeature.bounds.midX, y: faceFeature.bounds.midY)
        
        // Calculate the distance between the face center and the frame center
        let distance = sqrt(pow(frameCenter.x - faceCenter.x, 2) + pow(frameCenter.y - faceCenter.y, 2))
        
        // Check if the distance is within the defined tolerance
        
        return distance
    }
    
    private func checkLiveness(feature face: CIFaceFeature){
        if face.hasLeftEyePosition && face.hasRightEyePosition {
                            let leftEye = face.leftEyePosition
                            let rightEye = face.rightEyePosition
            if(counter<=3){
              self.invokeGesture(actionType:Helpers.ROTATE_HEAD);
            }
            else{
                self.invokeGesture(actionType:Helpers.SMILE_AND_OPEN_ACTION);
                
                let thread = Thread {
                    do {
                        Thread.sleep(forTimeInterval: 1.5)
                    } catch {
                        print(error)
                    }
                    
                    if(!self.running){
                        if(self.takePhototoValue){
                            return;
                        }
                        DispatchQueue.main.async {
                            self.takePhoto();
                            self.takePhototoValue=true;
                        }
                    }
                }
                thread.start()
               
                
            }
            if(face.hasFaceAngle){
                if(face.faceAngle<(-95)&&counter<=1){
                    counter+=1;
                    let actionMap: [String: Any] = [
                        "progress": counter
                    ]
                    self.channel.invokeMethod(Helpers.onProgressChange, arguments: actionMap);
                    return;
                }
                print(face.faceAngle)
                if(face.faceAngle<(-100)&&counter>=2&&counter<=3){
                    counter+=1;
                    let actionMap: [String: Any] = [
                        "progress": counter
                    ]
                    self.channel.invokeMethod(Helpers.onProgressChange, arguments: actionMap);
                    
                }
         
            }
             
        }
    }
    
    
    private func startDetection(didOutput sampleBuffer: CMSampleBuffer){
        let options = FaceDetectorOptions()
        options.performanceMode = .accurate
        options.landmarkMode = .all
        options.classificationMode = .all
       
        let visionImage = VisionImage(buffer: sampleBuffer)
        visionImage.orientation = imageOrientation(
            deviceOrientation: UIDeviceOrientation.portrait,
            cameraPosition: .front)
        
        let faceDetector = FaceDetector.faceDetector(options: options)
        weak var weakSelf = self
        faceDetector.process(visionImage) { faces, error in
          guard error == nil, let faces = faces, !faces.isEmpty else {
              self.unlocked=true
              if (!self.running && self.unlocked) {
                  self.running = true
                  let thread = Thread {
                      do {
                          Thread.sleep(forTimeInterval: 3)
                      } catch {
                          print(error)
                      }
                      
                      if self.unlocked {
                          DispatchQueue.main.async {
                              self.channel.invokeMethod(Helpers.facialGesture,arguments:self.noFaceMap);
                          }
                          self.running = false
                      }
                  }
                  thread.start()
              }
            return
          }
            self.unlocked=false
            self.channel.invokeMethod(Helpers.facialGesture,arguments:self.faceMap);
            self.sampleBuffer=sampleBuffer;
            self.processFacials(faces: faces,didOutput: sampleBuffer);
        }
    }
    
    
    private func processFacials(faces:[Face],didOutput sampleBuffer: CMSampleBuffer){

        for face in faces {
            let bounds = face.frame

                let faceWidth = bounds.width
                let faceHeight = bounds.height
                let screenWidth = UIScreen.main.bounds.width
                let screenHeight = UIScreen.main.bounds.height
                let normalizedWidth = faceWidth / screenWidth
               // let normalizedHeight = faceHeight / screenHeight

               // if normalizedWidth < 0.88 {
                 //    step = 1
               // channel.invokeMethod(Helpers.facialGesture, arguments: self.noFaceMap)
               // break
              //}
            
             //change the state of the gesture
            self.channel.invokeMethod(Helpers.facialGesture,arguments:self.faceMap);
             //detection steps 1
            
             if(step==1){
                 self.invokeGesture(actionType:Helpers.ROTATE_HEAD);
                 if(rotateHeadX(face: face)&&counter==0){
                     counter+=1;
                     let actionMap: [String: Any] = [
                         "progress": counter
                     ]
                     self.channel.invokeMethod(Helpers.onProgressChange, arguments: actionMap);
                     return;
                 }
                 if(rotateHeadY(face: face)&&counter==1){
                     counter+=1;
                     let actionMap: [String: Any] = [
                         "progress": counter
                     ]
                     self.channel.invokeMethod(Helpers.onProgressChange, arguments: actionMap);
                     return;
                 }
                 if(rotateHeadXNEG(face: face)&&counter==2){
                     counter+=1;
                     let actionMap: [String: Any] = [
                         "progress": counter
                     ]
                     self.channel.invokeMethod(Helpers.onProgressChange, arguments: actionMap);
                     return;
                 }
                 
                 if(rotateHeadYNEG(face: face)&&counter==3){
                     counter+=1;
                     let actionMap: [String: Any] = [
                         "progress": counter
                     ]
                     
                     self.channel.invokeMethod(Helpers.onProgressChange, arguments: actionMap);
                     self.invokeGesture(actionType:Helpers.SMILE_AND_OPEN_ACTION);
                     step=2;
                     return;
                 }
                 return;
             }
            if(self.canSnap){
                self.canSnap=false;
                takePhoto();
            }
            if(!processStarted){
              //  processStarted=true;
                let thread = Thread {
                    do {
                        Thread.sleep(forTimeInterval: 1.5)
                    } catch {
                        print(error)
                    }
                        DispatchQueue.main.async {
                            self.canSnap=true;
                            self.processStarted=true;
                        }
                        self.running = false
                
                }
                thread.start()
            }
            self.invokeGesture(actionType:Helpers.SMILE_AND_OPEN_ACTION);
            //if(checkSmileAndBlick(face: face)){
           //     if(step==2){
           //      step = -1;
              //      takePhoto(didOutput: sampleBuffer);
           //    }
           // }
           

         }

     }
    
    private func takePhoto(){
        let imageBuffer = CMSampleBufferGetImageBuffer(self.sampleBuffer as! CMSampleBuffer)!
        let ciimage = CIImage(cvPixelBuffer: imageBuffer)
        let image = self.convert(cmage: ciimage)
        let success = self.saveImage(image: image)
        if(!success.0){
            invokeErrorHandler(error: "something went wrong");
            return;
        }
        let imageMap: [String: Any] = [
            "imagePath": success.1
            // Add other key-value pairs as needed
        ]
        self.captureSession.stopRunning()
        channel.invokeMethod(Helpers.imageCapture,arguments:imageMap);
    }
    
    private func invokeGesture(actionType:Int){
        let actionMap: [String: Any] = [
            "action_type": actionType
        ]
        channel.invokeMethod(Helpers.actionGesutre,arguments:actionMap);
    }
    
    private func checkSmileAndBlick(face:Face)->Bool{

        if (face.hasSmilingProbability&&face.hasLeftEyeOpenProbability) {
                let smileProb = face.smilingProbability
           // let rightEyeOpenProb = face.rightEyeOpenProbability;
                if(smileProb>0.65){
                    return true;
                }
            }
            return false;
        }

    private func checkFrown(face:Face)->Bool{
         if (face.hasSmilingProbability) {
             let smileProb = face.smilingProbability;
                if(smileProb<0.75){
                    return true;
                }
            }
            return false;
        }

    private  func closeAndOpen(face:Face)->Bool{
        if (face.hasLeftEyeOpenProbability) {
            let leftEyeOpenProb = face.leftEyeOpenProbability;
                if(leftEyeOpenProb<0.85){
                    return true;
                }
            }
            return false;
        }

    private func rotateHeadX(face:Face)->Bool{
        if(face.hasHeadEulerAngleX){
            if (face.headEulerAngleX > 28) {
                   return true;
                }
                return false;
        }
        return false;
      }
 
    private func rotateHeadY(face:Face)->Bool{
        if(face.hasHeadEulerAngleY){
            if (face.headEulerAngleY > 25) {
                   return true;
                }
                return false;
        }
        return false;
      }
    
    
    
    
    private func rotateHeadXNEG(face:Face)->Bool{
        if(face.hasHeadEulerAngleX){
            if (face.headEulerAngleX < -1) {
                   return true;
                }
                return false;
        }
        return false;
      }

    
    private func rotateHeadYNEG(face:Face)->Bool{
        if(face.hasHeadEulerAngleY){
            if (face.headEulerAngleY < -1) {
                   return true;
                }
                return false;
        }
        return false;
      }
    


     
    
    func invokeErrorHandler(error:String){
        channel.invokeMethod("onError", arguments: ["error",error])
    }
    
    
    
    
 
    
    func imageOrientation(
      deviceOrientation: UIDeviceOrientation,
      cameraPosition: AVCaptureDevice.Position
    ) -> UIImage.Orientation {
      switch deviceOrientation {
      case .portrait:
        return cameraPosition == .front ? .leftMirrored : .right
      case .landscapeLeft:
        return cameraPosition == .front ? .downMirrored : .up
      case .portraitUpsideDown:
        return cameraPosition == .front ? .rightMirrored : .left
      case .landscapeRight:
        return cameraPosition == .front ? .upMirrored : .down
      case .faceDown, .faceUp, .unknown:
        return .up
      }
    }
    
    func convert(cmage: CIImage) -> UIImage {
         let context = CIContext(options: nil)
         let cgImage = context.createCGImage(cmage, from: cmage.extent)!
         let image = UIImage(cgImage: cgImage)
         return image
    }

    func saveImage(image: UIImage) -> (Bool, String) {
         self.clearTempFolder()
        var rotatedimage = image.rotate(radians: .pi/2)
         guard let data = rotatedimage.jpegData(compressionQuality: 1) ??
                rotatedimage.pngData() else {
             return (false, "")
         }

         guard let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
             return (false, "")
         }

         do {
             let dynamicFileName = "dynamicFile_\(Date().timeIntervalSince1970).jpeg"
             let fullPath = "\(directory)/"+dynamicFileName
             try data.write(to: URL.init(fileURLWithPath: fullPath))
             print("")
             print(fullPath)
             return (true, fullPath)
             
         } catch {
             print(error.localizedDescription)
             return (false, "")
         }
     }
    
   private func clearTempFolder() {
         let fileManager = FileManager.default
         let tempFolderPath = NSTemporaryDirectory()
         do {
             let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
             for filePath in filePaths {
                 try fileManager.removeItem(atPath: tempFolderPath + filePath)
             }
         } catch {
             print("Could not clear temp folder: \(error)")
         }
     }
    
     
}

 

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
    
    
}
 
