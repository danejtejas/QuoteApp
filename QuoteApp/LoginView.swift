//
//  LoginView.swift
//  QuoteApp
//
//  Created by Tejas on 20/04/26.
//

import SwiftUI
import Combine



enum APIError : Error {
    case serverError
}

class LoginViewModel : ObservableObject{
    
    var emailPublisher = PassthroughSubject<String, Never>()
    var passwordPublisher = PassthroughSubject<String, Never>()
    
    @Published var isValid: Bool = false
    
    @Published var query : String = ""
    
    
    var cancellables: Set<AnyCancellable> = []
    
    var data = ["Apple", "Chiku", "Orang", "Watermael"]
    
    @Published var  posts: [Post] = []
    
    var attempts : Int = 0
    
    init() {
        
        publisherSetup()
        setupDebounce()
    
    }
    
    func login() {
        apiCall()
            .retry(2)
            .catch { _ in Just(0).setFailureType(to: Error.self) }
            .sink { com in
                print(com)
            } receiveValue: { value in
                print("gotValue", value)
            }.store(in: &cancellables)


    }
    
    
    private func apiCall() -> AnyPublisher<Int, Error> {
         Future<Int, Error> { promise in
             if self.attempts < 3 {
                 self.attempts += 1
                promise(.failure(APIError.serverError))
            }
             else {
                 promise(.success(100))
             }
        }
         .eraseToAnyPublisher()
    }

    
    
    
    func setupDebounce() {
        $query.debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter{ !$0.isEmpty }
            .flatMap({query in
                return self.searchAPI(querty: query)
                    .catch { _ in
                        Just([])
                    }
            })
            .receive(on: DispatchQueue.main)
            .sink { com in
                print(com)
            } receiveValue: { value in
                self.posts = value
                print(value)
            }.store(in: &cancellables)

    }
    
    private func searchAPI(querty : String) ->  AnyPublisher<[Post], Error>  {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
    
        return  URLSession.shared.dataTaskPublisher(for: url!)
        .map(\.data)
            .decode(type: [Post].self, decoder: JSONDecoder())
            .handleEvents(
                receiveSubscription: {sus in
                    print("recevie Subscription ", sus)
                },
                
                receiveOutput: { values in
                    print("Received new value")
                },
                
                receiveCompletion : { comp in
                    
                    print(comp)
                },
                
                receiveCancel: {
                    print("recevi cancel")
                },
                
                
                receiveRequest: { request in
                    print(request)
                }
                
            )
            .eraseToAnyPublisher( )
        
    }
    
    private func publisherSetup() {
        emailPublisher.combineLatest( passwordPublisher)
            
            .sink(receiveValue: { [weak self](email, password) in
                guard let self = self else { return  }
                let value = self.validate(email: email, password: password)
                print(value)
                self.isValid = value
            }).store(in: &cancellables)
    }
    
    func validate(email : String, password: String) -> Bool {
        
        return isValidEmail(email: email) && isPasswordValid(
            password: password)
    }
    
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

   
    func isPasswordValid(password: String, name: String = "ABC") -> Bool {
        
        guard !password.isEmpty else { return false }
        
        let lowercasePassword = password.lowercased()
        let lowercaseName = name.lowercased()
        
        // Check if the password contains the name
        if lowercasePassword.contains(lowercaseName) {
            return false
        }
        
        if password.count < 4  { return false }
        
        // Additional password validation checks can be added here
        // For example, you can check for minimum length, required characters, etc.
        
        // If all checks pass, the password is considered valid
        return true
    }
    
    
    
}


struct LoginView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var isValid: Bool = false
    
    
    @StateObject var viewModel : LoginViewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            
            
            VStack {
                
                Spacer()
                Text("Login")
                    .font(.title)
                
                Form {
                    Section{
                        Text("Email Id")
                        TextField("Enter Emaild Id", text: $viewModel.query)
                            .onChange(of: email) {
                                print("emild = ", email)
                                viewModel.emailPublisher.send(email)
                            }
                    }
                    
                    Section{
                        Text("Password")
                        TextField("Enter Password", text: $password)
                            .onChange(of: password) {
                                print("pass => ", password)
                                viewModel.passwordPublisher.send(password)
                            }
                    }
                    
                    Button("Login"){
                        viewModel.login()
                    }
                    .font(.largeTitle)
                    .padding()
                    .foregroundStyle(.white)
                    .padding()
                    .clipShape(.capsule)
//                    .disabled(viewModel.isValid == false)
                    .background(viewModel.isValid ? .blue : .red)
                    
                    
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
}
    #Preview {
        LoginView()
    }
