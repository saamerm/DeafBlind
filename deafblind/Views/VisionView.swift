//
//  VisionView.swift
//  deafblind
//
//  Created by Saamer Mansoor on 9/20/25.
//

import SwiftUI

struct VisionView: View {
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack {
                    BoxView()
                    Spacer()
//                    Text("Hello")
                }
            }
            .padding(1)
            .navigationTitle("Scene Description")
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(.stack)
        }
    }
}

struct BoxView: View {
    @State var text:[String] = []
    @State var displayText = ""
    var body: some View {
//        ScrollView{
            VStack {
                MLMainView(text: $text)
                Spacer()
//                if #available(iOS 26.0, *) {
//                    SmartView(text: $text)
//                } else {
//                    if text.contains("TV") || text.contains("laptop"){
                        Text(displayText)
                    .foregroundColor(.white) // make text white
                    .padding() // some spacing inside the box
                    .background(
                        Color.black.opacity(0.6) // semi-transparent black box
                    )
                    .cornerRadius(8) // optional rounded corners
//                        Text("The TV is showing: ")
//                        ForEach(text, id: \.self){
//                            Text($0)
//                        }
//                    }
//                }
//                Text("Hey")
            }
//        }
        .padding(1)
        .onChange(of: text, {
            // 1. Remove "tv" and "laptop"
            let filtered = text.filter { !["tv", "laptop"].contains($0.lowercased()) }

            // 2. Take only first 3 items
            let firstThree = Array(filtered.prefix(3))

            // 3. Format with commas and "and"
            let description: String
            switch firstThree.count {
            case 0:
                description = ""
            case 1:
                description = firstThree[0]
            case 2:
                description = firstThree.joined(separator: " and ")
            default:
                description = firstThree.dropLast().joined(separator: ", ") + ", and " + firstThree.last!
            }

            // 4. Final output
            displayText = "The TV is showing something with a \(description)"
        })
    }
}


#Preview {
    VisionView()
}
