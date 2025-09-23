# SeeHearBraille - Accessibility App for Deaf-Blind Users

SeeHearBraille is an innovative iOS application designed to help deaf-blind users watch TV using their phone and a Bluetooth braille keyboard. The app combines computer vision, speech recognition, and AI to provide real-time descriptions of visual content and audio transcriptions.

## 🎯 Purpose

This app addresses the unique needs of deaf-blind individuals by:
- Using the phone's camera to identify what's on TV
- Listening to TV audio and converting speech to text
- Providing braille-friendly text output for external braille keyboards
- Offering AI-powered scene descriptions

## ✨ Features

### 🎥 Computer Vision & AI Analysis
- **Real-time Object Detection**: Uses Core ML with DETR (Detection Transformer) model for semantic image segmentation
- **Live Camera Feed**: Continuous analysis of camera input every 5 seconds
- **Object Recognition**: Identifies and labels objects, people, and scenes in real-time
- **Interactive Masking**: Tap on detected objects to highlight them with visual overlays

### 🎤 Speech Recognition
- **Real-time Transcription**: Converts TV audio to text using Apple's Speech framework
- **Braille Keyboard Support**: Splits transcript text into chunks based on braille keyboard key count
- **Continuous Listening**: Background audio processing for seamless experience

### 📺 Channel Finder
- **Location-Based Lookup**: Find TV channels by state and city
- **Category Filtering**: Browse channels by News, Sports, Kids, or Education
- **Channel Numbers**: Get exact channel numbers for your TV remote
- **Accessibility**: VoiceOver-friendly interface for easy navigation

### ♿ Accessibility Features
- **VoiceOver Compatible**: Full accessibility support for screen readers
- **Braille Integration**: Designed for external braille keyboard connectivity
- **Haptic Feedback**: Tactile responses for user interactions
- **Customizable Text Chunking**: Configurable text splitting for different braille devices

## 🏗️ Project Structure

The project contains the main SeeHearBraille application:

### Main App (`deafblind/`)
- **Entry Point**: `SegmentationApp.swift` - Main app entry point with `IntroView`
- **Welcome Screen**: `IntroView` - Privacy policy agreement and app introduction
- **Main Interface**: `MyTabView` - Tab-based navigation with three main features
- **Core Features**:
  - **Speech Converter** (`SpeechView`) - Real-time speech recognition and braille text output
  - **Scene Description** (`VisionView`) - Camera-based object detection and AI scene analysis
  - **Channel Finder** (`ChannelView`) - TV channel lookup by location and category

### Legacy Code (`deafblind/`)
- **Note**: This folder contains an earlier attempt at the app and is not the current implementation
- **Status**: Deprecated - kept for reference only

## 📋 Requirements

### System Requirements
- **iOS**: 16.0 or later
- **Device**: iPhone with camera and microphone
- **Storage**: ~500MB for ML model and app data

### Permissions Required
- **Camera Access**: For object detection and scene analysis
- **Microphone Access**: For speech recognition
- **Speech Recognition**: For converting audio to text

### Hardware Requirements
- **Camera**: Back-facing camera for object detection
- **Microphone**: Built-in microphone for audio capture
- **Bluetooth**: For braille keyboard connectivity (optional)

## 🚀 Installation

### Prerequisites
1. **Xcode**: Version 16.3 or later
2. **macOS**: Latest version recommended
3. **Apple Developer Account**: For device testing and App Store distribution

### Setup Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/saamerm/DeafBlind.git
   cd DeafBlind
   ```

2. **Open in Xcode**
   ```bash
   # Open the main SeeHearBraille app
   open deafblind/SeeHearBraille.xcodeproj
   ```

3. **Configure Project Settings**
   - Select your development team in Xcode
   - Update bundle identifier if needed
   - Configure signing certificates

4. **Build and Run**
   - Select target device (iPhone or iPad recommended)
   - Press `Cmd + R` to build and run

### First-Time Setup
1. **Grant Permissions**: Allow camera and microphone access when prompted
2. **Privacy Policy**: Accept the privacy policy on first launch
3. **Model Download**: The AI model will download automatically (one-time process)

## 🎮 Usage Guide

### Getting Started
1. **Launch the App**: Open SeeHearBraille on your device
2. **Accept Privacy Policy**: Review and accept the privacy policy
3. **Grant Permissions**: Allow camera and microphone access

### Using Vision Features (Scene Description)
1. **Navigate to Scene Description Tab**: Tap the "Scene Description" tab
2. **Point Camera**: Aim your phone's camera at the TV screen or scene
3. **Wait for Analysis**: The app analyzes the scene every 5 seconds using Core ML
4. **View Results**: See detected objects and AI-generated scene descriptions
5. **Read Description**: View natural language descriptions like "The TV is showing something with a person, chair, and table"

### Using Speech Features (Speech Converter)
1. **Navigate to Speech Converter Tab**: Tap the "Speech Converter" tab
2. **Configure Braille Keyboard**: Toggle braille keyboard support if using one
3. **Set Key Count**: Enter the number of keys on your braille device
4. **Start Transcription**: Tap "Start Transcribing" to begin real-time speech recognition
5. **View Text**: See real-time transcript or braille-formatted chunks

### Using Channel Finder
1. **Navigate to Channel Finder Tab**: Tap the "Channel Finder" tab
2. **Select Location**: Choose your state and city from the pickers
3. **Choose Category**: Select News, Sports, Kids, or Education
4. **Find Channels**: View available TV channels with their numbers
5. **Use Remote**: Use the channel numbers to navigate with your TV remote

### Braille Keyboard Integration
1. **Enable Braille Mode**: Toggle "Using Braille Keyboard?" to ON
2. **Enter Key Count**: Specify the number of keys on your device
3. **Connect Device**: Pair your Bluetooth braille keyboard
4. **Receive Text**: Text will be split into appropriate chunks for your device

## 🔧 Technical Details

### Core Technologies
- **SwiftUI**: Modern iOS user interface framework
- **Core ML**: Machine learning framework for on-device inference
- **AVFoundation**: Camera and audio processing
- **Speech Framework**: Real-time speech recognition
- **Foundation Models**: AI-powered text generation (iOS 26+)

### ML Model
- **Model**: DETR ResNet50 Semantic Segmentation F16P8
- **Input**: 448x448 RGB images
- **Output**: Semantic segmentation masks with object labels
- **Performance**: Optimized for mobile inference

### Architecture
- **MVVM Pattern**: Model-View-ViewModel architecture
- **Async/Await**: Modern Swift concurrency
- **Combine**: Reactive programming for UI updates
- **Core Data**: Local data persistence (if implemented)

## 🛠️ Development

### Project Configuration
- **Deployment Target**: iOS 16.0
- **Swift Version**: 5.9+
- **Xcode Version**: 16.3+

### Key Files
- `SegmentationApp.swift`: Main app entry point
- `IntroView.swift`: Welcome screen and privacy policy
- `MyTabView.swift`: Main navigation interface with three tabs
- `SpeechView.swift`: Speech recognition and braille text output
- `VisionView.swift`: Camera-based scene analysis interface
- `ChannelView.swift`: TV channel lookup functionality
- `MLViewModel.swift`: Core ML processing logic
- `SpeechRecognizer.swift`: Audio transcription handling
- `MLMainView.swift`: Advanced ML camera interface

### Building for Different Targets
```bash
# Debug build
xcodebuild -project SeeHearBraille.xcodeproj -scheme SegmentationApp -configuration Debug

# Release build
xcodebuild -project SeeHearBraille.xcodeproj -scheme SegmentationApp -configuration Release
```

## 🔒 Privacy & Security

### Data Handling
- **On-Device Processing**: All ML inference happens locally
- **No Data Collection**: No personal data is transmitted
- **Privacy Policy**: Available at the provided GitHub URL
- **Permissions**: Minimal required permissions only

### Security Features
- **App Sandbox**: Enabled for security isolation
- **Secure Storage**: Local data encryption
- **Permission Management**: Granular permission controls

## 🤝 Contributing

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Code Style
- Follow Swift API Design Guidelines
- Use SwiftUI best practices
- Maintain accessibility compliance
- Include proper documentation

## 📄 License

This project is licensed under the terms specified in the LICENSE file.

## 🆘 Support

### Common Issues
- **Camera Not Working**: Check permissions in Settings > Privacy & Security
- **Speech Recognition Failing**: Ensure microphone access is granted
- **ML Model Loading**: Ensure stable internet connection for initial download
- **Braille Keyboard**: Verify Bluetooth pairing and key count configuration

### Getting Help
- **Issues**: Report bugs via GitHub Issues
- **Documentation**: Check Apple's Core ML and Speech framework docs
- **Accessibility**: Refer to Apple's Accessibility Guidelines

## 🔮 Future Enhancements

### Planned Features
- **Custom ML Models**: Support for user-trained models
- **Offline Mode**: Complete offline functionality
- **Multi-language Support**: Internationalization
- **Advanced Braille Support**: More braille device compatibility
- **Voice Commands**: Hands-free operation
- **Cloud Sync**: Settings synchronization across devices

### Technical Improvements
- **Performance Optimization**: Faster inference times
- **Battery Efficiency**: Reduced power consumption
- **Error Handling**: Improved error recovery
- **User Customization**: More personalization options

## 📞 Contact

For questions, suggestions, or support:
- **Developer**: Saamer Mansoor, Kyle Peterson, Hitesh Parikh
- **Repository**: [GitHub Repository](https://github.com/saamerm/DeafBlind)
- **Privacy Policy**: Available in the repository

## 🔗 Submission Links

- Captioned 60 second Ad video URL: https://www.youtube.com/watch?v=qRN_nitff10
- Captioned 5 minute pitch video URL: [ https://youtu.be/rSBIvyGcbB8](https://www.youtube.com/watch?v=rSBlvyGcbB8),
- Live URL: Waiting for approval from Apple. It's restrictive because they try to ensure safety. Will update the GitHub repo readme once it does get approved
- Pitch Deck: https://docs.google.com/presentation/d/1cZAG-1_gR2UqXI0AKpZboyzmZUgIYYkD
- Responsible AI Disclosure: https://docs.google.com/document/d/1-jSgq9VlbfORuwyGApSwcMOnsKp7N47-gs3_D6NO6Lo
- Project Write-up: https://docs.google.com/document/d/1Inr0gsbQ3PZqHula0KA9lGZx2cskXVQitYTgjnJocrg

---

**Note**: This app is designed specifically for deaf-blind users and requires more testing with accessibility tools. Always test with real users to ensure proper functionality.
