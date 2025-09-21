//
//  VisionView.swift
//  deafblind
//
//  Created by Saamer Mansoor on 9/20/25.
//

import SwiftUI

struct VisionView: View {
    var body: some View {
        VStack {
            MLMainView()
            Text("Hello")
        }
        .navigationTitle("Speech Converter").navigationBarTitleDisplayMode(.inline)
//        .navigationBarTitleTextColor(Color("SecondaryColor"))
    }
}

#Preview {
    VisionView()
}
