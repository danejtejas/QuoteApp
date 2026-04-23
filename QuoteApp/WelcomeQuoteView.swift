//
//  WelcomeQuoteView.swift
//  QuoteApp
//
//  Created by Tejas on 18/04/26.
//

import SwiftUI

struct WelcomeQuoteView: View {
    
    let fireColor = Color(red: 254/255, green: 252/255, blue: 50/255)
    
    let welcomeQuoe: String = "Life is not about having everything figured out. It is about creating space for unexpected things to happen."
    
    let wecomeAuthor: String = "Joyeux Antoine"
    
    @EnvironmentObject var coorinator : AppCoodinator
    
    @StateObject var quoteFetchAPI = QuoteFetchAPI()
    
    var body: some View {
        VStack {
            
            BigTextView(text: welcomeQuoe)

            Button("Goto home") {
                coorinator.goToHome()
            }
            
            HStack {
                Spacer()
                Image(firesample)
                    .resizable()
                    .frame(width: 130, height: 50)
                    .mask {
                        Text(wecomeAuthor)
                            .font(.footnote.italic().bold())
                    }
                
                
                
            }
            .task {
//                quoteFetchAPI.fetchData()
//                quoteFetchAPI.fetchQuote()
                
//                quoteFetchAPI.testZip()
            
            }
        }
        .padding()
    }
}

#Preview {
    WelcomeQuoteView()
}
