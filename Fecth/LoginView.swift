//import Foundation
//import SwiftUI
//
//struct LoginView: View {
//    @State private var email = ""
//    @State private var password = ""
//    @Binding var isLoggedIn: Bool
//    @State private var showingAlert = false
//    @State private var alertMessage = ""
//    @AppStorage("loggedInUserName") var loggedInUserName: String = ""
//    @AppStorage("loggedInUserRole") var loggedInUserRole: String = ""
//    @AppStorage("authToken") var authToken: String = ""
//    
//        var body: some View {
//            NavigationView {
//                VStack {
//                    Text("Login")
//                        .font(.largeTitle)
//                        .padding()
//    
//                    TextField("Email", text: $email)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding()
//    
//                    SecureField("Password", text: $password)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding()
//    
//                    Button("Login") {
//                        login()
//                    }
//                    .padding()
//    
//                    NavigationLink("Register", destination: RegisterView())
//                        .padding()
//    
//                }
//                .alert(isPresented: $showingAlert) {
//                    Alert(title: Text("Login"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//                }
//            }
//        }
//
//
//    func login() {
//        guard let url = URL(string: "https://c238-2001-8a0-7309-4a00-95cb-fa61-647d-31c8.ngrok-free.app/api/src/login.php") else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        
//        guard !email.isEmpty, !password.isEmpty else {
//            alertMessage = "Email and password cannot be empty."
//            showingAlert = true
//            return
//        }
//        
//        let json: [String: Any] = ["email": email, "password": password]
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//        
//        request.httpBody = jsonData
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if error != nil {
//                DispatchQueue.main.async {
//                    self.alertMessage = "Network error. Please try again."
//                    self.showingAlert = true
//                }
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse {
//                if httpResponse.statusCode == 200 {
//                    if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                        // Captura o nome, papel e token do usuário
//                        if let name = jsonResponse["name"] as? String,
//                           let role = jsonResponse["role"] as? String,
//                           let token = jsonResponse["token"] as? String {
//                            DispatchQueue.main.async {
//                                self.loggedInUserName = name
//                                self.loggedInUserRole = role
//                                self.authToken = token // Armazenando o token
//                                self.isLoggedIn = true
//                            }
//                        } else {
//                            DispatchQueue.main.async {
//                                self.alertMessage = "Invalid response format."
//                                self.showingAlert = true
//                            }
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            self.alertMessage = "Unable to parse server response."
//                            self.showingAlert = true
//                        }
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.alertMessage = "Invalid email or password."
//                        self.showingAlert = true
//                    }
//                }
//            }
//        }.resume()
//    }
//}



import Foundation
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @Binding var isLoggedIn: Bool
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @AppStorage("loggedInUserName") var loggedInUserName: String = ""
    @AppStorage("loggedInUserRole") var loggedInUserRole: String = ""
    @AppStorage("authToken") var authToken: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .padding()

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Login") {
                    login()
                }
                .padding()

                NavigationLink("Register", destination: RegisterView())
                    .padding()
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Login"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func login() {
        // Recupera a URL base do Info.plist
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            alertMessage = "API URL não configurada corretamente."
            showingAlert = true
            return
        }
        
        let loginURL = "\(baseURL)login.php"
        
        guard let url = URL(string: loginURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Email e senha não podem estar vazios."
            showingAlert = true
            return
        }
        
        let json: [String: Any] = ["email": email, "password": password]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.alertMessage = "Erro de rede. Por favor, tente novamente."
                    self.showingAlert = true
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        // Captura o nome, papel e token do usuário
                        if let name = jsonResponse["name"] as? String,
                           let role = jsonResponse["role"] as? String,
                           let token = jsonResponse["token"] as? String {
                            DispatchQueue.main.async {
                                self.loggedInUserName = name
                                self.loggedInUserRole = role
                                self.authToken = token // Armazenando o token
                                self.isLoggedIn = true
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.alertMessage = "Formato de resposta inválido."
                                self.showingAlert = true
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.alertMessage = "Não foi possível interpretar a resposta do servidor."
                            self.showingAlert = true
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.alertMessage = "Email ou senha inválidos."
                        self.showingAlert = true
                    }
                }
            }
        }.resume()
    }
}
