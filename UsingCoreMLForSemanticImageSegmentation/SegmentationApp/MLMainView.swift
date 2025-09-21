//
//  MLMainView.swift
//  SeeHearBraille
//
//  Created by Saamer Mansoor on 9/20/25.
//  Copyright © 2025 Apple. All rights reserved.
//

import SwiftUI

struct MLMainView: View {
    
    @StateObject var viewModel = MLViewModel()
    @StateObject var cameraManager = CameraManager()
    
    // Timer to trigger analysis every 5 seconds
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    @State var overlaySize: CGSize = .zero
    var loadModel: Bool

    init(loadModel: Bool = true) {
        self.loadModel = loadModel
    }

    var body: some View {
        Group {
//            if cameraManager.permissionGranted {
                mainContentView
//            } else {
//                permissionView
//            }
        }
        .task {
            // Request permission and load the model on appear
            if loadModel {
                await viewModel.loadModel()
            }
            cameraManager.requestPermission()
        }
        // This receiver will fire every 5 seconds
        .onReceive(timer) { _ in
            Task {
                await viewModel.analyzeLatestFrame()
            }
        }
    }
    
    // The main UI when camera access is granted
    private var mainContentView: some View {
        VStack(spacing: 20) {
            ZStack {
                // The live camera feed is the base layer
                CameraView { sampleBuffer in
                    // Continuously update the view model with the latest frame
                    viewModel.storeLatestFrame(sampleBuffer)
                }
                .ignoresSafeArea()

                // The segmentation mask is layered on top
                if let maskImage = viewModel.maskedImage {
                    GeometryReader { bounds in
                        maskImage
                            .resizable()
                            .blendMode(.multiply) // Use blend mode to see through
                            .opacity(0.8)
                            .onTapGesture { location in
                                let normalizedPosition = CGPoint(
                                    x: min(max(location.x / overlaySize.width, 0), 1),
                                    y: min(max(location.y / overlaySize.height, 0), 1)
                                )
                                viewModel.selectLabel(at: normalizedPosition)
                            }
                            .onAppear {
                                overlaySize = bounds.size
                            }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if !viewModel.predictedLabels.isEmpty {
                Text("New analysis will run in 5 seconds.")
                    .font(.caption)
            }
            
            ScrollView {
                MLPredictedLabelsGridView(
                    predictedLabels: viewModel.predictedLabels,
                    selectedLabel: $viewModel.selectedLabel
                )
                .padding(8)
            }
            .frame(height: 150) // Give the scroll view a fixed height

            if !viewModel.isModelLoaded {
                ProgressView("Loading the AI model, this may take a few minutes but is only done once...")
            } else if viewModel.predictedLabels.isEmpty && viewModel.isModelLoaded {
                Text("Point the camera at an object to begin analysis.")
            }

            if let message = viewModel.errorMessage, !message.isEmpty {
                Text("Error: \(message)")
            }
        }
    }
    
    // A view to show when camera access is not yet granted
    private var permissionView: some View {
        VStack {
            Text("Camera Access Required")
                .font(.title)
                .padding()
            Text("Please grant camera access to allow the app to analyze objects in real-time.")
                .multilineTextAlignment(.center)
                .padding()
            Button("Grant Permission") {
                // This will open the app's settings
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .padding()
        }
    }
}


// The MLPredictedLabelsGridView and MLPredictedLabelGridCell views remain unchanged.
// I am including them here for completeness.

struct MLPredictedLabelsGridView: View {
    var predictedLabels: [String]
    @Binding var selectedLabel: String?

    var body: some View {
        LazyVGrid(
            columns: [.init(
                .adaptive(
                    minimum: MLPredictedLabelGridCell.cellWidth,
                    maximum: MLPredictedLabelGridCell.cellWidth
                )
            )]
        ) {
            ForEach(predictedLabels, id: \.self) { label in
                MLPredictedLabelGridCell(
                    predictedLabel: label,
                    isSelected: Binding<Bool>(
                        get: { label == self.selectedLabel },
                        set: {
                            if $0 { self.selectedLabel = label }
                        }
                    )
                )
            }
        }
    }
}

struct MLPredictedLabelGridCell: View {
    var predictedLabel: String
    @Binding var isSelected: Bool

    static let cellWidth = CGFloat(150)

    var body: some View {
        Text(predictedLabel)
            .padding()
            .frame(width: Self.cellWidth, height: Self.cellHeight)
            .background()
            .clipShape(.rect(cornerRadii: Self.cornerRadii))
            .overlay {
                RoundedRectangle(cornerRadius: Self.cornerRadius)
                    .fill(.clear)
                    .stroke(
                        isSelected ? Color.accentColor : Color.secondary,
                        lineWidth: isSelected ? 3 : 1
                    )
            }
            .onTapGesture {
                isSelected = true
            }
    }

    private static let cellHeight = CGFloat(50) // Reduced height for better layout
    private static let cornerRadius = CGFloat(10)
    private static let cornerRadii = RectangleCornerRadii(
        topLeading: cornerRadius,
        bottomLeading: cornerRadius,
        bottomTrailing: cornerRadius,
        topTrailing: cornerRadius
    )
}
