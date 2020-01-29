//
//  ViewController.swift
//  Practice2
//
//  Created by SeEun Kwon on 2020/01/28.
//  Copyright © 2020 Kabu. All rights reserved.
//

// TODO: enable picked image be turned as wished; auto resizing of the view screen;
//camera rotatoin horizontal/landscape both; preview of the image taken; let the image be saved back in the album; Train and change the model

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let applyHED = HED()
    
    @IBOutlet weak var cameraView: UIView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    var backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    
    var imagePicker = UIImagePickerController()

    @IBOutlet weak var imageVeiw: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.2, *)
        {
            let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera ,for: .video, position: .back)
            do
            {
                let input = try AVCaptureDeviceInput(device: captureDevice!)
                captureSession = AVCaptureSession()
                captureSession?.addInput(input)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer?.frame = view.layer.bounds
                cameraView.layer.addSublayer(videoPreviewLayer!)
                captureSession?.startRunning()
                
            }
            catch{
                print("error")
            }
        }
        imagePicker.delegate = self
        
        
    }
    
    @IBAction func imageCapture(_ sender: Any) {
    }
    
    func switchToFrontCamera()
    {
        if frontCamera?.isConnected == true
        {
            captureSession?.stopRunning()
            let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera ,for: .video, position: .front)
            do
            {
                let input = try AVCaptureDeviceInput(device: captureDevice!)
                captureSession = AVCaptureSession()
                captureSession?.addInput(input)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer?.frame = view.layer.bounds
                cameraView.layer.addSublayer(videoPreviewLayer!)
                captureSession?.startRunning()
                
            }
            catch{
                print("error")
            }
        }
    }
    
    func switchToBackCamera()
    {
        if backCamera?.isConnected == true
        {
            captureSession?.stopRunning()
            let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera ,for: .video, position: .back)
            do
            {
                let input = try AVCaptureDeviceInput(device: captureDevice!)
                captureSession = AVCaptureSession()
                captureSession?.addInput(input)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer?.frame = view.layer.bounds
                cameraView.layer.addSublayer(videoPreviewLayer!)
                captureSession?.startRunning()
                
            }
            catch{
                print("error")
            }
        }
    }

    
    
    @IBAction func onClickPickImage(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let albumImage = info[UIImagePickerController.InfoKey.editedImage]
        let transformedImage = applyHED.doInference(inputImage: albumImage as! UIImage)
        let beginImage = CIImage(image: transformedImage)
        let filter = CIFilter(name: "CIMaskToAlpha")
        filter?.setValue(beginImage, forKey: kCIInputImageKey)
        let middleImage = filter?.outputImage
        if let filter = CIFilter(name: "CIColorInvert"){
            filter.setValue(middleImage, forKey: kCIInputImageKey)
            let newImage = UIImage(ciImage: filter.outputImage!)
            imageVeiw!.image = newImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    
}

