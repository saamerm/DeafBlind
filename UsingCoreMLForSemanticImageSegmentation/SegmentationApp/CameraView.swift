////
////  CameraView.swift
////  ImageSegmentationDETR
////
////  Created by Saamer Mansoor on 9/20/25.
////  Copyright © 2025 Apple. All rights reserved.
////
//
//import SwiftUI
//import AVFoundation
//
//struct CameraView: UIViewRepresentable {
//    class CameraPreview: UIView {
//        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
//        var previewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
//    }
//    
//    let session: AVCaptureSession
//    
//    func makeUIView(context: Context) -> CameraPreview {
//        let view = CameraPreview()
//        view.previewLayer.session = session
//        view.previewLayer.videoGravity = .resizeAspectFill
//        return view
//    }
//    
//    func updateUIView(_ uiView: CameraPreview, context: Context) {}
//}

import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
    
    var onFrameCaptured: (CMSampleBuffer) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        let captureSession = AVCaptureSession()
        
        // Find the back camera
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("Failed to get camera device.")
            return view
        }
        
        captureSession.addInput(input)
        
        // Setup video output to capture frames
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(videoOutput)

        // Add a preview layer
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // Store the session in the coordinator
        context.coordinator.captureSession = captureSession
        
        // Start the session on a background thread
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: CameraView
        var captureSession: AVCaptureSession?

        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            parent.onFrameCaptured(sampleBuffer)
        }
        
        deinit {
            captureSession?.stopRunning()
        }
    }
}
