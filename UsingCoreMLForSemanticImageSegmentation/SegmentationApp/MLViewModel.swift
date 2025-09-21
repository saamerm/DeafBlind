import Foundation
import SwiftUI
import CoreML
import AVFoundation // NEW: Import for camera frame handling

@MainActor
final class MLViewModel: ObservableObject {
    // MARK: - Model and Prediction Properties (from your original code)
    typealias Model = DETRResnet50SemanticSegmentationF16P8
    typealias ModelOutput = DETRResnet50SemanticSegmentationF16P8Output
    
    @Published private(set) var isModelLoaded = false
    @Published var results: [String] = []
    private var model: Model?
    @Published private var labelNames: [String] = []
    private var resultArray: MLShapedArray<Int32>?
    private var masks = [String: Image]()

    // The processed input image that the model uses.
    private var inputImage: UIImage?

    // MARK: - Published UI Properties
    
    /// The image from the camera feed, displayed in the UI.
    @Published private(set) var image: Image?

    /// The overlay image that masks a selected label.
    @Published private(set) var maskedImage: Image?

    /// A list of predicted labels in the original image.
    @Published private(set) var predictedLabels: [String] = []
    
    /// A potential error message to communicate to the user.
    @Published private(set) var errorMessage: String?

    /// The selected label, which triggers mask generation.
    @Published var selectedLabel: String? = nil {
        didSet {
            guard selectedLabel != nil else {
                maskedImage = nil
                return
            }
            // This triggers the renderMask() function via maskedImageForLabel
            generateMaskForSelectedLabel()
        }
    }
    
    // MARK: - NEW: Camera and Analysis Properties
    private var latestSampleBuffer: CMSampleBuffer?
    private let context = CIContext() // For converting camera frames efficiently

    // MARK: - Model Loading (Unchanged)
    nonisolated func loadModel() async {
        do {
            print("loadModel")
            let model = try Model()
            print("labels")
            let labels = model.model.segmentationLabels
            print("didLoadModel")
            await didLoadModel(model, labels: labels)
        } catch {
            Task { @MainActor in
                errorMessage = "The model failed to load: \(error.localizedDescription)"
            }
        }
    }
    
    private func didLoadModel(_ model: Model, labels: [String]) {
        self.labelNames = labels
        self.model = model
        print("isModelLoaded")
        print(isModelLoaded)
        isModelLoaded = true
    }
    
    // MARK: - NEW: Camera Frame Handling
    
    /// Called by the CameraView to provide the latest video frame.
    func storeLatestFrame(_ sampleBuffer: CMSampleBuffer) {
        self.latestSampleBuffer = sampleBuffer
    }

    /// Converts a CMSampleBuffer from the camera into a UIImage.
    private func uiImageFromSampleBuffer(_ sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let cvPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }

        let ciImage = CIImage(cvPixelBuffer: cvPixelBuffer).oriented(.right) // Adjust for portrait orientation
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }

    /// The main function triggered by the timer to perform analysis.
    func analyzeLatestFrame() async {
        guard let sampleBuffer = latestSampleBuffer, isModelLoaded else {
            print("Skipping analysis: buffer or model not ready.")
            return
        }
        
        // Convert the camera frame to a UIImage, which the model pipeline expects
        guard let frameImage = uiImageFromSampleBuffer(sampleBuffer) else {
            errorMessage = "Could not process camera frame."
            return
        }

        // Set this frame as the new input for the model
        handleNewInputImage(frameImage)
        
        // Run the prediction
        performInferenceAndUpdateUI()
    }
    
    /// Sets a new image and resets the state before inference.
    private func handleNewInputImage(_ uiImage: UIImage) {
        self.inputImage = uiImage
        self.image = Image(uiImage: uiImage) // Update the main display image
        self.maskedImage = nil
        self.errorMessage = nil
        self.masks = [:]
        self.predictedLabels = []
        self.selectedLabel = nil
    }

    // MARK: - Inference Logic (Adapted from your original code)
    
    private func performInferenceAndUpdateUI() {
        Task { @MainActor in
            do {
                print("Running prediction on new frame...")
                let predictionResult = try await performInference()
                try handlePredictionResult(predictionResult)

            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    private func handlePredictionResult(_ predictionResult: ModelOutput) throws {
        let newResultArray = predictionResult.semanticPredictionsShapedArray
        
        // Get unique label indices and map them to names
        let uniqueLabelIndices = newResultArray.uniqueValues
        let newPredictedLabels = uniqueLabelIndices.map({ labelNames[Int($0)] })
        
        // Update state only if the predictions have changed significantly
        // (This prevents the UI from flickering constantly if the view is stable)
        if Set(newPredictedLabels) != Set(self.predictedLabels) {
            print("Found new labels: \(newPredictedLabels)")
            self.resultArray = newResultArray
            
            self.predictedLabels = newPredictedLabels
            self.selectedLabel = nil // Reset selection when labels change
            self.masks = [:]
        }
    }

    /// Performs inference on the image-segmentation model.
    nonisolated func performInference() async throws -> ModelOutput {
        guard let model = await self.model else { throw ViewModelError.modelNotLoaded }
        guard let inputImage = await self.inputImage else { throw ViewModelError.noInputImage }

        // The resizing and pixel buffer creation logic from your original code
        let targetSize = CGSize(width: 448, height: 448)
        guard let cgImage = inputImage.cgImage else { throw ViewModelError.noInputImage }
        
        let ciImage = CIImage(cgImage: cgImage)
        let resizedImage = ciImage.resized(to: targetSize)
        
        let context = CIContext()
        guard let pixelBuffer = context.render(resizedImage, pixelFormat: kCVPixelFormatType_32ARGB) else {
            throw ViewModelError.fileFormatNotSupported
        }

        return try model.prediction(image: pixelBuffer)
    }

    // MARK: - Mask Generation (Adapted from your original code)

    private func generateMaskForSelectedLabel() {
        guard let selectedLabel = self.selectedLabel else {
            maskedImage = nil
            return
        }
        
        do {
            maskedImage = try maskedImageForLabel(selectedLabel)
        } catch {
            maskedImage = nil
            errorMessage = "Failed to render mask: \(error.localizedDescription)"
        }
    }
    
    private func maskedImageForLabel(_ selectedLabel: String) throws -> Image? {
        if let cachedMask = masks[selectedLabel] {
            return cachedMask
        }

        guard let cgImage = try renderMask() else { return nil }
        
        let uiImage = UIImage(
            cgImage: cgImage,
            scale: inputImage!.scale,
            orientation: .up // The mask is generated based on the already-oriented inputImage
        )
        let image = Image(uiImage: uiImage)
        masks[selectedLabel] = image
        return image
    }

    private func renderMask() throws -> CGImage? {
        guard let resultArray, let selectedLabel else { return nil }

        var bitmap = resultArray.scalars.map { labelIndex -> UInt32 in
            let label = self.labelNames[Int(labelIndex)]
            return label == selectedLabel ? 0xFF0000A0 : 0x00000000 // Red with Alpha, or Transparent
        }

        let width = resultArray.shape[1]
        let height = resultArray.shape[0]
        let image = bitmap.withUnsafeMutableBytes { bytes -> CGImage? in
            let context = CGContext(
                data: bytes.baseAddress,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: 4 * width,
                space: CGColorSpace(name: CGColorSpace.sRGB)!,
                bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue // ARGB
            )
            return context?.makeImage()
        }
        return image
    }

    // MARK: - Label Selection by Tapping (Unchanged)
    
    func selectLabel(at normalizedPosition: CGPoint) {
        selectedLabel = predictedLabel(at: normalizedPosition)
    }

    private func predictedLabel(at normalizedPosition: CGPoint) -> String? {
        guard let resultArray,
              normalizedPosition.x <= 1, normalizedPosition.y <= 1,
              normalizedPosition.x >= 0, normalizedPosition.y >= 0
        else {
            return nil
        }

        let col = Int((normalizedPosition.x * CGFloat(resultArray.shape[0] - 1)).rounded())
        let row = Int((normalizedPosition.y * CGFloat(resultArray.shape[1] - 1)).rounded())
        let labelIndex = resultArray[scalarAt: row, col]
        return labelNames[Int(labelIndex)]
    }
}

// MARK: - Error Handling (Unchanged)
private enum ViewModelError: Int, Error, LocalizedError {
    case modelNotLoaded = 1
    case noInputImage
    case fileFormatNotSupported

    var errorDescription: String? {
        switch self {
            case .modelNotLoaded: return "Model not loaded."
            case .noInputImage: return "No input image."
            case .fileFormatNotSupported: return "File format isn't supported."
        }
    }
}
