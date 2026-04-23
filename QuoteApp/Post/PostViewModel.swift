//
//  PostViewModel.swift
//  QuoteApp
//
//  Created by Tejas on 21/04/26.
//

import SwiftUI
import Combine


struct Post : Codable, Identifiable {
    
    let userId: Int
    let id  : Int
    let  title: String
    let body   : String
    
}

class PostViewModel : ObservableObject {
    
    var page : Int = 1
    
    @Published var posts : [Post] = []
    
    @Published var errorMessage : String = ""
    @Published var isLoading : Bool = false
    
    var hasMoreData : Bool = true
    
    var cancellable = Set<AnyCancellable>()
    
    func loadMore(currentPost : Post?)  {
        print("load More")
        guard let post = currentPost else {
            fetchPost()
            return
        }
        
        
        if post.id == posts.last!.id {
            fetchPost()
        }
    }
    
    
    func fetchTaskWithThrowingContunioi() async {
        
//        await withThrowingContinuation { continuation in
//            
//        }
//        
//        
//        
//        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
//        let task =  URLSession.shared.dataTask(with: url)
//        
//        await withTaskCancellationHandler {
//            task.cancel()
//        } operation: {
//           try await withCheckedThrowingContinuation {  conu in
//                task.resume()
//            }
//        }


        
    }
    
    
    func fetcTas(completon : @escaping (Data?, URLResponse?, Error?) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let task =  URLSession.shared.dataTask(with: url)
        
        { (data, response, error) in
            if let error = error {
                print("Error \(error)")
                return
            }
            
            guard let data = data else {
                return
            }
            
//            DispatchQueue.main.async { in
//                completon(data, response, error)
//            }
        }
        task.resume()
        
    }
    
    
    @MainActor
    func fetchPost()  {
        print("fetchPost ")
        defer{
            isLoading = false

        }
        
        guard !isLoading && hasMoreData else {
            return
        }
    
        isLoading = true
        errorMessage = ""
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts?_page=\(page)")!
        let urlCache = URLCache(memoryCapacity: 2000, diskCapacity: 2000)
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = urlCache
        configuration.requestCachePolicy = .returnCacheDataElseLoad
       
        
       
        URLSession.shared.dataTaskPublisher(for: url)
//            .debounce(
//                for: .seconds(0.5),
//                scheduler: DispatchQueue.global()
//            )
            .map(\.data)
            .decode(type: [Post].self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { posts in
                self.hasMoreData = !posts.isEmpty
            })
            .receive(on: DispatchQueue.main)
            .sink { comple in
                self.isLoading = false
                switch comple {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error)
                    self.errorMessage = error.localizedDescription
                }
                
            } receiveValue: { posts in
                print(posts)
                
                if self.page == 1 {
                    self.posts = posts
                }
                else {
                    self.posts.append(contentsOf: posts)
                }
                
                self.page += 1
            }
            .store(in: &cancellable)
    }
}
