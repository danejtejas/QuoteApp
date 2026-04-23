//
//  TestView.swift
//  QuoteApp
//
//  Created by Tejas on 22/04/26.
//


import SwiftUI
import Combine

class TestViewModel: ObservableObject {
    
    @Published var user : [String] = []
    
    init() {
        print("TestViewModel init called")
    }
    
    func fetch() async {
       try? await Task.sleep(nanoseconds: 200000000)
        
        await MainActor.run {
            self.user = ["Tejas" , "Rame", "Shivam"]
        }
        
        
        
    }
}


struct TestView : View {
    @StateObject var vm = TestViewModel()
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    init() {
        print("Test init called")
    }
    
    var body: some View {
       
        NavigationStack {
            VStack{
                
                List(vm.user, id:\.self ) { u in
                    NavigationLink(destination: TestView2(name: u)) {
                        Text(u)
                    }
                }
               
                
            }
            .onAppear() {
                    print("TestView View appears")
                }
            
            .task {
                await vm.fetch()
            }
            .onDisappear {
                print("TestView View disappears")
            }
        }
       
        
        
    }
}


#Preview {
    TestView()
}



struct TestView2 : View {
    let name : String
    
    init(name: String) {
        self.name = name
        print("TestView2 -> init")
    }
    
    var body: some View {
       
     
            VStack{
                Text("Hello, World! TestView2")
            }
 
        
        .onAppear() {
                print("TestView2 View appears")
            }
        .onDisappear {
            print("TestView2View disappears")
        }
    }
}


//#Preview {
//    TestView2(name: "Abc")
//}
