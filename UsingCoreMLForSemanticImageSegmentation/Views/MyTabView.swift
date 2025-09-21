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
            MLMainView ()
                .tabItem {
                    // Using only Alert instead of NSLocalizedString("Alert", comment: "Alert Title"), doesn't work here
                    Label(NSLocalizedString("Scene Description", comment: "TV page Title"), systemImage: "tv")
                }
            SpeechView()
                .tabItem {
                    Label(NSLocalizedString("Speech Converter", comment: "Speech page Title"), systemImage: "waveform")
                }
            ChannelView()
                .tabItem {
                    Label(NSLocalizedString("Channel Finder", comment: "Channel Finder page Title"), systemImage: "magnifyingglass")
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
