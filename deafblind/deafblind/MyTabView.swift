//
//  MyTabView.swift
//  deafblind
//
//  Created by Saamer Mansoor on 9/20/25.
//
import SwiftUI

struct MyTabView: View {
    var body: some View {
        TabView {
            VisionView ()
                .tabItem {
                    // Using only Alert instead of NSLocalizedString("Alert", comment: "Alert Title"), doesn't work here
                    Label(NSLocalizedString("TV", comment: "TV page Title"), systemImage: "tv")
                }
            SpeechView()
                .tabItem {
                    Label(NSLocalizedString("Speech", comment: "Speech page Title"), systemImage: "waveform")
                }
        }
        .onAppear{
        }
    }
}

struct MyTabView_Previews: PreviewProvider {
    static var previews: some View {
        MyTabView()
    }
}
