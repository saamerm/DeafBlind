//
//  IntroView.swift
//  deafblind
//
//  Created by Saamer Mansoor on 9/20/25.
//

import SwiftUI

struct IntroView: View {
    @AppStorage("DidShowIntroView") var isActive:Bool = false
    @Environment(\.openURL) var openURL
    @AppStorage("EmailAddress") var emailAddress = ""

    var body: some View {
        if self.isActive {
            // 3.
            MyTabView()
        }
        else{
            ZStack{
                Color("BrandColor")
                    .ignoresSafeArea()
                ScrollView{
                    VStack{
                        Image("logo")
                        Text("Welcome to SeeHearBraille")
                            .fontWeight(.bold)
                            .padding()
                            .font(Font.custom("Avenir", size: 18))
                            .foregroundColor(Color("SecondaryColor"))
                            .padding(.horizontal)
                        Text("""
SeeHearBraille helps you watch TV using your phone and a Bluetooth braille keyboard.
It uses your camera to tell you what channel you're watching.
It listens to the TV and sends the words to your braille keyboard.
You don’t need to see or hear—just touch and read.
""")
                        .font(Font.custom("Avenir", size: 16))
                        .foregroundColor(Color("SecondaryColor"))
                        .padding()

                        Text("\(Text(NSLocalizedString("By tapping Continue, you agree to our", comment: "By tapping Continue, you agree to our"))) \(Text("Privacy Policy").underline())")
                            .font(Font.custom("Avenir", size: 18))
                            .foregroundColor(Color("SecondaryColor"))
                            .padding(.horizontal)
                            .onTapGesture {
                                openURL(URL(string: "https://raw.githubusercontent.com/saamerm/DeafBlind/refs/heads/main/privacy-policy.html")!)
                            }
                        Button(
                            action: {
#if !os(macOS) || APPCLIP
                                simpleSuccessHaptic()
#endif
                                if emailAddress != ""{
                                    Task{
//                                                                                await uploadEmail(emailAddress: emailAddress)
                                    }
                                }
                                self.isActive = true
                            }
                        ){
                            Text("Continue")
                                .fontWeight(.semibold)
                                .font(Font.custom("Avenir", size: 18))
                                .frame(width: 190)
                                .padding()
                                .foregroundColor(Color("BrandColor"))
                                .background(Color("SecondaryColor"))
                            
                        }.cornerRadius(8)
                            .padding(.top, 30.0)
                    }
                    .padding(.top, 30.0)
                    .padding(.bottom, 30.0)
                }
            }
        }
    }
}

#Preview {
    IntroView()
}
func simpleSuccessHaptic() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
}

func uploadEmail(_ count: Int = 0, emailAddress: String) async{
    var locale: Locale = .current
    // locale.description has the format en_US
    let encoded = try? JSONEncoder().encode(Form(Email: emailAddress, Language: locale.description, Count: count))
    let url = URL(string: "{BASEURL}")!
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    do {
        try await URLSession.shared.upload(for: request, from: encoded!)
    } catch {
        print("Checkout failed.")
    }
}


struct Form: Codable {
    let Email: String
    let Language: String
    let Count: Int
}
