//
//  Untitled.swift
//  QuoteApp
//
//  Created by Tejas on 20/04/26.
//
import Foundation
import Combine

struct Product : Codable, Identifiable {
    let id : Int
}

class QuoteFetchAPI : ObservableObject {
    
    let api = UserFetchAPI()
    var cancelables = Set<AnyCancellable>()
    @Published var posts: [String] = []
    func fetchData()  {
        
       

        api.fetchUser()
            .flatMap {
//                user -> AnyPublisher<[String],Error> in
//                print("Fetched User: \(user)")
                 self.api.fetchPosts(user: $0)
            }
            .sink { completion in
                print(completion)
            } receiveValue: { values in
                print(values)
                
            }
            .store(in: &cancelables)
        
    }
    
    
    func fetchQuote() {
        
        let url = URL(string: "https://fakestoreapi.com/products")!
//        let request = URLRequest(url: url!)
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global())
            .tryMap(\.data)
            .decode(type: [Product].self , decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { result in
                print(result)
            } receiveValue: { products in
                print(products)
            }
            .store(in: &cancelables)

            
    }
    
    func testMerge() {
        
//        Emits values as soon as any publisher emits
//        No waiting
        
        
        let p1 = PassthroughSubject<String, Never>()
        let p2 = PassthroughSubject<String, Never>()
        let p3 = PassthroughSubject<String, Never>()
        
        p1.merge(with: p2)
            .merge(with: p3)
            .sink(receiveValue: { print($0) })
            .store(in: &cancelables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            p1.send("1")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            p2.send("A")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            p2.send("B")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            p1.send("2")
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            p3.send("P3 10")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            p3.send("p3 11")
        }
       
        
    }
 
    
    func testZip() {
        
//        wait for other publisher
//        resule as combing
        
        
        let p1 = PassthroughSubject<String, Never>()
        let p2 = PassthroughSubject<String, Never>()
//        let p3 = PassthroughSubject<String, Never>()
        
        p1.zip(p2)
            .sink(receiveValue: { value in
                print(value)
                
            })
            .store(in: &cancelables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            p1.send("1")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            p2.send("A")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            p2.send("B")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            p1.send("2")
        }
        
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            p3.send("P3 10")
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            p3.send("p3 11")
//        }
       
        
    }
    
}


class UserFetchAPI {
    func fetchUser() -> AnyPublisher<String, Error> {
        
        return Just("User1")
            .delay(for: .seconds(1), scheduler: DispatchQueue.global())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        
    }
    func fetchPosts(user: String) -> AnyPublisher<[String], Error> {
        let data : [String] = ["P1","p2", "p3", "p4", "p5"]
        return Just(data)
            .delay(for: .seconds(1), scheduler: DispatchQueue.global())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
    }
}




