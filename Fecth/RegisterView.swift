import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var confirmEmail = "" // Novo campo de confirmação de email
    @State private var password = ""
    @State private var confirmPassword = "" // Novo campo de confirmação de senha
    @State private var role = "tecnico"
    @State private var nome = ""
    @State private var tel = ""
    @State private var city = ""
    @State private var endereco = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false // Estado para controlar o indicador de carregamento

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
            
            TextField("Confirme o Email", text: $confirmEmail) // Campo de confirmação de email
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Senha", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Confirme a Senha", text: $confirmPassword) // Campo de confirmação de senha
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Picker("Role", selection: $role) {
                Text("Tecnico").tag("tecnico")
                Text("Admin").tag("admin")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if isLoading { // Mostra o indicador de carregamento enquanto isLoading for true
                ProgressView()
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

        guard let url = URL(string: "https://c238-2001-8a0-7309-4a00-95cb-fa61-647d-31c8.ngrok-free.app/api/src/register.php") else { return }
        
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

    // Função para limpar os campos
    func clearFields() {
        email = ""
        confirmEmail = ""
        password = ""
        confirmPassword = ""
        nome = ""
        tel = ""
        city = ""
        endereco = ""
        role = "tecnico"
    }
}
