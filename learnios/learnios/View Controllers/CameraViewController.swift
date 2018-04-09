//
//  CameraViewController.swift
//  learnios
//
//  Created by Guanming Qiao on 4/8/18.
//

import UIKit
import AVFoundation

protocol CameraViewControllerDelegate : class {
    func cameraViewController(_ cameraViewController: CameraViewController, didTakePhoto image: UIImage)
}

class CameraViewController: UIViewController {
    @IBOutlet weak var cameraView: UIView!
    weak var delegate: CameraViewControllerDelegate?
    let captureSession = AVCaptureSession()
    var previewLayer:CALayer!
    var captureDevice: AVCaptureDevice!
    var shouldTakePhoto = false
    lazy var frontCamera: AVCaptureDevice? = {
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .front).devices.first
    }()
    lazy var backCamera: AVCaptureDevice? = {
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        prepareCamera()
    }
    
    @IBAction func takePhotoButtonTapped(_ sender: Any) {
        shouldTakePhoto = true
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func switchCameraButtonTapped(_ sender: Any) {
        captureSession.beginConfiguration()
        
        let currentCameraInput: AVCaptureInput = captureSession.inputs[0]
        captureSession.removeInput(currentCameraInput)
        
        if captureDevice == backCamera{
            guard let frontCamera = frontCamera else { return }
            captureDevice = frontCamera
            beginSession()
        } else {
            guard let backCamera = backCamera else { return }
            captureDevice = backCamera
            beginSession()
        }
        captureSession.commitConfiguration()
    }
    
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        guard let backCamera = backCamera
            else {
                noDevicesAvailable()
                return
        }
        captureDevice = backCamera
        beginSessionInitial()
    }
    
    func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            didNotCaptureDeviceInput()
            return
        }
    }
    
    func beginSessionInitial() {
        do {
            captureSession.addInput(try AVCaptureDeviceInput(device: captureDevice))
        } catch {
            didNotCaptureDeviceInput()
            return
        }
        setupPreviewLayer()
    }
    
    func setupPreviewLayer() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        previewLayer.frame = cameraView.frame
        self.view.layer.insertSublayer(previewLayer, at: 0)
            captureSession.startRunning()
            
            captureSession.beginConfiguration()
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value:kCVPixelFormatType_32BGRA)] as [String : Any]
            
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if captureSession.canAddOutput(dataOutput) {
                captureSession.addOutput(dataOutput)
            }
            
            captureSession.commitConfiguration()
            
            let queue = DispatchQueue(label: "captureQueue")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
        }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if shouldTakePhoto {
            shouldTakePhoto = false
            
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                DispatchQueue.main.async {
                    self.delegate?.cameraViewController(self, didTakePhoto: image)
                }
            }
        }
    }
    
    func stopCaptureSession() {
        self.captureSession.stopRunning()
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
    }
    
    func didNotCaptureDeviceInput() {
        let alertController = UIAlertController(title: "Something Went Wrong", message: "There was an issue with your device input. Please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.dismiss(animated: false, completion: nil)
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func noDevicesAvailable() {
        let alertController = UIAlertController(title: "Something Went Wrong", message: "We could not find any devices. Please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.dismiss(animated: false, completion: nil)
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func getImageFromSampleBuffer(buffer: CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        return nil
    }
}
