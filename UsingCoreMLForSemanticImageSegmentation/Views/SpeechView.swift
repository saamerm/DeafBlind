//
//  SpeechView.swift
//  deafblind
//
//  Created by Saamer Mansoor on 9/20/25.
//

import SwiftUI

struct SpeechView: View {
    // Create and own the SpeechRecognizer object
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Real-time Transcription")
                .font(.title)
            
            // Text view to display the transcribed text
            Text(speechRecognizer.transcript)
                .padding()
                .frame(maxWidth: .infinity, minHeight: 150)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            // Button to start/stop transcription
            Button(action: {
                if isRecording {
                    // Stop transcribing
                    speechRecognizer.stopTranscribing()
                } else {
                    // Start transcribing
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
            
            Spacer()
        }
        .padding()
        .navigationTitle("Scene Description").navigationBarTitleDisplayMode(.inline)
//        .navigationBarTitleTextColor(Color("SecondaryColor"))
    }
}
#Preview {
    SpeechView()
}
