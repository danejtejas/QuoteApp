//
//  Coodinator.swift
//  QuoteApp
//
//  Created by Tejas on 21/04/26.
//


import Foundation
import SwiftUI
import Combine

class AppCoodinator : ObservableObject {
    
    @Published var paths : [Screen] = []
    
    enum Screen : Hashable {
        case home
        case detail(id: String)
    }
    
    func goToHome() {
        paths.append(Screen.home)
    }
    
    func gotToDetils(id : String)  {
        paths.append(.detail(id: id))
    }
}
