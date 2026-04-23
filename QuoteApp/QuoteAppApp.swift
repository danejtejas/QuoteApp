//
//  QuoteAppApp.swift
//  QuoteApp
//
//  Created by Tejas on 18/04/26.
//

import SwiftUI

@main
struct QuoteAppApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            RootView()
            
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            switch newValue {
            case .active:
                print("App is appearing")
            case .background:
                print("App is in the background")
            case .inactive:
                print("App is in the inactive")
            default:
                print("Default")
            }
        }
    }
}
