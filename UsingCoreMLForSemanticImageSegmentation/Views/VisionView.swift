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
            .navigationTitle("Scene Description")
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
                Spacer()
                if #available(iOS 26.0, *) {
                    SmartView(text: $text)
                } else {
                    ForEach(text, id: \.self){
                        Text($0)
                    }
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
