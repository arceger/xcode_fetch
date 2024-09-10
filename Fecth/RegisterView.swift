import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var confirmEmail = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var role = "tecnico"
    @State private var nome = ""
    @State private var tel = ""
    @State private var city = ""
    @State private var endereco = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false // Para controlar a ampulheta de carregamento

    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)
                .padding()

            TextField("Nome", text: $nome)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Telefone", text: $tel)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Cidade", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Endereço", text: $endereco)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Confirme o Email", text: $confirmEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Confirme o Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Picker("Role", selection: $role) {
                Text("Tecnico").tag("tecnico")
                Text("Admin").tag("admin")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if isLoading {
                ProgressView() // Mostra uma ampulheta enquanto carrega
                    .padding()
            } else {
                Button("Register") {
                    register()
                }
                .padding()
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Registration"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func register() {
        // Validação dos campos
        guard !email.isEmpty, !password.isEmpty, !nome.isEmpty, !tel.isEmpty, !city.isEmpty, !endereco.isEmpty else {
            alertMessage = "Todos os campos são obrigatórios."
            showingAlert = true
            return
        }
        
        // Validação de confirmação de email e senha
        guard email == confirmEmail else {
            alertMessage = "Os emails não coincidem."
            showingAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "As senhas não coincidem."
            showingAlert = true
            return
        }
        
        isLoading = true // Inicia o carregamento
        
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            alertMessage = "API URL não configurada corretamente."
            showingAlert = true
            return
        }

        guard let url = URL(string: "\(baseURL)register.php") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let json: [String: Any] = [
            "email": email,
            "password": password,
            "role": role,
            "nome": nome,
            "tel": tel,
            "city": city,
            "endereco": endereco
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false // Finaliza o carregamento

                if let error = error {
                    print("Error: \(error)")
                    self.alertMessage = "Network error. Please try again."
                    self.showingAlert = true
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    self.alertMessage = "" // Limpa a mensagem anterior
                    switch httpResponse.statusCode {
                    case 201:
                        self.alertMessage = "Registration successful!"
                        clearFields() // Limpa os campos após o registro bem-sucedido
                    case 400:
                        self.alertMessage = "Bad Request. Please check your input."
                    case 409:
                        self.alertMessage = "Email already registered. Please use a different email."
                    case 401:
                        self.alertMessage = "Unauthorized. Please check your credentials."
                    default:
                        self.alertMessage = "Unexpected error. Please try again."
                    }
                    self.showingAlert = true
                }
            }
        }.resume()
    }

    func clearFields() {
        // Limpa os campos após o registro bem-sucedido
        email = ""
        confirmEmail = ""
        password = ""
        confirmPassword = ""
        nome = ""
        tel = ""
        city = ""
        endereco = ""
    }
}
