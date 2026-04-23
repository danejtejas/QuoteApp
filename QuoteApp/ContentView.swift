//
//  ContentView.swift
//  QuoteApp
//
//  Created by Tejas on 18/04/26.
//

import SwiftUI

let screenWidth = UIScreen.main.bounds.width

struct ContentView: View {
    
    @EnvironmentObject var coordinator:  AppCoodinator
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Image(simpleEclipse)
                    .resizable()
                    .scaledToFit()
                   
                Spacer()
                  
                WelcomeQuoteView()
                
                Spacer()
                
//                BigTextView(text: "Welcome")
                
                Spacer()
                
                NormalTextView(text: "Welcome to the your dailsy does of inspiration")
                
                Spacer()
                Spacer()
                
                GoToNextView(text: "Generate Quote")
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}


struct BigTextView: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .frame(width: screenWidth * 0.8)
    }
}


struct NormalTextView: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.title3)
            .foregroundStyle(.white)
    }
}


struct GoToNextView: View {
    let text: String
    var body: some View {
        HStack {
            Text(text)
            Image(systemName: "arrow.forward")
        }
        .foregroundStyle(.black)
        .padding()
        .background(.white)
        .cornerRadius(10)
        .padding()
    }
}

