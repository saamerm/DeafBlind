//
//  ChannelView.swift
//  SeeHearBraille
//
//  Created by Saamer Mansoor on 9/21/25.
//  Copyright © 2025 Apple. All rights reserved.
//
import SwiftUI

struct ChannelView: View {
    @State private var selectedState: String = "Michigan"
    @State private var selectedCity: String = "Detroit"
    @State private var selectedCategory: String = "News"
    
    private let states = [     "Alabama",     "Alaska",     "Arizona",     "Arkansas",     "California",     "Colorado",     "Connecticut",     "Delaware",     "Florida",     "Georgia",     "Hawaii",     "Idaho",     "Illinois",     "Indiana",     "Iowa",     "Kansas",     "Kentucky",     "Louisiana",     "Maine",     "Maryland",     "Massachusetts",     "Michigan",     "Minnesota",     "Mississippi",     "Missouri",     "Montana",     "Nebraska",     "Nevada",     "New Hampshire",     "New Jersey",     "New Mexico",     "New York",     "North Carolina",     "North Dakota",     "Ohio",     "Oklahoma",     "Oregon",     "Pennsylvania",     "Rhode Island",     "South Carolina",     "South Dakota",     "Tennessee",     "Texas",     "Utah",     "Vermont",     "Virginia",     "Washington",     "West Virginia",     "Wisconsin",     "Wyoming" ]
    private let categories = ["News", "Sports", "Kids", "Education"]
    
    var availableCities: [String] {
        michiganChannels
            .filter { $0.state == selectedState }
            .map { $0.city }
    }
    
    var filteredChannels: [Channel] {
        guard let cityChannels = michiganChannels.first(where: { $0.city == selectedCity }) else {
            return []
        }
        return cityChannels.channels.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                Text("Choose your State, City & Channel Category to find what numbers to press on your remote")
                // State picker
                Picker("State", selection: $selectedState) {
                    ForEach(states, id: \.self) { Text($0) }
                }
                .pickerStyle(.automatic)
                
                // City picker
                Picker("City", selection: $selectedCity) {
                    ForEach(availableCities, id: \.self) { Text($0) }
                }
                .pickerStyle(.wheel)
                
                // Category picker
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { Text($0) }
                }
                .pickerStyle(.segmented)
                
                Divider()
                
                // Results
                if filteredChannels.isEmpty {
                    Text("No channels found.").foregroundColor(.secondary)
                } else {
                    List(filteredChannels) { channel in
                        HStack {
                            Text("\(channel.network) (\(channel.callSign))")
                                .font(.headline)
                            Spacer()
                            Text("Channel \(channel.number)")
                                .bold()
                                .font(.title3)
                                .accessibilityLabel("Channel number \(channel.number)")
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .padding()
            .navigationTitle("Channel Finder")
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(.stack)
        }
    }
}


struct Channel: Identifiable {
    let id = UUID()
    let network: String   // "CBS", "NBC", "ABC"
    let callSign: String  // "WWJ", "WOOD", etc.
    let number: String    // "62", "3", etc.
    let category: String  // "News", "Sports", "Kids", etc.
}

struct CityChannels {
    let state: String
    let city: String
    let channels: [Channel]
}

let michiganChannels: [CityChannels] = [
    // --- Detroit ---
    CityChannels(
        state: "Michigan",
        city: "Detroit",
        channels: [
            Channel(network: "CBS", callSign: "WWJ", number: "62", category: "News"),
            Channel(network: "NBC", callSign: "WDIV", number: "4", category: "News"),
            Channel(network: "ABC", callSign: "WXYZ", number: "7", category: "News"),
            Channel(network: "FOX", callSign: "WJBK", number: "2", category: "News"),
            Channel(network: "PBS", callSign: "WTVS", number: "56", category: "Education")
        ]
    ),
    
    // --- Grand Rapids / Kalamazoo / Battle Creek ---
    CityChannels(
        state: "Michigan",
        city: "Grand Rapids / Kalamazoo / Battle Creek",
        channels: [
            Channel(network: "CBS", callSign: "WWMT", number: "3", category: "News"),
            Channel(network: "NBC", callSign: "WOOD", number: "8", category: "News"),
            Channel(network: "ABC", callSign: "WZZM", number: "13", category: "News"),
            Channel(network: "FOX", callSign: "WXMI", number: "17", category: "News"),
            Channel(network: "PBS", callSign: "WGVU", number: "35", category: "Education")
        ]
    ),
    
    // --- Lansing / Jackson ---
    CityChannels(
        state: "Michigan",
        city: "Lansing / Jackson",
        channels: [
            Channel(network: "CBS", callSign: "WLNS", number: "6", category: "News"),
            Channel(network: "NBC", callSign: "WILX", number: "10", category: "News"),
            Channel(network: "ABC", callSign: "WLAJ", number: "53", category: "News"),
            Channel(network: "FOX", callSign: "WSYM", number: "47", category: "News"),
            Channel(network: "PBS", callSign: "WKAR", number: "23", category: "Education")
        ]
    ),
    
    // --- Flint / Saginaw / Bay City (Tri-Cities) ---
    CityChannels(
        state: "Michigan",
        city: "Flint / Saginaw / Bay City",
        channels: [
            Channel(network: "CBS", callSign: "WNEM", number: "5", category: "News"),
            Channel(network: "NBC", callSign: "WEYI", number: "25", category: "News"),
            Channel(network: "ABC", callSign: "WJRT", number: "12", category: "News"),
            Channel(network: "FOX", callSign: "WSMH", number: "66", category: "News"),
            Channel(network: "PBS", callSign: "WDCQ", number: "19", category: "Education")
        ]
    ),
    
    // --- Traverse City / Cadillac / Alpena (Northern MI) ---
    CityChannels(
        state: "Michigan",
        city: "Traverse City / Cadillac / Alpena",
        channels: [
            Channel(network: "CBS", callSign: "WWTV", number: "9", category: "News"),
            Channel(network: "NBC", callSign: "WPBN", number: "7", category: "News"),
            Channel(network: "ABC", callSign: "WGTU", number: "29", category: "News"),
            Channel(network: "ABC", callSign: "WBKB", number: "11", category: "News"), // Alpena-specific
            Channel(network: "FOX", callSign: "WFQX", number: "33", category: "News"),
            Channel(network: "PBS", callSign: "WCMU", number: "26", category: "Education")
        ]
    ),
    
    // --- Upper Peninsula (Marquette / Escanaba / Houghton) ---
    CityChannels(
        state: "Michigan",
        city: "Upper Peninsula (Marquette / Escanaba / Houghton)",
        channels: [
            Channel(network: "CBS", callSign: "WJMN", number: "3", category: "News"),
            Channel(network: "NBC", callSign: "WLUC", number: "6", category: "News"),
            Channel(network: "ABC", callSign: "WBUP", number: "10", category: "News"),
            Channel(network: "FOX", callSign: "WBKP", number: "5", category: "News"), // FOX carried on WBKP subchannel
            Channel(network: "PBS", callSign: "WNMU", number: "13", category: "Education")
        ]
    )
]
