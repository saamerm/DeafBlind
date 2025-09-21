//
//  CameraManager.swift
//  ImageSegmentationDETR
//
//  Created by Saamer Mansoor on 9/20/25.
//  Copyright © 2025 Apple. All rights reserved.
//

import AVFoundation
import SwiftUI

class CameraManager: ObservableObject {
    @Published var permissionGranted = false

    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                self?.permissionGranted = granted
            }
        }
    }
}
