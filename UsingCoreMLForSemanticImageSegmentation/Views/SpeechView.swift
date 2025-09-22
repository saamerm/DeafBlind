////
////  SpeechView.swift
////  deafblind
////
////  Created by Saamer Mansoor on 9/20/25.
////
//
//import SwiftUI
//
//struct SpeechView: View {
//    // Create and own the SpeechRecognizer object
//    @StateObject private var speechRecognizer = SpeechRecognizer()
//    @State private var isRecording = false
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                
//                Text("Real-time Transcription")
//                    .font(.title)
//                
//                // Text view to display the transcribed text
//                Text(speechRecognizer.transcript)
//                    .padding()
//                    .frame(maxWidth: .infinity, minHeight: 150)
//                    .background(Color(.secondarySystemBackground))
//                    .cornerRadius(10)
//                
//                // Button to start/stop transcription
//                Button(action: {
//                    if isRecording {
//                        // Stop transcribing
//                        speechRecognizer.stopTranscribing()
//                    } else {
//                        // Start transcribing
//                        speechRecognizer.transcribe()
//                    }
//                    isRecording.toggle()
//                }) {
//                    Text(isRecording ? "Stop Transcribing" : "Start Transcribing")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(isRecording ? Color.red : Color.blue)
//                        .cornerRadius(10)
//                }
//                
//                Spacer()
//            }
//            .padding()
//            .navigationTitle("Scene Description").navigationBarTitleDisplayMode(.inline)
//            //        .navigationBarTitleTextColor(Color("SecondaryColor"))
//        }
//    }
//}
//#Preview {
//    SpeechView()
//}

import SwiftUI

struct SpeechView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    
    // New states
    @State private var usingBrailleKeyboard = false
    @State private var brailleKeyCount: String = ""
    @FocusState private var isTextFieldFocused : Bool
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Text("Real-time Transcription")
                        .font(.title)
                    
                    // Toggle for Braille keyboard
                    Toggle("Using Braille Keyboard?", isOn: $usingBrailleKeyboard)
                        .padding(.horizontal)
                    
                    if usingBrailleKeyboard {
                        // Ask for number of keys
                        HStack{
                            TextField("Enter number of keys", text: $brailleKeyCount)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                                .focused($isTextFieldFocused)
                            Button("Done"){
                                print("Do nothing")
                                isTextFieldFocused = false
                            }
                        }
                        // Show split transcript if number is valid
                        if let keyCount = Int(brailleKeyCount), keyCount > 0 {
                            BrailleTranscriptView(transcript: speechRecognizer.transcript, chunkSize: keyCount)
                                .padding(.horizontal)
                        } else {
                            Text("Please enter a valid number of keys")
                                .foregroundColor(.gray)
                        }
                    } else {
                        // Normal transcript display
                        Text(speechRecognizer.transcript)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 150)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    // Button to start/stop transcription
                    Button(action: {
                        if isRecording {
                            speechRecognizer.stopTranscribing()
                        } else {
                            speechRecognizer.transcribe()
                        }
                        isRecording.toggle()
                    }) {
                        Text(isRecording ? "Stop Transcribing" : "Start Transcribing")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isRecording ? Color.red : Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .padding(.vertical)
            .navigationTitle("Speech Converter")
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(.stack)
        }
    }
}

/// Splits transcript into chunks based on braille keyboard key count
struct BrailleTranscriptView: View {
    let transcript: String
    let chunkSize: Int
    
    private var chunks: [String] {
        stride(from: 0, to: transcript.count, by: chunkSize).map { start in
            let startIndex = transcript.index(transcript.startIndex, offsetBy: start)
            let endIndex = transcript.index(startIndex, offsetBy: chunkSize, limitedBy: transcript.endIndex) ?? transcript.endIndex
            return String(transcript[startIndex..<endIndex])
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(chunks.indices, id: \.self) { index in
                Text(chunks[index])
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .accessibilityElement(children: .combine) // Ensures VoiceOver reads each box separately
            }
        }
    }
}
