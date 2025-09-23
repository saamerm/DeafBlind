//
//  CameraViewModel.swift
//  SeeHearBraille
//
//  Created by Saamer Mansoor on 9/20/25.
//  Copyright © 2025 Apple. All rights reserved.
//

import AVFoundation

@MainActor
class CameraViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var predictedLabels: [String] = []
    
    private let session = AVCaptureSession()
    private var lastScanTime: Date = .distantPast
    
    override init() {
        super.init()
        setupCamera()
    }
    
    var captureSession: AVCaptureSession { session }
    
    private func setupCamera() {
        session.beginConfiguration()
        
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device)
        else { return }
        
        if session.canAddInput(input) { session.addInput(input) }
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))
        if session.canAddOutput(output) { session.addOutput(output) }
        
        session.commitConfiguration()
        session.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        let now = Date()
        guard now.timeIntervalSince(lastScanTime) > 5 else { return } // every 5s
        print("Here")
        lastScanTime = now
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        print("Past pixel buffer")
        Task { @MainActor in
            // Run your ML model here on pixelBuffer
            // Example: let labels = await analyze(pixelBuffer)
            let labels = ["Saamer", "Fadoua", "Ilyas"] // placeholder
            print("Past pixel buffer")
            self.predictedLabels = labels
        }
    }
}
