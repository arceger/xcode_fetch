import Foundation
import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @Binding var isLoggedIn: Bool
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    @AppStorage("loggedInUserName") var loggedInUserName: String = ""
    @AppStorage("loggedInUserRole") var loggedInUserRole: String = ""
    @AppStorage("loggedInUserEmail") var loggedInUserEmail: String = ""
    @AppStorage("authToken") var authToken: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .padding()

                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Button("Login") {
                        login()
                    }
                    .padding()
                }

                NavigationLink("Register", destination: RegisterView())
                    .padding()
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Login"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func login() {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            alertMessage = "API URL não configurada corretamente."
            showingAlert = true
            return
        }

        guard let url = URL(string: "\(baseURL)login") else {
            alertMessage = "URL inválida."
            showingAlert = true
            return
        }

        guard !username.isEmpty, !password.isEmpty else {
            alertMessage = "Username e senha não podem estar vazios."
            showingAlert = true
            return
        }

        isLoading = true

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let json: [String: Any] = [
            "username": username,
            "password": password
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    alertMessage = "Erro de rede: \(error.localizedDescription)"
                    showingAlert = true
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    alertMessage = "Resposta inválida do servidor."
                    showingAlert = true
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    alertMessage = "Sem dados na resposta."
                    showingAlert = true
                }
                return
            }

            // Debug útil
            print("Response:", String(data: data, encoding: .utf8) ?? "no body")

            if httpResponse.statusCode == 200 {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let token = jsonResponse["token"] as? String,
                       let user = jsonResponse["user"] as? [String: Any],
                       let username = user["username"] as? String,
                       let role = user["role"] as? String,
                       let email = user["email"] as? String {

                        DispatchQueue.main.async {
                            self.authToken = token
                            self.loggedInUserName = username
                            self.loggedInUserRole = role
                            self.loggedInUserEmail = email
                            self.isLoggedIn = true
                        }

                    } else {
                        DispatchQueue.main.async {
                            alertMessage = "Formato de resposta inválido."
                            showingAlert = true
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        alertMessage = "Erro ao interpretar resposta."
                        showingAlert = true
                    }
                }
            } else if httpResponse.statusCode == 401 {
                DispatchQueue.main.async {
                    alertMessage = "Credenciais inválidas."
                    showingAlert = true
                }
            } else {
                DispatchQueue.main.async {
                    alertMessage = "Erro inesperado (\(httpResponse.statusCode))."
                    showingAlert = true
                }
            }
        }.resume()
    }
}
