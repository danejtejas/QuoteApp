//
//  PostListView.swift
//  QuoteApp
//
//  Created by Tejas on 21/04/26.
//

import SwiftUI



struct PostListView: View {
    
    @EnvironmentObject var coordinator : AppCoodinator
    
    @StateObject var vm = PostViewModel()
    
    var body: some View {
        ZStack{
            Text("Post List")
            
            Button("Go To Home"){
                coordinator.goToHome()
            }
            
            List {
                ForEach(vm.posts) { item in
                    Text(item.title)
                        .onAppear {
                            vm.loadMore(currentPost: item)
                        }
                }
                .onAppear {
                    vm.loadMore(currentPost: nil)
                }
            }
            if vm.isLoading {
                HStack {
                    Spacer()
                    ProgressView("Loading more...")
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    PostListView()
}


