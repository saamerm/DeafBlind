//
//  SmartView.swift
//  SeeHearBraille
//
//  Created by Saamer Mansoor on 9/21/25.
//  Copyright © 2025 Apple. All rights reserved.
//

import SwiftUI
import FoundationModels

struct SmartView: View {
    @Binding var text: [String]   // The array you want to store responses in
    @State private var isLoading = true
    @State var output = ""
    
    var body: some View {
        VStack(spacing: 20) {
            if isLoading {
                ProgressView("Generating story...")
            } else {
                Text(output)
            }
        }
        .padding()
        .onChange(of: text, {
            Task{
                print("text")
                print(text)
                await generateStory()
            }
        })
    }
    
    private func generateStory() async {
        do {
            if #available(iOS 26.0, *) {
                let options = GenerationOptions(temperature: 2.0)
                let session = LanguageModelSession()
                
                var prompt = "Write a short sentence describing what the user is seeing using these words that were scanned from their camera: "
                text.forEach { prompt.append(", \($0)") }
                let response = try await session.respond(
                    to: prompt,
                    options: options
                )
                print("response")
                print(response)

                // Update the bound text with the response
                await MainActor.run {
//                    text = [response.outputText] // assuming response has .outputText
                    output = response.content
                    isLoading = false
                }
            }
            else {
                // Fallback on earlier versions
            }

        } catch {
            await MainActor.run {
                text = ["Error: \(error.localizedDescription)"]
                isLoading = false
            }
        }
    }
}
