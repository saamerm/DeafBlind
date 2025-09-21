//
//  VisionView.swift
//  deafblind
//
//  Created by Saamer Mansoor on 9/20/25.
//

import SwiftUI

struct VisionView: View {
    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    BoxView()
                    Spacer()
//                    Text("Hello")
                }
            }
            .padding(1)
            .navigationTitle("Speech Converter")
            .navigationBarTitleDisplayMode(.inline)
            //        .navigationBarTitleTextColor(Color("SecondaryColor"))
        }
    }
}

struct BoxView: View {
    @State var text:[String] = []
    var body: some View {
//        ScrollView{
            VStack {
                MLMainView(text: $text)
                ForEach(text, id: \.self){
                    Text($0)
                }
//                Text("Hey")
            }
//        }
        .padding(1)
    }
}


#Preview {
    VisionView()
}
