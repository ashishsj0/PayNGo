//
//  ScannerViewController.swift
//  PAY & GO
//
//  Created by Ashish sharma on 07/02/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView
{
    override class var layerClass: AnyClass
        {
        get
        {
            return AVCaptureVideoPreviewLayer.self
        }
    }
    override var layer: AVCaptureVideoPreviewLayer
        {
        get {
            return super.layer as! AVCaptureVideoPreviewLayer
        }
    }
}

class ScannerViewController: UIViewController {

    var urls = ["https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/09/12/11/naturo-monkey-selfie.jpg?w968h681","https://images-na.ssl-images-amazon.com/images/I/711ZogAqAbL._SY679_.jpg", "https://images-na.ssl-images-amazon.com/images/I/61YVj11dRFL._SX355_.jpg"]
    
    var manager: CoreDataManager?
    
    var cameraView: CameraView!
    
    let session = AVCaptureSession()
    let sessionQueue = DispatchQueue(label: AVCaptureSession.self.description(), attributes: [], target: nil)
 
    override func loadView() {
        cameraView = CameraView()
        view = cameraView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CoreDataManager.sharedManager
        
       self.setupConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sessionQueue.async {
            self.session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sessionQueue.async {
            self.session.stopRunning()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.setupOrintation()
    }
    
}


//MARK: Handling captured output

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let scannedObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            
            self.session.stopRunning()
            
            let randomInt = Int.random(in: 0..<3)
            
            let product = Product.init(productCode: scannedObject.stringValue ?? "nil", productName: "Product name", productImage: self.urls[randomInt], productPrice: 44)
            
            manager?.insertProduct(product: product)
            
            self.presentAlert(withStr: "Code Scanned:  \(scannedObject.stringValue ?? "")",shouldVibrate: true) { comp in
                
                if comp {
                    self.session.startRunning() }
            }
            
        }}
    
    func addProductToCart(withScannedCode code: String) {
        
        
    }
}


//MARK: Internal setup for scanning

extension ScannerViewController {
    
    // setting up input output medias.
    
    func setupConfiguration() {
        
        session.beginConfiguration()
        if let videoDevice = AVCaptureDevice.default(for: .video) {
            if let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) {
                if (session.canAddInput(videoDeviceInput)) {
                    session.addInput(videoDeviceInput)
                }}
            let metadataOutput = AVCaptureMetadataOutput()
            if (session.canAddOutput(metadataOutput)) {
                session.addOutput(metadataOutput)
                metadataOutput.metadataObjectTypes = [.ean8, .ean13, .code39, .code39Mod43, .qr
                ]
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            }
        }
        session.commitConfiguration()
        cameraView.layer.session = session
        cameraView.layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.setupOrintation()
    }
    
    // handling orientation changes in the camera / device
    
    func setupOrintation() {
        let videoOrientation: AVCaptureVideoOrientation
        switch UIDevice.current.orientation {
        case .portrait:
            videoOrientation = .portrait
        case .portraitUpsideDown:
            videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            videoOrientation = .landscapeRight
        case .landscapeRight:
            videoOrientation = .landscapeLeft
        default:
            videoOrientation = .portrait
        }
        cameraView.layer.connection?.videoOrientation = videoOrientation
    } }
