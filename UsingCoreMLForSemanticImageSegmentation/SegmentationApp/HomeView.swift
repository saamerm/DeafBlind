//
//  HomeView.swift
//  ImageSegmentationDETR
//
//  Created by Saamer Mansoor on 9/20/25.
//  Copyright © 2025 Apple. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = CameraViewModel()
    
    var body: some View {
        VStack {
            // Throws an error
//            CameraView(session: viewModel.captureSession)
//                .frame(height: 400)
//                .cornerRadius(12)
//                .padding()
            
            if viewModel.predictedLabels.isEmpty {
                Text("Point camera at something...")
            } else {
                PredictedLabelsGridView(
                    predictedLabels: viewModel.predictedLabels,
                    selectedLabel: .constant(nil)
                )
                .padding()
            }
        }
    }
}
