//
//  RootView.swift
//  QuoteApp
//
//  Created by Tejas on 21/04/26.
//

import SwiftUI



struct RootView: View {
    @StateObject var coordinator = AppCoodinator()
    
    var body: some View {
        
        NavigationStack(path: $coordinator.paths) {
            WelcomeQuoteView()
                
                .navigationDestination(
                    for: AppCoodinator.Screen.self) { screen in
                        
                        switch screen {
                        case .detail(let id):
                                PostListView()
                            
                        case .home:
                            ContentView()
                        }
                        
                        
                    }
        }.environmentObject(coordinator)
    }
}

#Preview {
    RootView()
}
